import 'dart:io';
import 'dart:ffi';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcodelyze_desktop/models/qr_data_provider.dart';
import 'package:qrcodelyze_desktop/models/scan_history_provider.dart';
import 'package:qrcodelyze_desktop/models/settings_provider.dart';
import 'package:qrcodelyze_desktop/providers/scan_provider.dart';

/// テストの共通セットアップを提供するクラス
class TestSetup {
  /// テストの共通セットアップを実行
  static void setupAll() {
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
  }

  /// テスト用のMultiProviderを設定
  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QrDataProvider()),
        ChangeNotifierProvider(create: (_) => ScanHistoryProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: child,
        )
      ),
    );
  }
} 