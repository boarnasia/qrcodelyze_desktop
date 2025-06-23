import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:image/image.dart' as img;
import '../models/image_source.dart';

/// Uint8List (PNG/JPEGなど) を RGBX形式に変換
Uint8List convertToRGBX(img.Image decoded) {
  final width = decoded.width;
  final height = decoded.height;
  final rgbxBytes = Uint8List(width * height * 4);
  var offset = 0;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final pixel = decoded.getPixel(x, y);
      // RGBAの値を正しく設定
      rgbxBytes[offset++] = pixel.r.toInt() & 0xFF;
      rgbxBytes[offset++] = pixel.g.toInt() & 0xFF;
      rgbxBytes[offset++] = pixel.b.toInt() & 0xFF;
      rgbxBytes[offset++] = pixel.a.toInt() & 0xFF; // アルファチャンネルも正しく設定
    }
  }

  return rgbxBytes;
}

class ImageProcessor {
  /// 画像ソースからQRコードをデコードする
  static Future<Code> decodeImageSource(ImageSource source) async {
    try {
      final rawImage = source.rawImage;
      if (rawImage == null) {
        return Code(isValid: false);
      }
      
      // RGBX形式で試行
      final imageData = convertToRGBX(rawImage);
      
      final params = DecodeParams(
        imageFormat: ImageFormat.rgbx,
        format: Format.any,
        width: rawImage.width,
        height: rawImage.height,
      );

      var result = zx.readBarcode(imageData, params);

      // RGBX形式で失敗した場合、グレースケール変換を試行
      if (!result.isValid) {
        final grayImage = img.grayscale(rawImage);
        final grayData = convertToRGBX(grayImage);
        
        final grayParams = DecodeParams(
          imageFormat: ImageFormat.rgbx,
          format: Format.any,
          width: grayImage.width,
          height: grayImage.height,
        );
        
        result = zx.readBarcode(grayData, grayParams);
      }

      return result;
    } catch (e) {
      return Code(isValid: false);
    }
  }
} 