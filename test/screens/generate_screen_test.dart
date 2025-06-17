import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/screens/generate_screen.dart';
import '../helpers/test_setup.dart';

void main() {
  setUpAll(() {
    TestSetup.setupAll();
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  group('GenerateScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TestSetup.wrapWithProviders(
            const GenerateScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 初期状態でQRコードが表示されていることを確認
      expect(find.byType(Image), findsOneWidget);
      //expect(find.byKey(const Key('qr_code_image')), findsOneWidget);
      //expect(find.byKey(const Key('qr_code_text_content')), findsOneWidget);
      //expect(find.byKey(const Key('qr_code_text_hint_text_clear_label')), findsOneWidget);

      // テキストフィールドが空であることを確認
      final textField = tester.widget<TextField>(find.byKey(const Key('qr_code_text_content')));
      expect(textField.controller?.text, isEmpty);
    });

    //testWidgets('テキスト入力とQRコードの更新テスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(
    //    TestSetup.wrapWithProviders(
    //      const GenerateScreen(),
    //    ),
    //  );
    //  await tester.pumpAndSettle();

    //  // テキストフィールドに文字を入力
    //  const testText = 'テストテキスト';
    //  await tester.enterText(find.byType(TextField), testText);
    //  await tester.pumpAndSettle();

    //  // テキストフィールドの値が正しく設定されていることを確認
    //  final textField = tester.widget<TextField>(find.byType(TextField));
    //  expect(textField.controller?.text, testText);
    //  
    //  // QRコードが表示されていることを確認
    //  expect(find.byType(QrImageView), findsOneWidget);

    //  // デバウンス時間を待つ
    //  await tester.pump(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs + 100));
    //  await tester.pumpAndSettle();

    //  // Providerの値が更新されていることを確認
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(GenerateScreen)),
    //    listen: false,
    //  );
    //  expect(qrDataProvider.qrData, testText);
    //});

    //testWidgets('ESCキーでのクリアテスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(
    //    TestSetup.wrapWithProviders(
    //      const GenerateScreen(),
    //    ),
    //  );
    //  await tester.pumpAndSettle();

    //  // テキストを入力
    //  const testText = 'テストテキスト';
    //  await tester.enterText(find.byType(TextField), testText);
    //  await tester.pumpAndSettle();

    //  // デバウンス時間を待つ
    //  await tester.pump(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs + 100));
    //  await tester.pumpAndSettle();

    //  // ESCキーのキーアップイベントをシミュレート
    //  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    //  await tester.pumpAndSettle();

    //  // テキストフィールドがクリアされていることを確認
    //  final textField = tester.widget<TextField>(find.byType(TextField));
    //  expect(textField.controller?.text, isEmpty);
    //  
    //  // QRコードが表示されていることを確認
    //  expect(find.byType(QrImageView), findsOneWidget);

    //  // Providerの値がクリアされていることを確認
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(GenerateScreen)),
    //    listen: false,
    //  );
    //  expect(qrDataProvider.qrData, isEmpty);
    //});

    //testWidgets('デバウンス処理のテスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(
    //    TestSetup.wrapWithProviders(
    //      const GenerateScreen(),
    //    ),
    //  );
    //  await tester.pumpAndSettle();

    //  // テキストフィールドに文字を入力
    //  const testText = 'テストテキスト';
    //  await tester.enterText(find.byType(TextField), testText);
    //  await tester.pumpAndSettle();

    //  // デバウンス時間より短い時間で更新
    //  await tester.enterText(find.byType(TextField), '${testText}2');
    //  await tester.pump(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs - 100));

    //  // Providerの値がまだ更新されていないことを確認
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(GenerateScreen)),
    //    listen: false,
    //  );
    //  expect(qrDataProvider.qrData, isEmpty);

    //  // デバウンス時間を待つ
    //  await tester.pump(Duration(milliseconds: 200));
    //  await tester.pumpAndSettle();

    //  // Providerの値が更新されていることを確認
    //  expect(qrDataProvider.qrData, '${testText}2');
    //});

    //testWidgets('長いテキストのテスト', (WidgetTester tester) async {
    //  await tester.pumpWidget(
    //    TestSetup.wrapWithProviders(
    //      const GenerateScreen(),
    //    ),
    //  );
    //  await tester.pumpAndSettle();

    //  // 長いテキストを入力
    //  const longText = 'これは非常に長いテキストです。'
    //      'QRコードの生成に影響がないことを確認するためのテストです。'
    //      '十分な長さのテキストを入力して、QRコードの生成が正しく行われることを確認します。';
    //  
    //  await tester.enterText(find.byType(TextField), longText);
    //  await tester.pump(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs + 100));
    //  await tester.pumpAndSettle();

    //  // QRコードが表示されていることを確認
    //  expect(find.byType(QrImageView), findsOneWidget);

    //  // Providerの値が正しく設定されていることを確認
    //  final qrDataProvider = Provider.of<QrDataProvider>(
    //    tester.element(find.byType(GenerateScreen)),
    //    listen: false,
    //  );
    //  expect(qrDataProvider.qrData, longText);
    //});
  });
}