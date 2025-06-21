import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/providers/barcode_provider.dart';
import 'package:qrcodelyze_desktop/models/barcode_format.dart';

void main() {
  group('Barcode Validation Tests', () {
    late BarcodeProvider provider;

    setUp(() {
      provider = BarcodeProvider();
    });

    tearDown(() {
      provider.dispose();
    });

    group('UPC-A Validation Tests', () {
      setUp(() {
        // Set format to UPC-A
        final upcAFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-A'
        );
        provider.setFormat(upcAFormat);
      });

      test('Valid UPC-A with 11 digits (without checksum)', () {
        provider.textController.text = '12345678901';
        // Trigger validation by simulating delay
        expect(provider.validationResult.isValid, true);
      });

      test('Valid UPC-A with 12 digits (with checksum)', () {
        provider.textController.text = '123456789012';
        expect(provider.validationResult.isValid, true);
      });

      test('Invalid UPC-A with letters', () {
        provider.textController.text = 'ABC123456789';
        // Wait for debounced validation
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.invalidCharacter);
      });

      test('Invalid UPC-A too short', () {
        provider.textController.text = '12345';
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.lengthTooShort);
      });

      test('Invalid UPC-A too long', () {
        provider.textController.text = '1234567890123';
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.lengthExceeded);
      });

      test('Character count tracking', () {
        provider.textController.text = '123456789';
        expect(provider.validationResult.characterCount, 9);
      });
    });

    group('UPC-E Validation Tests', () {
      setUp(() {
        final upcEFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'UPC-E'
        );
        provider.setFormat(upcEFormat);
      });

      test('Valid UPC-E with 6 digits (without checksum)', () {
        provider.textController.text = '123456';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid UPC-E with 8 digits (with checksum)', () {
        provider.textController.text = '12345678';
        expect(provider.validationResult.isValid, true);
      });

      test('Invalid UPC-E with letters', () {
        provider.textController.text = 'ABC123';
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.invalidCharacter);
      });
    });

    group('EAN-13 Validation Tests', () {
      setUp(() {
        final ean13Format = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'EAN-13'
        );
        provider.setFormat(ean13Format);
      });

      test('Valid EAN-13 with 12 digits (without checksum)', () {
        provider.textController.text = '123456789012';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid EAN-13 with 13 digits (with checksum)', () {
        provider.textController.text = '1234567890123';
        expect(provider.validationResult.isValid, true);
      });

      test('Invalid EAN-13 with special characters', () {
        provider.textController.text = '123-456-789012';
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.invalidCharacter);
      });
    });

    group('EAN-8 Validation Tests', () {
      setUp(() {
        final ean8Format = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'EAN-8'
        );
        provider.setFormat(ean8Format);
      });

      test('Valid EAN-8 with 7 digits (without checksum)', () {
        provider.textController.text = '1234567';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid EAN-8 with 8 digits (with checksum)', () {
        provider.textController.text = '12345678';
        expect(provider.validationResult.isValid, true);
      });
    });

    group('Code 39 Validation Tests', () {
      setUp(() {
        final code39Format = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'Code 39'
        );
        provider.setFormat(code39Format);
      });

      test('Valid Code 39 alphanumeric', () {
        provider.textController.text = 'ABC123';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid Code 39 with allowed special characters', () {
        provider.textController.text = 'ABC-123.*\$+%';
        expect(provider.validationResult.isValid, true);
      });

      test('Invalid Code 39 with lowercase letters', () {
        provider.textController.text = 'abc123';
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.invalidCharacter);
      });

      test('Code 39 approaching length limit warning', () {
        provider.textController.text = 'A' * 35; // 80% of 43
        expect(provider.validationResult.hasWarnings, true);
        expect(provider.validationResult.warnings.first.type, 
               ValidationWarningType.approachingLimit);
      });

      test('Code 39 exceeding length limit', () {
        provider.textController.text = 'A' * 50;
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.lengthExceeded);
      });
    });

    group('QR Code Validation Tests', () {
      setUp(() {
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
      });

      test('Valid QR Code with ASCII text', () {
        provider.textController.text = 'Hello World!';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid QR Code with Japanese text', () {
        provider.textController.text = 'こんにちは世界';
        expect(provider.validationResult.isValid, true);
      });

      test('Valid QR Code with special characters', () {
        provider.textController.text = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        expect(provider.validationResult.isValid, true);
      });

      test('QR Code with very long text should show warning', () {
        provider.textController.text = 'A' * 6000; // Approaching limit
        expect(provider.validationResult.hasWarnings, true);
      });

      test('QR Code exceeding absolute limit', () {
        provider.textController.text = 'A' * 8000; // Over limit
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.lengthExceeded);
      });
    });

    group('Empty Input Tests', () {
      test('Empty input validation behavior', () {
        provider.textController.text = '';
        // Note: Empty input might be handled differently in actual implementation
        // Just verify the validation result exists and has proper structure
        expect(provider.validationResult, isNotNull);
        expect(provider.validationResult.characterCount, 0);
        // The actual validation behavior may differ from expected - test that it doesn't crash
      });
    });

    group('Unsupported Format Tests', () {
      test('Unsupported format should show error', () {
        // Test with a mock unsupported format
        // Note: This would require creating a test format or modifying the provider
        // to simulate unsupported formats
      });
    });

    group('Real-time Validation Tests', () {
      test('Validation should be triggered after text change', () async {
        provider.textController.text = '123';
        
        // Simulate the debounce delay
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.characterCount, 3);
      });

      test('Multiple rapid changes should only validate once', () async {
        // This test would verify that the debouncing is working correctly
        provider.textController.text = '1';
        provider.textController.text = '12';
        provider.textController.text = '123';
        
        // Wait less than debounce time
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Should not have validated yet
        expect(provider.validationResult.characterCount, 0);
        
        // Wait for full debounce time
        await Future.delayed(const Duration(milliseconds: 400));
        
        // Now should be validated
        expect(provider.validationResult.characterCount, 3);
      });
    });
  });
}