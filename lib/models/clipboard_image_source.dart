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

        if (planes != 1) {
          throw Exception('サポート外のplanes数です: $planes');
        }

        if (bitCount != 32) {
          throw Exception('今回は32bit DIBのみ対応します: $bitCount');
        }

        final pixelDataOffset = headerSize;
        final bytesPerPixel = bitCount ~/ 8;
        final stride = ((width * bytesPerPixel + 3) ~/ 4) * 4;

        int redMask = 0x00FF0000;
        int greenMask = 0x0000FF00;
        int blueMask = 0x000000FF;
        int alphaMask = 0xFF000000;

        if (compression == 3) {
          // BI_BITFIELDS の場合、マスク値を取得
          final offset = 40; // BITMAPINFOHEADERの直後にマスクがある
          redMask = dibHeader.getUint32(offset, Endian.little);
          greenMask = dibHeader.getUint32(offset + 4, Endian.little);
          blueMask = dibHeader.getUint32(offset + 8, Endian.little);
          alphaMask = dibHeader.getUint32(offset + 12, Endian.little);
        } else if (compression != 0) {
          throw Exception('サポート外の圧縮形式です: $compression');
        }

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

        final image = img.Image(width: width, height: height);

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
} 