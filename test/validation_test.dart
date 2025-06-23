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

    group('QR Code Validation Tests', () {
      setUp(() {
        // Set format to QR Code
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
      });

      test('Valid QR Code with ASCII text', () async {
        provider.textController.text = 'Hello World';
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.isValid, true);
      });

      test('Valid QR Code with Japanese text', () async {
        provider.textController.text = 'こんにちは世界';
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.isValid, true);
      });

      test('QR Code with very long text should show warning', () async {
        provider.textController.text = 'A' * 6000; // Approaching limit (> 80% of 7089)
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.hasWarnings, true);
      });

      test('QR Code exceeding absolute limit', () async {
        provider.textController.text = 'A' * 7500; // Over limit (7089)
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.first.type, 
               ValidationErrorType.lengthExceeded);
      });
    });

    group('Empty Input Tests', () {
      test('Empty input validation behavior', () async {
        provider.textController.text = '';
        await Future.delayed(const Duration(milliseconds: 600));
        expect(provider.validationResult, isNotNull);
        expect(provider.validationResult.characterCount, 0);
      });
    });

    group('Real-time Validation Tests', () {
      test('Validation should be triggered after text change', () async {
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        
        provider.textController.text = '123';
        
        // Simulate the debounce delay
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.characterCount, 3);
      });

      test('Multiple rapid changes should only validate once', () async {
        final qrFormat = BarcodeFormats.allFormats.firstWhere(
          (format) => format.name == 'QR Code'
        );
        provider.setFormat(qrFormat);
        
        // Rapid changes
        provider.textController.text = '1';
        provider.textController.text = '12';
        provider.textController.text = '123';
        
        // Wait less than debounce delay
        await Future.delayed(const Duration(milliseconds: 200));
        
        // Should still be initial state
        expect(provider.validationResult.characterCount, 0);
        
        // Wait for debounce
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Should now have validated the final text
        expect(provider.validationResult.characterCount, 3);
      });
    });
  });
}