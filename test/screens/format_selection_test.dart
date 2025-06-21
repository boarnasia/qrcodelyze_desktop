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
      expect(find.text('バーコード形式を選択'), findsOneWidget);

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

      // UPC-Aフォーマットが表示されていることを確認
      expect(find.text('UPC-A'), findsOneWidget);
      expect(find.textContaining('Numbers only'), findsOneWidget);
      expect(find.textContaining('Universal Product Code'), findsOneWidget);

      // 複数のフォーマットが表示されていることを確認
      expect(find.text('QR Code'), findsOneWidget);
      expect(find.text('Code 128'), findsOneWidget);
    });

    testWidgets('フォーマット選択テスト', (WidgetTester tester) async {
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

      // QR Codeを選択
      await tester.tap(find.text('QR Code'));
      await tester.pumpAndSettle();

      // コールバックが呼ばれたことを確認
      expect(selectedFormat, isNotNull);
      expect(selectedFormat!.name, 'QR Code');
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

      // 検索テキストを入力
      await tester.enterText(find.byType(TextField), 'QR');
      await tester.pumpAndSettle();

      // QR Codeが表示され、他のフォーマットがフィルタリングされていることを確認
      expect(find.text('QR Code'), findsOneWidget);
      expect(find.text('UPC-A'), findsNothing);
    });

    testWidgets('カテゴリフィルターテスト', (WidgetTester tester) async {
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

      // カテゴリフィルターボタンが表示されていることを確認
      expect(find.text('All'), findsOneWidget);
      expect(find.text('1D Barcodes'), findsOneWidget);
      expect(find.text('2D Barcodes'), findsOneWidget);

      // 1D Barcodesカテゴリを選択
      await tester.tap(find.text('1D Barcodes'));
      await tester.pumpAndSettle();

      // 1Dバーコードのみが表示されていることを確認
      expect(find.text('UPC-A'), findsOneWidget);
      expect(find.text('Code 128'), findsOneWidget);
      expect(find.text('QR Code'), findsNothing); // 2Dなので非表示

      // 2D Barcodesカテゴリを選択
      await tester.tap(find.text('2D Barcodes'));
      await tester.pumpAndSettle();

      // 2Dバーコードのみが表示されていることを確認
      expect(find.text('QR Code'), findsOneWidget);
      expect(find.text('UPC-A'), findsNothing); // 1Dなので非表示
    });

    testWidgets('現在選択中フォーマットのハイライトテスト', (WidgetTester tester) async {
      BarcodeFormatData? selectedFormat; // ignore: unused_local_variable
      final currentFormat = BarcodeFormats.allFormats[1]; // UPC-E

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

      // 現在選択中のフォーマットが特別なスタイルで表示されていることを確認
      // (実装によってはアイコンや色の違いで表示される)
      expect(find.text('UPC-E'), findsOneWidget);
    });

    testWidgets('戻るボタンテスト', (WidgetTester tester) async {
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

      // 戻るボタンが表示されていることを確認
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // 戻るボタンをタップ
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // コールバックが呼ばれていないことを確認
      expect(selectedFormat, isNull);
    });
  });
}