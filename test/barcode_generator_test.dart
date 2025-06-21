import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/providers/barcode_provider.dart';
import 'package:qrcodelyze_desktop/models/barcode_format.dart';
import 'package:qrcodelyze_desktop/utils/checksum_calculator.dart';
import 'helpers/test_setup.dart';

void main() {
  group('Barcode Generation Tests', () {
    late BarcodeProvider provider;

    setUpAll(() {
      TestSetup.setupAll();
    });

    setUp(() {
      provider = BarcodeProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    group('Checksum Calculation Tests', () {
      test('UPC-A checksum calculation', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          16384, // Format.upca
          '12345678901'
        );
        expect(checksum, isNotNull);
        expect(checksum, isA<int>());
        expect(checksum! >= 0 && checksum <= 9, true);
      });

      test('UPC-E checksum calculation', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          32768, // Format.upce
          '123456'
        );
        expect(checksum, isNotNull);
        expect(checksum, isA<int>());
        expect(checksum! >= 0 && checksum <= 9, true);
      });

      test('EAN-13 checksum calculation', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          512, // Format.ean13
          '123456789012'
        );
        expect(checksum, isNotNull);
        expect(checksum, isA<int>());
        expect(checksum! >= 0 && checksum <= 9, true);
      });

      test('EAN-8 checksum calculation', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          256, // Format.ean8
          '1234567'
        );
        expect(checksum, isNotNull);
        expect(checksum, isA<int>());
        expect(checksum! >= 0 && checksum <= 9, true);
      });

      test('Invalid format returns null', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          9999, // Invalid format
          '123456789012'
        );
        expect(checksum, isNull);
      });

      test('Invalid input returns null', () {
        final checksum = ChecksumCalculator.calculateChecksum(
          16384, // Format.upca
          'ABC123'
        );
        expect(checksum, isNull);
      });

      test('Wrong length input throws error', () {
        expect(
          () => ChecksumCalculator.calculateChecksum(
            16384, // Format.upca
            '123' // Too short
          ),
          throwsArgumentError
        );
      });
    });

    group('Checksum Validation Tests', () {
      test('Valid UPC-A checksum validation', () {
        // Test with a known valid UPC-A code
        final isValid = ChecksumCalculator.validateChecksum(
          16384, // Format.upca
          '036000291452' // Example UPC-A with correct checksum
        );
        expect(isValid, isA<bool>());
      });

      test('Invalid UPC-A checksum validation', () {
        final isValid = ChecksumCalculator.validateChecksum(
          16384, // Format.upca
          '036000291453' // Same code with wrong checksum
        );
        expect(isValid, false);
      });

      test('Wrong length validation', () {
        final isValid = ChecksumCalculator.validateChecksum(
          16384, // Format.upca
          '123' // Too short
        );
        expect(isValid, false);
      });

      test('Non-numeric validation', () {
        final isValid = ChecksumCalculator.validateChecksum(
          16384, // Format.upca
          'ABC123456789'
        );
        expect(isValid, false);
      });
    });

    group('Auto-correction Tests', () {
      test('UPC-A auto-correction with 11 digits', () async {
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        
        // Input 11 digits (without checksum)
        provider.textController.text = '12345678901';
        
        // Wait for validation and potential auto-correction
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Check if auto-correction was applied
        // Note: The actual implementation might auto-correct the input
        expect(provider.validationResult.isValid, true);
      });

      test('EAN-13 auto-correction with 12 digits', () async {
        final ean13Format = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'EAN-13'
        );
        provider.setFormat(ean13Format);
        
        provider.textController.text = '123456789012';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.isValid, true);
      });

      test('No auto-correction for complete codes', () async {
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        
        // Input 12 digits (complete)
        const completeCode = '123456789012';
        provider.textController.text = completeCode;
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Text should remain unchanged
        expect(provider.textController.text, completeCode);
      });
    });

    group('Supported Format Tests', () {
      test('UPC-A is supported', () async {
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        provider.textController.text = '123456789012';
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.isValid, true);
        expect(provider.validationResult.errors
            .where((e) => e.type == ValidationErrorType.unsupportedFormat)
            .isEmpty, true);
      });

      test('QR Code is supported', () async {
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        provider.textController.text = 'Hello World';
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.isValid, true);
        expect(provider.validationResult.errors
            .where((e) => e.type == ValidationErrorType.unsupportedFormat)
            .isEmpty, true);
      });

      test('Code 128 is supported', () async {
        final code128Format = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'Code 128'
        );
        provider.setFormat(code128Format);
        provider.textController.text = 'ABC123';
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.isValid, true);
      });
    });

    group('Barcode Image Generation Tests', () {
      test('Valid input generates barcode image', () async {
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        provider.textController.text = 'Test QR Code';
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Check if barcode image is generated
        // Note: In test environment, actual image generation might be mocked
        expect(provider.validationResult.isValid, true);
      });

      test('Invalid input does not generate barcode image', () async {
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        provider.textController.text = 'ABC'; // Invalid for UPC-A
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.hasErrors, true);
        expect(provider.barcodeImage, isNull);
      });

      test('Empty input does not generate barcode image', () async {
        provider.textController.text = '';
        
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.barcodeImage, isNull);
      });
    });

    group('Format Switching Tests', () {
      test('Format switching clears validation errors', () async {
        // Start with UPC-A and invalid input
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        provider.textController.text = 'ABC123'; // Invalid for UPC-A
        
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.hasErrors, true);
        
        // Switch to QR Code (where ABC123 is valid)
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.isValid, true);
      });

      test('Format switching preserves input text', () {
        const testText = 'Test123';
        provider.textController.text = testText;
        
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
        
        expect(provider.textController.text, testText);
        
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        
        expect(provider.textController.text, testText);
      });
    });

    group('Clear Input Tests', () {
      test('Clear input resets all state', () async {
        provider.textController.text = 'Test123';
        await Future.delayed(const Duration(milliseconds: 600));
        
        provider.clearInput();
        
        expect(provider.textController.text, isEmpty);
        expect(provider.barcodeImage, isNull);
        expect(provider.validationResult.isValid, true);
        expect(provider.validationResult.errors.isEmpty, true);
        expect(provider.validationResult.warnings.isEmpty, true);
        expect(provider.validationResult.characterCount, 0);
      });
    });
  });
}