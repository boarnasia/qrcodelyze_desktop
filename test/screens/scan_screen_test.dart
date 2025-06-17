import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/screens/scan_screen.dart';
import '../helpers/test_setup.dart';

void main() {
  setUpAll(() {
    TestSetup.setupAll();
  });

  group('ScanScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestSetup.wrapWithProviders(
          const ScanScreen(),
        ),
      );

      // 初期状態のテスト
      expect(find.byType(ScanScreen), findsOneWidget);
      expect(find.text('ダブルクリック: ファイルから選択\n右クリック: クリップボードから貼り付け\nドラッグ&ドロップ: ファイルをドロップ'), findsOneWidget);
      expect(find.text('画像を読み込むとコード情報が表示されます'), findsOneWidget);
    });
  });
} 