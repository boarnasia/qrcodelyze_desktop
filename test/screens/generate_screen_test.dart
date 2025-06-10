import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcodelyze_desktop/screens/generate_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GenerateScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GenerateScreen()));

      // 初期状態でQRコードが表示されていることを確認
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('テキスト入力とQRコードの更新テスト', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GenerateScreen()));

      // テキストフィールドに文字を入力
      await tester.enterText(find.byType(TextField), 'テストテキスト');
      await tester.pump();

      // テキストフィールドの値が正しく設定されていることを確認
      expect(find.text('テストテキスト'), findsOneWidget);
      
      // QRコードが表示されていることを確認
      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('Clearボタンのテスト', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: GenerateScreen()));

      // テキストを入力
      await tester.enterText(find.byType(TextField), 'テストテキスト');
      await tester.pump();

      // Clearボタンをタップ
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // テキストフィールドがクリアされていることを確認
      expect(find.text('テストテキスト'), findsNothing);
      
      // QRコードが表示されていることを確認
      expect(find.byType(QrImageView), findsOneWidget);
    });
  });
} 