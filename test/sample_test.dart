// test/sample_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('文字列のテスト', () {
    final name = 'QRcodelyze';
    expect(name.contains('code'), isTrue);
  });
}
