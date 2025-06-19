import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/screens/generate_screen.dart';
import '../helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    TestSetup.setupAll();
  });

  group('GenerateScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestSetup.wrapWithProviders(
          const GenerateScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // UI要素が存在することを確認
      expect(find.byKey(const Key('qr_code_image_container')), findsOneWidget);
      expect(find.byKey(const Key('qr_code_text_content')), findsOneWidget);
      expect(find.byKey(const Key('qr_code_text_hint_text_clear_label')), findsOneWidget);

      // テキストフィールドが空であることを確認
      final textField = tester.widget<TextField>(find.byKey(const Key('qr_code_text_content')));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('テキスト入力とQRコードの更新テスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestSetup.wrapWithProviders(
          const GenerateScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // テキストフィールドに文字を入力
      const testText = 'テストテキスト';
      await tester.enterText(find.byKey(const Key('qr_code_text_content')), testText);
      await tester.pumpAndSettle();

      // テキストフィールドの値が正しく設定されていることを確認
      final textField = tester.widget<TextField>(find.byKey(const Key('qr_code_text_content')));
      expect(textField.controller?.text, testText);
    });

    testWidgets('ESCキーでのクリアテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestSetup.wrapWithProviders(
          const GenerateScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // テキストを入力
      const testText = 'テストテキスト';
      await tester.enterText(find.byKey(const Key('qr_code_text_content')), testText);
      await tester.pumpAndSettle();

      // ESCキーのキーアップイベントをシミュレート
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      // テキストフィールドがクリアされていることを確認
      final textField = tester.widget<TextField>(find.byKey(const Key('qr_code_text_content')));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('UI要素の存在確認テスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestSetup.wrapWithProviders(
          const GenerateScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // すべてのキーが付いた要素が存在することを確認
      expect(find.byKey(const Key('qr_code_image_container')), findsOneWidget);
      expect(find.byKey(const Key('qr_code_text_container')), findsOneWidget);
      expect(find.byKey(const Key('qr_code_text_content')), findsOneWidget);
      expect(find.byKey(const Key('qr_code_text_hint_text_clear_label')), findsOneWidget);
    });

  });
}