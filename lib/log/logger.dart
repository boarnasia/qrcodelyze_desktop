import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

final Logger appLogger = Logger('QRcodelyze');

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
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    final level = record.level.name.padRight(7);
    print('[$level][$time] ${record.loggerName}: ${record.message}');
  });

  if (isDebugMode) {
    appLogger.info('デバッグモードでログ出力を有効化しました');
  }
} 