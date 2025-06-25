import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/models/barcode_format.dart';

void main() {
  group('BarcodeFormatData Tests', () {

    test('findByCodeメソッドのテスト', () {
      // QRCodeを検索 - flutter_zxingライブラリが返すQR Code形式
      final qrResult = BarcodeFormats.findByCode('QR Code');
      expect(qrResult, isNotNull);
      expect(qrResult!.name, equals('QR Code'));
      expect(qrResult.code, equals('QR Code'));

      // UPCAを検索
      final upcaResult = BarcodeFormats.findByCode('UPCA');
      expect(upcaResult, isNotNull);
      expect(upcaResult!.name, equals('UPC-A'));
      expect(upcaResult.code, equals('UPCA'));

      // EAN13を検索
      final ean13Result = BarcodeFormats.findByCode('EAN13');
      expect(ean13Result, isNotNull);
      expect(ean13Result!.name, equals('EAN-13'));
      expect(ean13Result.code, equals('EAN13'));
    });

    test('findByCodeメソッド - 正常化で一致', () {
      // ハイフンありで検索
      final upcaResult = BarcodeFormats.findByCode('UPC-A');
      expect(upcaResult, isNotNull);
      expect(upcaResult!.name, equals('UPC-A'));

      // スペースありで検索
      final qrResult = BarcodeFormats.findByCode('QR Code');
      expect(qrResult, isNotNull);
      expect(qrResult!.name, equals('QR Code'));

      // 大文字小文字混在で検索
      final aztecResult = BarcodeFormats.findByCode('Aztec');
      expect(aztecResult, isNotNull);
      expect(aztecResult!.name, equals('Aztec'));
    });

    test('findByCodeメソッド - 見つからない場合', () {
      final result = BarcodeFormats.findByCode('NonExistentFormat');
      expect(result, isNull);
    });

    test('codeフィールドが追加されていることを確認', () {
      final allFormats = BarcodeFormats.allFormats;
      
      // すべてのフォーマットにcodeフィールドがあることを確認
      for (final format in allFormats) {
        expect(format.code, isNotEmpty);
      }

      // 特定のフォーマットのcodeを確認
      final qrFormat = BarcodeFormats.getFormatByName('QR Code');
      expect(qrFormat.code, equals('QR Code'));

      final upcaFormat = BarcodeFormats.getFormatByName('UPC-A');
      expect(upcaFormat.code, equals('UPCA'));
    });

    test('既存のgetFormatByNameメソッドとの互換性', () {
      // 既存メソッドが正常に動作することを確認
      final qrFormat = BarcodeFormats.getFormatByName('QR Code');
      expect(qrFormat.name, equals('QR Code'));
      expect(qrFormat.format, equals(8192)); // Format.qrCode

      final upcaFormat = BarcodeFormats.getFormatByName('UPC-A');
      expect(upcaFormat.name, equals('UPC-A'));
      expect(upcaFormat.format, equals(16384)); // Format.upca
    });
  });
}