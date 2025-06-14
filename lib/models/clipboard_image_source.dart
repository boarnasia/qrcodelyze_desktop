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
        
        // DIB形式から画像データに変換
        final dibHeader = bytes.buffer.asByteData();
        final width = dibHeader.getInt32(4, Endian.little);
        final rawHeight = dibHeader.getInt32(8, Endian.little);
        final height = rawHeight.abs();
        final bitCount = dibHeader.getInt16(14, Endian.little);
        final pixelDataOffset = 40; // BITMAPINFOHEADERのサイズで固定
        final bytesPerPixel = bitCount ~/ 8;
        final stride = ((width * bytesPerPixel + 3) ~/ 4) * 4; // 4バイト境界
        
        if (bitCount != 24 && bitCount != 32) {
          throw Exception('サポートされていないビット深度です: $bitCount');
        }
        
        final image = img.Image(width: width, height: height);
        
        for (var y = 0; y < height; y++) {
          final srcY = rawHeight > 0 ? (height - 1 - y) : y;
          for (var x = 0; x < width; x++) {
            final offset = pixelDataOffset + srcY * stride + x * bytesPerPixel;
            final b = bytes[offset];
            final g = bytes[offset + 1];
            final r = bytes[offset + 2];
            final a = bitCount == 32 ? bytes[offset + 3] : 255;
            image.setPixelRgba(x, y, r, g, b, a);
          }
        }
        
        _imageData = Uint8List.fromList(img.encodeJpg(image));
        logFine('クリップボードから画像を読み込みました: ${width}x$height');
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