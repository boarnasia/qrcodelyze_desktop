import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/log/log_wrapper.dart';
import 'package:qrcodelyze_desktop/log/logger.dart';
import 'package:logging/logging.dart';

void main() {
  group('Logging System Tests', () {
    setUp(() {
      // Clear any existing logs before each test
      // Note: appLogBuffer is a global singleton, so we need to work with it
    });

    group('Log Wrapper Function Tests', () {
      test('logInfo should work without throwing', () {
        expect(() => logInfo('Test info message'), returnsNormally);
      });

      test('logWarning should work without throwing', () {
        expect(() => logWarning('Test warning message'), returnsNormally);
      });

      test('logSevere should work without throwing', () {
        expect(() => logSevere('Test severe message'), returnsNormally);
      });
    });

    group('LogBuffer Tests', () {
      late LogBuffer testBuffer;

      setUp(() {
        testBuffer = LogBuffer(10);
      });

      tearDown(() {
        testBuffer.dispose();
      });

      test('LogBuffer should initialize correctly', () {
        expect(testBuffer.logs, isEmpty);
        expect(testBuffer.latest, isNull);
      });

      test('LogBuffer should add entries correctly', () {
        const testMessage = 'Test message';
        testBuffer.add(testMessage, Level.INFO);
        
        expect(testBuffer.logs.length, 1);
        expect(testBuffer.latest, isNotNull);
        expect(testBuffer.latest!.message, testMessage);
        expect(testBuffer.latest!.level, Level.INFO);
      });

      test('LogBuffer should respect max length', () {
        final buffer = LogBuffer(3);
        
        buffer.add('Message 1', Level.INFO);
        buffer.add('Message 2', Level.INFO);
        buffer.add('Message 3', Level.INFO);
        buffer.add('Message 4', Level.INFO); // Should remove first
        
        expect(buffer.logs.length, 3);
        expect(buffer.logs.first.message, 'Message 2');
        expect(buffer.latest!.message, 'Message 4');
        
        buffer.dispose();
      });

      test('LogBuffer should handle different log levels', () {
        testBuffer.add('Info message', Level.INFO);
        testBuffer.add('Warning message', Level.WARNING);
        testBuffer.add('Severe message', Level.SEVERE);
        
        expect(testBuffer.logs.length, 3);
        expect(testBuffer.logs[0].level, Level.INFO);
        expect(testBuffer.logs[1].level, Level.WARNING);
        expect(testBuffer.logs[2].level, Level.SEVERE);
      });

      test('LogEntry should have timestamp', () {
        const testMessage = 'Test with timestamp';
        final beforeAdd = DateTime.now();
        testBuffer.add(testMessage, Level.INFO);
        final afterAdd = DateTime.now();
        
        final entry = testBuffer.latest!;
        expect(entry.timestamp.isAfter(beforeAdd.subtract(const Duration(seconds: 1))), true);
        expect(entry.timestamp.isBefore(afterAdd.add(const Duration(seconds: 1))), true);
      });

      test('LogBuffer stream should emit updates', () async {
        bool streamUpdated = false;
        
        testBuffer.stream.listen((logs) {
          if (logs.isNotEmpty) {
            streamUpdated = true;
          }
        });
        
        testBuffer.add('Test message', Level.INFO);
        
        // Give the stream a moment to emit
        await Future.delayed(const Duration(milliseconds: 10));
        expect(streamUpdated, true);
      });
    });

    group('Global Log Buffer Tests', () {
      test('appLogBuffer should be accessible', () {
        expect(appLogBuffer, isNotNull);
        expect(appLogBuffer.logs, isA<List<LogEntry>>());
      });

      test('Log wrapper functions should add to global buffer', () {
        final initialCount = appLogBuffer.logs.length;
        
        logInfo('Test global buffer');
        
        // Check if log was added
        expect(appLogBuffer.logs.length, greaterThan(initialCount));
        
        // Check if the message is in recent logs
        final recentLogs = appLogBuffer.logs.length >= 5 
            ? appLogBuffer.logs.sublist(appLogBuffer.logs.length - 5)
            : appLogBuffer.logs;
        final hasMessage = recentLogs.any((log) => log.message.contains('Test global buffer'));
        expect(hasMessage, true);
      });
    });

    group('Validation Error Logging Integration Tests', () {
      test('logSevere should handle Japanese error messages', () {
        const errorMessage = '入力エラー: 無効な文字が含まれています: A, B, C';
        
        expect(() => logSevere(errorMessage), returnsNormally);
        
        // Check if message was logged
        final recentLogs = appLogBuffer.logs.length >= 5 
            ? appLogBuffer.logs.sublist(appLogBuffer.logs.length - 5)
            : appLogBuffer.logs;
        final hasMessage = recentLogs.any((log) => 
          log.message.contains('無効な文字') && 
          log.level == Level.SEVERE
        );
        expect(hasMessage, true);
      });

      test('logInfo should handle success messages', () {
        const successMessage = 'バーコードを生成しました: QR Code - Hello World';
        
        expect(() => logInfo(successMessage), returnsNormally);
        
        final recentLogs = appLogBuffer.logs.length >= 5 
            ? appLogBuffer.logs.sublist(appLogBuffer.logs.length - 5)
            : appLogBuffer.logs;
        final hasMessage = recentLogs.any((log) => 
          log.message.contains('バーコードを生成') && 
          log.level == Level.INFO
        );
        expect(hasMessage, true);
      });

      test('logInfo should handle checksum calculation messages', () {
        const checksumMessage = 'チェックサムを自動計算しました: 5 (完全なコード: 123456789015)';
        
        expect(() => logInfo(checksumMessage), returnsNormally);
        
        final recentLogs = appLogBuffer.logs.length >= 5 
            ? appLogBuffer.logs.sublist(appLogBuffer.logs.length - 5)
            : appLogBuffer.logs;
        final hasMessage = recentLogs.any((log) => 
          log.message.contains('チェックサムを自動計算') && 
          log.level == Level.INFO
        );
        expect(hasMessage, true);
      });
    });

    group('Log Initialization Tests', () {
      test('initLogging should handle different arguments', () {
        expect(() => initLogging([]), returnsNormally);
        expect(() => initLogging(['--log']), returnsNormally);
        expect(() => initLogging(['--verbose']), returnsNormally);
        expect(() => initLogging(['--log-level=INFO']), returnsNormally);
      });

      test('Logger level should be configurable', () {
        // Test that we can set different log levels
        Logger.root.level = Level.INFO;
        expect(Logger.root.level, Level.INFO);
        
        Logger.root.level = Level.WARNING;
        expect(Logger.root.level, Level.WARNING);
        
        // Reset to original state
        Logger.root.level = Level.INFO;
      });
    });

    group('Log Entry Properties Tests', () {
      test('LogEntry should have all required properties', () {
        const testMessage = 'Test log entry';
        final entry = LogEntry(testMessage, Level.INFO);
        
        expect(entry.message, testMessage);
        expect(entry.level, Level.INFO);
        expect(entry.timestamp, isA<DateTime>());
        expect(entry.timestamp.isBefore(DateTime.now().add(const Duration(seconds: 1))), true);
      });

      test('LogEntry with different levels should work', () {
        final infoEntry = LogEntry('Info', Level.INFO);
        final warningEntry = LogEntry('Warning', Level.WARNING);
        final severeEntry = LogEntry('Severe', Level.SEVERE);
        
        expect(infoEntry.level, Level.INFO);
        expect(warningEntry.level, Level.WARNING);
        expect(severeEntry.level, Level.SEVERE);
      });
    });
  });
}