import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

final Logger appLogger = Logger('QRcodelyze');

/// ログエントリ
class LogEntry {
  final DateTime timestamp;
  final String message;
  final Level level;

  LogEntry(this.message, this.level) : timestamp = DateTime.now();
}

/// ログバッファ（最新logBufferSize件まで保持）
class LogBuffer {
  final int maxLength;
  final List<LogEntry> _buffer = [];
  final _controller = StreamController<List<LogEntry>>.broadcast();

  LogBuffer(this.maxLength) {
    _controller.add(List.unmodifiable(_buffer));
  }

  Stream<List<LogEntry>> get stream => _controller.stream;

  void add(String message, [Level level = Level.INFO]) {
    final entry = LogEntry(message, level);
    _buffer.add(entry);
    if (_buffer.length > maxLength) {
      _buffer.removeAt(0);
    }
    _controller.add(List.unmodifiable(_buffer));
  }

  List<LogEntry> get logs => List.unmodifiable(_buffer);

  LogEntry? get latest => _buffer.isNotEmpty ? _buffer.last : null;

  void dispose() {
    _controller.close();
  }
}

final LogBuffer appLogBuffer = LogBuffer(1000); // AppConstants.logBufferSizeはimportできないため数値直書き

/// ログレベルを文字列から解析する
Level _parseLogLevel(String name) {
  switch (name.toUpperCase()) {
    case 'ALL':
      return Level.ALL;
    case 'INFO':
      return Level.INFO;
    case 'WARNING':
      return Level.WARNING;
    case 'SEVERE':
      return Level.SEVERE;
    case 'OFF':
      return Level.OFF;
    default:
      return Level.INFO;
  }
}

/// ログ初期化関数
/// [args] コマンドライン引数
void initLogging(List<String> args) {
  // デバッグビルドの場合は自動的にverboseモードを有効にする
  const isDebugMode = kDebugMode;
  final enableLogging = args.contains('--log') || 
                       args.contains('--verbose') || 
                       isDebugMode;
  
  if (!enableLogging) {
    Logger.root.level = Level.OFF;
    return;
  }

  final levelArg = args.firstWhere(
    (arg) => arg.startsWith('--log-level='),
    orElse: () => '--log-level=INFO',
  );

  final logLevel = args.contains('--verbose') || isDebugMode
      ? Level.ALL
      : _parseLogLevel(levelArg.split('=').last);

  Logger.root.level = logLevel;

  if (isDebugMode) {
    appLogger.info('デバッグモードでログ出力を有効化しました');
  }
} 