import 'package:flutter/material.dart';
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
      expect(find.byKey(Key('scan_instruction_text')), findsOneWidget);
      expect(find.byKey(Key('scan_result_help_text')), findsOneWidget);
    });
  });
} 