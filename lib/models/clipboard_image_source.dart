import 'dart:typed_data';
import 'dart:ffi';
import 'package:win32/win32.dart';
import 'package:image/image.dart' as img;
import 'image_source.dart';
import '../log/log_wrapper.dart';

/// クリップボードからの画像入力ソース
class ClipboardImageSource implements ImageSource {
  Uint8List? _imageData;
  
  @override
  String get sourceName => 'クリップボード';

  @override
  Future<Uint8List> getImageData() async {
    if (_imageData != null) {
      return _imageData!;
    }

    if (OpenClipboard(NULL) == 0) {
      throw Exception('クリップボードを開けませんでした');
    }

    try {
      final handle = GetClipboardData(CF_DIB);
      if (handle == 0) {
        throw Exception('クリップボードに画像データがありません');
      }

      final handlePtr = Pointer<Void>.fromAddress(handle);
      final size = GlobalSize(handlePtr);
      if (size == 0) {
        throw Exception('クリップボードデータのサイズ取得に失敗しました');
      }

      final pointer = GlobalLock(handlePtr);
      if (pointer == nullptr) {
        throw Exception('クリップボードデータのロックに失敗しました');
      }

      try {
        final bytes = Uint8List(size);
        for (var i = 0; i < size; i++) {
          bytes[i] = pointer.cast<Uint8>().elementAt(i).value;
        }

        final dibHeader = bytes.buffer.asByteData();
        final headerSize = dibHeader.getInt32(0, Endian.little);
        final width = dibHeader.getInt32(4, Endian.little);
        final rawHeight = dibHeader.getInt32(8, Endian.little);
        final height = rawHeight.abs();
        final planes = dibHeader.getInt16(12, Endian.little);
        final bitCount = dibHeader.getInt16(14, Endian.little);
        final compression = dibHeader.getInt32(16, Endian.little);
        final imageSize = dibHeader.getInt32(20, Endian.little);

        if (planes != 1) {
          throw Exception('サポート外のplanes数です: $planes');
        }

        final pixelDataOffset = headerSize;
        final image = img.Image(width: width, height: height);

        if (compression == 0) {
          // BI_RGB
          if (bitCount != 24 && bitCount != 32) {
            throw Exception('サポート外のビット深度です: $bitCount');
          }

          final bytesPerPixel = bitCount ~/ 8;
          final stride = calculateStride(width: width, height: height,
                                         bytesPerPixel: bytesPerPixel, imageSize: imageSize);

          for (var y = 0; y < height; y++) {
            final srcY = rawHeight > 0 ? (height - 1 - y) : y;
            for (var x = 0; x < width; x++) {
              final offset = pixelDataOffset + srcY * stride + x * bytesPerPixel;
              final b = bytes[offset];
              final g = bytes[offset + 1];
              final r = bytes[offset + 2];
              final a = (bitCount == 32) ? bytes[offset + 3] : 255;
              image.setPixelRgba(x, y, r, g, b, a);
            }
          }

        } else if (compression == 3) {
          // BI_BITFIELDS (マスク式、前回までの処理)
          if (bitCount != 32) {
            throw Exception('BITFIELDSは32bitのみサポートします: $bitCount');
          }

          final offset = 40; // BITMAPINFOHEADERの直後にマスク情報
          final redMask = dibHeader.getUint32(offset, Endian.little);
          final greenMask = dibHeader.getUint32(offset + 4, Endian.little);
          final blueMask = dibHeader.getUint32(offset + 8, Endian.little);
          final alphaMask = dibHeader.getUint32(offset + 12, Endian.little);

          int _maskShift(int mask) {
            if (mask == 0) return 0;
            int shift = 0;
            while ((mask & 1) == 0) {
              mask >>= 1;
              shift++;
            }
            return shift;
          }

          final redShift = _maskShift(redMask);
          final greenShift = _maskShift(greenMask);
          final blueShift = _maskShift(blueMask);
          final alphaShift = _maskShift(alphaMask);

          final bytesPerPixel = 4;
          final stride = ((width * bytesPerPixel + 3) ~/ 4) * 4;

          for (var y = 0; y < height; y++) {
            final srcY = rawHeight > 0 ? (height - 1 - y) : y;
            for (var x = 0; x < width; x++) {
              final offset = pixelDataOffset + srcY * stride + x * bytesPerPixel;
              final pixel = bytes.buffer.asByteData().getUint32(offset, Endian.little);

              final r = ((pixel & redMask) >> redShift) & 0xFF;
              final g = ((pixel & greenMask) >> greenShift) & 0xFF;
              final b = ((pixel & blueMask) >> blueShift) & 0xFF;
              final a = (alphaMask != 0) ? ((pixel & alphaMask) >> alphaShift) & 0xFF : 255;

              image.setPixelRgba(x, y, r, g, b, a);
            }
          }

        } else if (compression == 4 || compression == 5) {
          // BI_JPEG / BI_PNG
          // 埋め込みバイト列を直接抽出してflutter_imageで復元
          final compressedData = bytes.sublist(pixelDataOffset, pixelDataOffset + imageSize);
          final decoded = img.decodeImage(compressedData);
          if (decoded == null) {
            throw Exception('JPEG/PNG埋め込みのデコードに失敗しました');
          }
          _imageData = Uint8List.fromList(img.encodeJpg(decoded));
          logFine('クリップボード (JPEG/PNG埋め込み) 読み込み成功');
          return _imageData!;
        } else {
          throw Exception('未対応の圧縮形式です: $compression');
        }

        _imageData = Uint8List.fromList(img.encodeJpg(image));
        logFine('クリップボード画像読み込み成功: ${width}x$height');
        return _imageData!;
      } finally {
        GlobalUnlock(handlePtr);
      }
    } finally {
      CloseClipboard();
    }
  }


  @override
  Future<Uint8List> getPreviewData() async {
    final data = await getImageData();
    // プレビュー用に画像をリサイズ
    final image = img.decodeImage(data);
    if (image == null) {
      throw Exception('画像のデコードに失敗しました');
    }
    
    final resized = img.copyResize(
      image,
      width: 300,  // プレビュー用の適度なサイズ
      height: 300,
    );
    
    return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  }

  int calculateStride({
    required int width,
    required int height,
    required int bytesPerPixel,
    required int imageSize,
  }) {
    if (imageSize != 0) {
      return imageSize ~/ height;
    }
    int rawStride = width * bytesPerPixel;
    if (rawStride % 4 == 0) {
      return rawStride;
    }
    return ((width * bytesPerPixel + 3) ~/ 4) * 4;
  }
} 