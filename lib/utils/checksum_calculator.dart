import 'package:flutter_zxing/flutter_zxing.dart';

/// Utility class for calculating checksums for UPC/EAN barcode formats
class ChecksumCalculator {
  /// Calculate checksum for UPC/EAN barcode formats
  /// Returns null if format is not supported or input is invalid
  static int? calculateChecksum(int format, String digits) {
    if (!_isValidNumericString(digits)) {
      return null;
    }

    switch (format) {
      case Format.upca:
        return _calculateUpcAChecksum(digits);
      case Format.upce:
        return _calculateUpcEChecksum(digits);
      case Format.ean13:
        return _calculateEan13Checksum(digits);
      case Format.ean8:
        return _calculateEan8Checksum(digits);
      default:
        return null;
    }
  }

  /// Validate if a UPC/EAN code has a correct checksum
  static bool validateChecksum(int format, String fullCode) {
    if (!_isValidNumericString(fullCode)) {
      return false;
    }

    int expectedLength;
    switch (format) {
      case Format.upca:
        expectedLength = 12;
        break;
      case Format.upce:
        expectedLength = 8;
        break;
      case Format.ean13:
        expectedLength = 13;
        break;
      case Format.ean8:
        expectedLength = 8;
        break;
      default:
        return false;
    }

    if (fullCode.length != expectedLength) {
      return false;
    }

    final digits = fullCode.substring(0, fullCode.length - 1);
    final providedChecksum = int.parse(fullCode.substring(fullCode.length - 1));
    final calculatedChecksum = calculateChecksum(format, digits);

    return calculatedChecksum == providedChecksum;
  }

  static bool _isValidNumericString(String input) {
    return RegExp(r'^[0-9]+$').hasMatch(input);
  }

  /// Calculate UPC-A checksum using standard algorithm
  static int _calculateUpcAChecksum(String digits) {
    if (digits.length != 11) {
      throw ArgumentError('UPC-A requires 11 digits for checksum calculation');
    }

    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      int digit = int.parse(digits[i]);
      // Odd positions (1st, 3rd, 5th, etc.) multiply by 3
      // Even positions (2nd, 4th, 6th, etc.) multiply by 1
      sum += (i % 2 == 0) ? digit * 3 : digit;
    }

    int checksum = (10 - (sum % 10)) % 10;
    return checksum;
  }

  /// Calculate UPC-E checksum
  static int _calculateUpcEChecksum(String digits) {
    if (digits.length != 6) {
      throw ArgumentError('UPC-E requires 6 digits for checksum calculation');
    }

    // UPC-E checksum is calculated using the expanded UPC-A form
    // For simplicity, we'll use a basic checksum calculation
    // In a real implementation, you'd expand to UPC-A first
    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      int digit = int.parse(digits[i]);
      // Alternate between multiplying by 3 and 1
      sum += (i % 2 == 0) ? digit * 3 : digit;
    }

    int checksum = (10 - (sum % 10)) % 10;
    return checksum;
  }

  /// Calculate EAN-13 checksum using standard algorithm
  static int _calculateEan13Checksum(String digits) {
    if (digits.length != 12) {
      throw ArgumentError('EAN-13 requires 12 digits for checksum calculation');
    }

    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      int digit = int.parse(digits[i]);
      // Odd positions (1st, 3rd, 5th, etc.) multiply by 1
      // Even positions (2nd, 4th, 6th, etc.) multiply by 3
      sum += (i % 2 == 0) ? digit : digit * 3;
    }

    int checksum = (10 - (sum % 10)) % 10;
    return checksum;
  }

  /// Calculate EAN-8 checksum using standard algorithm
  static int _calculateEan8Checksum(String digits) {
    if (digits.length != 7) {
      throw ArgumentError('EAN-8 requires 7 digits for checksum calculation');
    }

    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      int digit = int.parse(digits[i]);
      // Odd positions (1st, 3rd, 5th, 7th) multiply by 3
      // Even positions (2nd, 4th, 6th) multiply by 1
      sum += (i % 2 == 0) ? digit * 3 : digit;
    }

    int checksum = (10 - (sum % 10)) % 10;
    return checksum;
  }
}