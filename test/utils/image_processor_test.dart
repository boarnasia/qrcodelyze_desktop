import 'dart:io';
import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as path;
import 'package:qrcodelyze_desktop/models/file_image_source.dart';
import 'package:qrcodelyze_desktop/utils/image_processor.dart';

void main() {
  setUpAll(() {
    // DLLのパスを設定
    final dllPath = path.join(
      Directory.current.path,
      'test',
      'fixtures',
      'windows',
      'runner',
      'resources',
      'flutter_zxing.dll',
    );
    if (Platform.isWindows) {
      // DLLを直接読み込む
      DynamicLibrary.open(dllPath);
    }
  });

  group('ImageProcessor', () {
    late String fixturesPath;

    setUp(() {
      fixturesPath = 'test/fixtures/qr_codes';
    });

    test('有効なQRコードをデコードできる', () async {
      final file = XFile('$fixturesPath/valid_qr.png');
      final source = FileImageSource(file: file);
      await source.getPreviewData(); // rawImageを設定するために必要

      final result = await ImageProcessor.decodeImageSource(source);
      expect(result.isValid, true);
      expect(result.text, isNotNull);
      expect(result.format, isNotNull);
    });

    test('無効なQRコードはデコードできない', () async {
      final file = XFile('$fixturesPath/invalid_qr.png');
      final source = FileImageSource(file: file);
      await source.getPreviewData(); // rawImageを設定するために必要

      final result = await ImageProcessor.decodeImageSource(source);
      expect(result.isValid, false);
    });

    test('空の画像はデコードできない', () async {
      final file = XFile('$fixturesPath/empty.png');
      final source = FileImageSource(file: file);
      await source.getPreviewData(); // rawImageを設定するために必要

      final result = await ImageProcessor.decodeImageSource(source);
      expect(result.isValid, false);
    });
  });

  group('convertToRGBX', () {
    test('画像をRGBX形式に変換できる', () {
      final image = img.Image(width: 2, height: 2);
      image.setPixel(0, 0, img.ColorRgb8(255, 0, 0));
      image.setPixel(1, 0, img.ColorRgb8(0, 255, 0));
      image.setPixel(0, 1, img.ColorRgb8(0, 0, 255));
      image.setPixel(1, 1, img.ColorRgb8(255, 255, 255));

      final rgbx = convertToRGBX(image);
      expect(rgbx.length, 16); // 2x2x4 bytes

      // 最初のピクセル（赤）
      expect(rgbx[0], 255); // R
      expect(rgbx[1], 0);   // G
      expect(rgbx[2], 0);   // B
      expect(rgbx[3], 255); // A

      // 2番目のピクセル（緑）
      expect(rgbx[4], 0);   // R
      expect(rgbx[5], 255); // G
      expect(rgbx[6], 0);   // B
      expect(rgbx[7], 255); // A

      // 3番目のピクセル（青）
      expect(rgbx[8], 0);   // R
      expect(rgbx[9], 0);   // G
      expect(rgbx[10], 255); // B
      expect(rgbx[11], 255); // A

      // 4番目のピクセル（白）
      expect(rgbx[12], 255); // R
      expect(rgbx[13], 255); // G
      expect(rgbx[14], 255); // B
      expect(rgbx[15], 255); // A
    });
  });
} 