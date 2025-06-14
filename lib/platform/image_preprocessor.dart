import 'package:image/image.dart' as img;
import 'dart:math';

class ImagePreprocessor {
  final img.Image sourceImage;

  ImagePreprocessor(this.sourceImage);

  img.Image preprocessForQrScan() {
    // ① コントラスト強化
    final contrastAdjusted = img.adjustColor(sourceImage, contrast: 1.5);

    // ② ガンマ逆補正
    final gammaCorrected = _applyInverseGamma(contrastAdjusted, gamma: 2.2);

    // ③ ヒストグラムストレッチ
    final stretched = _histogramStretch(gammaCorrected);

    // ④ グレースケール化
    final grayscaleImage = img.grayscale(stretched);

    // ⑤ シャープネス強調 (任意)
    final sharpened = img.convolution(grayscaleImage, filter: [
      0, -1, 0,
      -1, 5, -1,
      0, -1, 0,
    ]);

    // ⑥ 二値化処理（ここが今回の核心追加）
    final binaryImage = img.Image.from(sharpened);
    for (int y = 0; y < binaryImage.height; y++) {
      for (int x = 0; x < binaryImage.width; x++) {
        final pixel = binaryImage.getPixel(x, y);
        final luma = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b).toInt();
        final v = luma < 128 ? 0 : 255;
        binaryImage.setPixelRgba(x, y, v, v, v, pixel.a);
      }
    }

    return binaryImage;
  }

  img.Image _applyInverseGamma(img.Image image, {double gamma = 2.2}) {
    final corrected = img.Image.from(image);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = (pow(pixel.r / 255.0, 1 / gamma) * 255).clamp(0, 255).toInt();
        final g = (pow(pixel.g / 255.0, 1 / gamma) * 255).clamp(0, 255).toInt();
        final b = (pow(pixel.b / 255.0, 1 / gamma) * 255).clamp(0, 255).toInt();
        corrected.setPixelRgba(x, y, r, g, b, pixel.a);
      }
    }
    return corrected;
  }

  img.Image _histogramStretch(img.Image image, {double cut = 0.05}) {
    final rValues = <int>[], gValues = <int>[], bValues = <int>[];

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        rValues.add(pixel.r.toInt());
        gValues.add(pixel.g.toInt());
        bValues.add(pixel.b.toInt());
      }
    }

    rValues.sort();
    gValues.sort();
    bValues.sort();

    int indexMin = (rValues.length * cut).toInt();
    int indexMax = (rValues.length * (1 - cut)).toInt();

    int rMin = rValues[indexMin], rMax = rValues[indexMax];
    int gMin = gValues[indexMin], gMax = gValues[indexMax];
    int bMin = bValues[indexMin], bMax = bValues[indexMax];

    final stretched = img.Image.from(image);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = _stretch(pixel.r.toInt(), rMin, rMax);
        final g = _stretch(pixel.g.toInt(), gMin, gMax);
        final b = _stretch(pixel.b.toInt(), bMin, bMax);
        stretched.setPixelRgba(x, y, r, g, b, pixel.a);
      }
    }
    return stretched;
  }

  int _stretch(int v, int min, int max) {
    if (max == min) return v;
    return (((v - min) * 255) / (max - min)).clamp(0, 255).toInt();
  }
}
