import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/main.dart';
import 'package:qrcodelyze_desktop/screens/generate_screen.dart';
import 'package:qrcodelyze_desktop/screens/scan_screen.dart';
import 'package:qrcodelyze_desktop/screens/log_view.dart';
import 'package:provider/provider.dart';
import 'package:qrcodelyze_desktop/models/qr_data_provider.dart';

void main() {
  group('MyHomePage Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => QrDataProvider(),
          child: const MaterialApp(home: MyHomePage(title: 'QR Codelyze')),
        ),
      );

      // 初期状態でGenerate画面が表示されていることを確認
      expect(find.byType(GenerateScreen), findsOneWidget);
      expect(find.byType(ScanScreen), findsNothing);

      // 切り替えボタンが表示されていることを確認
      expect(find.text('Generate'), findsOneWidget);
      expect(find.text('Scan'), findsOneWidget);

      // Generateボタンが無効化されていることを確認
      final generateButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate')
      );
      expect(generateButton.onPressed, isNull);

      // Scanボタンが有効化されていることを確認
      final scanButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Scan')
      );
      expect(scanButton.onPressed, isNotNull);

      // ログビューが表示されていることを確認
      expect(find.byType(LogView), findsOneWidget);
    });

    testWidgets('画面切り替えのテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => QrDataProvider(),
          child: const MaterialApp(home: MyHomePage(title: 'QR Codelyze')),
        ),
      );

      // 初期状態でGenerate画面が表示されていることを確認
      expect(find.byType(GenerateScreen), findsOneWidget);
      expect(find.byType(ScanScreen), findsNothing);

      // Scanボタンをタップ
      await tester.tap(find.text('Scan'));
      await tester.pump();

      // Scan画面に切り替わっていることを確認
      expect(find.byType(GenerateScreen), findsNothing);
      expect(find.byType(ScanScreen), findsOneWidget);

      // ボタンの状態が切り替わっていることを確認
      final generateButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate')
      );
      expect(generateButton.onPressed, isNotNull);

      final scanButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Scan')
      );
      expect(scanButton.onPressed, isNull);

      // Generateボタンをタップ
      await tester.tap(find.text('Generate'));
      await tester.pump();

      // Generate画面に戻っていることを確認
      expect(find.byType(GenerateScreen), findsOneWidget);
      expect(find.byType(ScanScreen), findsNothing);

      // ボタンの状態が元に戻っていることを確認
      final generateButton2 = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Generate')
      );
      expect(generateButton2.onPressed, isNull);

      final scanButton2 = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Scan')
      );
      expect(scanButton2.onPressed, isNotNull);
    });

    testWidgets('ログビューの展開/折りたたみテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => QrDataProvider(),
          child: const MaterialApp(home: MyHomePage(title: 'QR Codelyze')),
        ),
      );

      // 初期状態ではログビューが折りたたまれていることを確認
      expect(find.byType(LogView), findsOneWidget);
      final initialLogView = tester.widget<LogView>(find.byType(LogView));
      expect(initialLogView.expanded, false);

      // ログビューをダブルタップ
      final logViewFinder = find.byType(LogView);
      await tester.tap(logViewFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(logViewFinder);
      await tester.pumpAndSettle();

      // ログビューが展開されていることを確認
      final expandedLogView = tester.widget<LogView>(find.byType(LogView));
      expect(expandedLogView.expanded, true);

      // 再度ダブルタップ
      await tester.tap(logViewFinder);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(logViewFinder);
      await tester.pumpAndSettle();

      // ログビューが折りたたまれていることを確認
      final collapsedLogView = tester.widget<LogView>(find.byType(LogView));
      expect(collapsedLogView.expanded, false);
    });
  });
} 