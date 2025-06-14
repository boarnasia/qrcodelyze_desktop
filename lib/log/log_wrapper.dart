import 'package:logging/logging.dart';
import 'logger.dart';

/// ログ出力のラッパー関数群
/// 発信元情報（関数名・ファイル・行番号）を含めたログを出力します

/// INFOレベルのログを出力
void logInfo(String message) => _log(Level.INFO, message);

/// WARNINGレベルのログを出力
void logWarning(String message) => _log(Level.WARNING, message);

/// FINEレベルのログを出力（デバッグ情報用）
void logFine(String message) => _log(Level.FINE, message);

/// FINERレベルのログを出力（デバッグ情報用）
void logFiner(String message) => _log(Level.FINER, message);

/// SEVEREレベルのログを出力（エラー用）
void logSevere(String message) => _log(Level.SEVERE, message);

/// 内部ログ出力関数
/// [level] ログレベル
/// [message] ログメッセージ
void _log(Level level, String message) {
  final trace = StackTrace.current.toString().split('\n');
  // スタックトレースの3行目（インデックス2）が呼び出し元の情報
  final caller = trace.length > 2 ? trace[2].trim() : 'unknown';
  appLogger.log(level, '$message → at $caller');

  if (level == Level.INFO) appLogBuffer.add(message);
} 