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
      rgbxBytes[offset++] = pixel.r.toInt();
      rgbxBytes[offset++] = pixel.g.toInt();
      rgbxBytes[offset++] = pixel.b.toInt();
      rgbxBytes[offset++] = 255;
    }
  }

  return rgbxBytes;
}

class ImageProcessor {
  /// 画像ソースからQRコードをデコードする
  static Future<Code> decodeImageSource(ImageSource source) async {
    final rawImage = source.rawImage!;
    final imageData = convertToRGBX(rawImage);
    final params = DecodeParams(
      imageFormat: ImageFormat.rgbx,
      format: Format.any,
      width: rawImage.width,
      height: rawImage.height,
    );

    final result = zx.readBarcode(imageData, params);

    return result;
  }
} 