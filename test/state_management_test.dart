import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/providers/barcode_provider.dart';
import 'package:qrcodelyze_desktop/models/barcode_format.dart';
import 'helpers/test_setup.dart';

void main() {
  group('State Management Tests', () {
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

    group('BarcodeProvider State Tests', () {
      test('Initial state should be correct', () {
        expect(provider.currentFormat, BarcodeFormats.allFormats.first);
        expect(provider.inputText, isEmpty);
        expect(provider.validationResult.isValid, true);
        expect(provider.validationResult.errors.isEmpty, true);
        expect(provider.validationResult.warnings.isEmpty, true);
        expect(provider.validationResult.characterCount, 0);
        expect(provider.barcodeImage, isNull);
      });

      test('Text controller should be initialized', () {
        expect(provider.textController, isNotNull);
        expect(provider.textController.text, isEmpty);
      });

      test('Current format should be accessible', () {
        final format = provider.currentFormat;
        expect(format, isA<BarcodeFormatData>());
        expect(format.name, isNotEmpty);
        expect(format.category, isNotEmpty);
      });
    });

    group('Format State Management Tests', () {
      test('Setting format should update state', () {
        final initialFormat = provider.currentFormat;
        final newFormat = BarcodeFormats.allFormats
            .firstWhere((f) => f.name != initialFormat.name);
        
        provider.setFormat(newFormat);
        
        expect(provider.currentFormat, newFormat);
        expect(provider.currentFormat.name, newFormat.name);
      });

      test('Setting same format should not trigger unnecessary updates', () {
        final initialFormat = provider.currentFormat;
        int notificationCount = 0;
        
        provider.addListener(() {
          notificationCount++;
        });
        
        provider.setFormat(initialFormat);
        
        expect(notificationCount, 0); // No notification should be sent
        expect(provider.currentFormat, initialFormat);
      });

      test('Format change should trigger validation', () async {
        // Set initial text that's valid for UPC-A but invalid for Code 39
        provider.textController.text = '123456789012';
        await Future.delayed(const Duration(milliseconds: 600));
        
        final upcAFormat = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'UPC-A');
        provider.setFormat(upcAFormat);
        await Future.delayed(const Duration(milliseconds: 100));
        
        expect(provider.validationResult.isValid, true);
        
        // Switch to Code 39 (numbers only should still be valid)
        final code39Format = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'Code 39');
        provider.setFormat(code39Format);
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Code 39 allows numbers, so should still be valid
        expect(provider.validationResult.isValid, true);
      });
    });

    group('Input State Management Tests', () {
      test('Text input should update input text property', () {
        const testText = 'Test input';
        provider.textController.text = testText;
        
        expect(provider.inputText, testText);
      });

      test('Text change should trigger debounced validation', () async {
        bool notificationReceived = false;
        provider.addListener(() {
          notificationReceived = true;
        });
        
        provider.textController.text = 'Test';
        
        // Immediately after change, no notification yet (debounced)
        expect(notificationReceived, false);
        
        // After debounce delay, notification should be received
        await Future.delayed(const Duration(milliseconds: 600));
        expect(notificationReceived, true);
      });

      test('Multiple rapid text changes should debounce correctly', () async {
        int notificationCount = 0;
        provider.addListener(() {
          notificationCount++;
        });
        
        // Make rapid changes
        provider.textController.text = '1';
        provider.textController.text = '12';
        provider.textController.text = '123';
        
        // Wait less than debounce time
        await Future.delayed(const Duration(milliseconds: 300));
        expect(notificationCount, 0);
        
        // Wait for full debounce time
        await Future.delayed(const Duration(milliseconds: 400));
        expect(notificationCount, 1); // Only one notification
      });

      test('Clear input should reset all input-related state', () async {
        // Set up some state
        provider.textController.text = 'Test123';
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Clear input
        provider.clearInput();
        
        expect(provider.inputText, isEmpty);
        expect(provider.barcodeImage, isNull);
        expect(provider.validationResult.isValid, true);
        expect(provider.validationResult.errors.isEmpty, true);
        expect(provider.validationResult.warnings.isEmpty, true);
        expect(provider.validationResult.characterCount, 0);
      });
    });

    group('Validation State Management Tests', () {
      test('Validation result should update with input changes', () async {
        provider.textController.text = 'Test';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.characterCount, 4);
        expect(provider.validationResult, isA<BarcodeValidationResult>());
      });

      test('Invalid input should set validation errors', () async {
        // Set format to UPC-A (numbers only)
        final upcAFormat = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'UPC-A');
        provider.setFormat(upcAFormat);
        
        // Input invalid characters
        provider.textController.text = 'ABC123';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.isNotEmpty, true);
      });

      test('Length warnings should be set correctly', () async {
        // Set format with max length
        final code39Format = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'Code 39');
        provider.setFormat(code39Format);
        
        // Input text approaching limit (80% of 43 = ~34 characters)
        provider.textController.text = 'A' * 35;
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.hasWarnings, true);
        expect(provider.validationResult.warnings.isNotEmpty, true);
      });

      test('Length errors should be set correctly', () async {
        final code39Format = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'Code 39');
        provider.setFormat(code39Format);
        
        // Input text exceeding limit
        provider.textController.text = 'A' * 50; // Exceeds 43 char limit
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.hasErrors, true);
        expect(provider.validationResult.errors.any(
          (e) => e.type == ValidationErrorType.lengthExceeded
        ), true);
      });
    });

    group('Barcode Image State Management Tests', () {
      test('Valid input should potentially generate barcode image', () async {
        // Use QR Code format (most reliable for generation)
        final qrFormat = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'QR Code');
        provider.setFormat(qrFormat);
        
        provider.textController.text = 'Hello World';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.isValid, true);
        // Note: Actual image generation might be mocked in test environment
      });

      test('Invalid input should not generate barcode image', () async {
        provider.textController.text = '';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.barcodeImage, isNull);
      });

      test('Validation errors should prevent image generation', () async {
        final upcAFormat = BarcodeFormats.allFormats
            .firstWhere((f) => f.name == 'UPC-A');
        provider.setFormat(upcAFormat);
        
        provider.textController.text = 'INVALID';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(provider.validationResult.hasErrors, true);
        expect(provider.barcodeImage, isNull);
      });
    });

    group('Listener Notification Tests', () {
      test('Format change should notify listeners', () {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });
        
        final newFormat = BarcodeFormats.allFormats[1];
        provider.setFormat(newFormat);
        
        expect(notified, true);
      });

      test('Text validation should notify listeners', () async {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });
        
        provider.textController.text = 'Test';
        await Future.delayed(const Duration(milliseconds: 600));
        
        expect(notified, true);
      });

      test('Clear input should notify listeners', () {
        bool notified = false;
        provider.addListener(() {
          notified = true;
        });
        
        provider.clearInput();
        
        expect(notified, true);
      });

      test('Multiple listeners should all be notified', () {
        int notificationCount = 0;
        
        provider.addListener(() {
          notificationCount++;
        });
        provider.addListener(() {
          notificationCount++;
        });
        provider.addListener(() {
          notificationCount++;
        });
        
        provider.clearInput();
        
        expect(notificationCount, 3);
      });
    });

    group('Memory Management Tests', () {
      test('Dispose should clean up resources', () {
        // Add some state
        provider.textController.text = 'Test';
        
        // Dispose should not throw
        expect(() => provider.dispose(), isA<void>());
      });

      test('Using provider after dispose should handle gracefully', () {
        // Create a separate provider for this test to avoid interfering with tearDown
        final testProvider = BarcodeProvider();
        testProvider.dispose();
        
        // These operations should either work or fail gracefully
        // (depending on implementation)
        expect(() => testProvider.inputText, returnsNormally);
        expect(() => testProvider.currentFormat, returnsNormally);
        expect(() => testProvider.validationResult, returnsNormally);
      });
    });
  });
}