import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:qrcodelyze_desktop/screens/scan_screen.dart';
import 'package:qrcodelyze_desktop/models/qr_data_provider.dart';

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
  });
} 