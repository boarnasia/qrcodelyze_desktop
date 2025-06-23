import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrcodelyze_desktop/screens/format_selection_screen.dart';
import 'package:qrcodelyze_desktop/models/barcode_format.dart';
import '../helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    TestSetup.setupAll();
  });

  group('FormatSelectionScreen Tests', () {
    testWidgets('初期状態のテスト', (WidgetTester tester) async {
      BarcodeFormatData? selectedFormat; // ignore: unused_local_variable
      final currentFormat = BarcodeFormats.allFormats.first;

      await tester.pumpWidget(
        MaterialApp(
          home: FormatSelectionScreen(
            currentFormat: currentFormat,
            onFormatSelected: (format) {
              selectedFormat = format;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // AppBarが表示されていることを確認
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Select Barcode Format'), findsOneWidget);

      // 検索フィールドが表示されていることを確認
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // フォーマットリストが表示されていることを確認
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('フォーマットリスト表示テスト', (WidgetTester tester) async {
      BarcodeFormatData? selectedFormat; // ignore: unused_local_variable
      final currentFormat = BarcodeFormats.allFormats.first;

      await tester.pumpWidget(
        MaterialApp(
          home: FormatSelectionScreen(
            currentFormat: currentFormat,
            onFormatSelected: (format) {
              selectedFormat = format;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // ListTileが複数表示されていることを確認
      expect(find.byType(ListTile), findsWidgets);
      
      // CardやIconが表示されていることを確認
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('検索機能テスト', (WidgetTester tester) async {
      BarcodeFormatData? selectedFormat; // ignore: unused_local_variable
      final currentFormat = BarcodeFormats.allFormats.first;

      await tester.pumpWidget(
        MaterialApp(
          home: FormatSelectionScreen(
            currentFormat: currentFormat,
            onFormatSelected: (format) {
              selectedFormat = format;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 検索フィールドに入力
      await tester.enterText(find.byType(TextField), 'UPC');
      await tester.pumpAndSettle();

      // 検索後もListTileが表示されていることを確認
      expect(find.byType(ListTile), findsWidgets);
    });
  });
}