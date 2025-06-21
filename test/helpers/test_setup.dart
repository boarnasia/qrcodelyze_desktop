import 'dart:io';
import 'dart:ffi';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcodelyze_desktop/models/qr_data_provider.dart';
import 'package:qrcodelyze_desktop/providers/scan_provider.dart';
import 'package:qrcodelyze_desktop/providers/barcode_provider.dart';

/// テストの共通セットアップを提供するクラス
class TestSetup {
  /// テストの共通セットアップを実行
  static void setupAll() {
    // flutter_zxingの初期化は行わない（テスト環境ではスキップ）
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
    if (Platform.isWindows && File(dllPath).existsSync()) {
      try {
        // DLLを直接読み込む
        DynamicLibrary.open(dllPath);
        print('dll loaded');
      } catch (e) {
        // テスト環境でDLLが見つからない場合はスキップ
        print('Warning: flutter_zxing.dll not found for testing: $e');
      }
    }
  }

  /// テスト用のMultiProviderを設定
  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QrDataProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => BarcodeProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: child,
        )
      ),
    );
  }
} 