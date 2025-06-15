import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qrcodelyze_desktop/screens/scan_screen.dart';
import 'package:qrcodelyze_desktop/models/qr_data_provider.dart';
import 'package:qrcodelyze_desktop/constants/app_constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (_) => QrDataProvider(),
      child: const MaterialApp(home: ScanScreen()),
    );
  }

  group('ScanScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 初期状態でカメラプレビューが表示されていることを確認
      expect(find.byType(ScanScreen), findsOneWidget);
      expect(find.byKey(const Key('scan_instruction_text')), findsOneWidget);
      expect(find.byKey(const Key('scan_result_help_text')), findsOneWidget);
    });

    //testWidgets('スキャン結果の表示テスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(createTestWidget());
    //  await tester.pumpAndSettle();

    //  // スキャン結果をシミュレート
    //  const scannedText = 'スキャンされたテキスト';
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(ScanScreen)),
    //    listen: false,
    //  );
    //  qrDataProvider.updateQrData(scannedText);
    //  await tester.pumpAndSettle();

    //  // スキャン結果が表示されていることを確認
    //  expect(find.text(scannedText), findsOneWidget);
    //  //expect(find.text('QRコードをスキャン中...'), findsNothing);
    //});

    //testWidgets('スキャン結果のクリアテスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(createTestWidget());
    //  await tester.pumpAndSettle();

    //  // スキャン結果をシミュレート
    //  const scannedText = 'スキャンされたテキスト';
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(ScanScreen)),
    //    listen: false,
    //  );
    //  qrDataProvider.updateQrData(scannedText);
    //  await tester.pumpAndSettle();

    //  // スキャン結果が表示されていることを確認
    //  expect(find.text(scannedText), findsOneWidget);

    //  // ESCキーでクリア
    //  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    //  await tester.pumpAndSettle();

    //  // スキャン結果がクリアされ、スキャン中の表示に戻ることを確認
    //  expect(find.text(scannedText), findsNothing);
    //  expect(find.text('QRコードをスキャン中...'), findsOneWidget);
    //  expect(qrDataProvider.qrData, isEmpty);
    //});

    //testWidgets('長いスキャン結果のテスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(createTestWidget());
    //  await tester.pumpAndSettle();

    //  // 長いスキャン結果をシミュレート
    //  const longText = 'これは非常に長いスキャン結果のテキストです。'
    //      'QRコードスキャン機能が長いテキストを正しく処理できることを確認するためのテストです。'
    //      '十分な長さのテキストをスキャンして、表示が正しく行われることを確認します。';
    //  
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(ScanScreen)),
    //    listen: false,
    //  );
    //  qrDataProvider.updateQrData(longText);
    //  await tester.pumpAndSettle();

    //  // 長いスキャン結果が表示されていることを確認
    //  expect(find.text(longText), findsOneWidget);
    //  expect(find.text('QRコードをスキャン中...'), findsNothing);
    //});
  });
} 