// Removed unused import: package:flutter_zxing/flutter_zxing.dart

enum CharacterType {
  numeric('Numbers only'),
  alphanumeric('A-Z, 0-9'),
  ascii('ASCII 128 characters'),
  extended('Extended characters'),
  binary('Binary data');

  const CharacterType(this.description);
  final String description;
}

class BarcodeFormatData {
  final int format;
  final String name;
  final String category;
  final CharacterType characterType;
  final int? fixedLength;
  final int? maxLength;
  final int? recommendedLength;
  final String validCharacters;
  final String description;

  const BarcodeFormatData({
    required this.format,
    required this.name,
    required this.category,
    required this.characterType,
    this.fixedLength,
    this.maxLength,
    this.recommendedLength,
    required this.validCharacters,
    required this.description,
  });

  bool get hasFixedLength => fixedLength != null;
  bool get hasMaxLength => maxLength != null;
  bool get hasRecommendedLength => recommendedLength != null;

  String get lengthInfo {
    if (hasFixedLength) {
      return '$fixedLength digits fixed';
    } else if (hasMaxLength) {
      return 'max $maxLength';
    } else if (hasRecommendedLength) {
      return 'recommended max $recommendedLength';
    }
    return 'variable length';
  }

  String get capacityInfo {
    if (hasFixedLength) {
      return '$fixedLength';
    } else if (hasMaxLength) {
      return '$maxLength';
    } else if (hasRecommendedLength) {
      return '$recommendedLength+';
    }
    return '∞';
  }
}

class BarcodeFormats {
  static const List<BarcodeFormatData> allFormats = [
    // 1D Barcodes - UPC/EAN Family
    BarcodeFormatData(
      format: 16384, // Format.upca
      name: 'UPC-A',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      fixedLength: 12,
      validCharacters: '0123456789',
      description: 'Universal Product Code - Standard retail barcode',
    ),
    BarcodeFormatData(
      format: 32768, // Format.upce
      name: 'UPC-E',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      fixedLength: 8,
      validCharacters: '0123456789',
      description: 'Universal Product Code - Compressed format (6 digits + checksum)',
    ),
    BarcodeFormatData(
      format: 512, // Format.ean13
      name: 'EAN-13',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      fixedLength: 13,
      validCharacters: '0123456789',
      description: 'European Article Number - International standard',
    ),
    BarcodeFormatData(
      format: 256, // Format.ean8
      name: 'EAN-8',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      fixedLength: 8,
      validCharacters: '0123456789',
      description: 'European Article Number - Short format',
    ),

    // 1D Barcodes - Code Family
    BarcodeFormatData(
      format: 4, // Format.code39
      name: 'Code 39',
      category: '1D Barcodes',
      characterType: CharacterType.alphanumeric,
      maxLength: 43,
      validCharacters: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.* \$/+%',
      description: 'Alphanumeric barcode with start/stop characters',
    ),
    BarcodeFormatData(
      format: 8, // Format.code93
      name: 'Code 93',
      category: '1D Barcodes',
      characterType: CharacterType.ascii,
      maxLength: 47,
      validCharacters: 'All 128 ASCII characters',
      description: 'High-density alphanumeric barcode',
    ),
    BarcodeFormatData(
      format: 16, // Format.code128
      name: 'Code 128',
      category: '1D Barcodes',
      characterType: CharacterType.ascii,
      maxLength: 2046,
      validCharacters: 'All 128 ASCII characters',
      description: 'High-density variable-length barcode',
    ),
    BarcodeFormatData(
      format: 2, // Format.codabar
      name: 'Codabar',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      maxLength: 20,
      validCharacters: '0123456789-\$:/.+ABCD',
      description: 'Numeric barcode with start/stop characters A-D',
    ),

    // 1D Barcodes - ITF
    BarcodeFormatData(
      format: 1024, // Format.itf
      name: 'ITF (Interleaved 2 of 5)',
      category: '1D Barcodes',
      characterType: CharacterType.numeric,
      maxLength: 30,
      validCharacters: '0123456789',
      description: 'Numeric barcode requiring even number of digits',
    ),

    // 2D Barcodes
    BarcodeFormatData(
      format: 8192, // Format.qrCode
      name: 'QR Code',
      category: '2D Barcodes',
      characterType: CharacterType.extended,
      maxLength: 7089,
      validCharacters: 'Multi-language support, binary data',
      description: 'Quick Response code with error correction',
    ),
    BarcodeFormatData(
      format: 128, // Format.dataMatrix
      name: 'Data Matrix',
      category: '2D Barcodes',
      characterType: CharacterType.binary,
      maxLength: 3116,
      validCharacters: 'ASCII + binary data',
      description: '2D matrix barcode for small items',
    ),
    BarcodeFormatData(
      format: 1, // Format.aztec
      name: 'Aztec',
      category: '2D Barcodes',
      characterType: CharacterType.binary,
      maxLength: 3832,
      validCharacters: 'ASCII + binary data',
      description: '2D barcode with central finder pattern',
    ),
    // Unsupported formats - commented out but kept for reference
    // BarcodeFormatData(
    //   format: 4096, // Format.pdf417
    //   name: 'PDF417 (Not Supported)',
    //   category: '2D Barcodes',
    //   characterType: CharacterType.binary,
    //   maxLength: 2725,
    //   validCharacters: 'ASCII + binary data',
    //   description: 'Not supported by flutter_zxing library',
    // ),
    // BarcodeFormatData(
    //   format: 2048, // Format.maxiCode
    //   name: 'MaxiCode (Not Supported)',
    //   category: '2D Barcodes',
    //   characterType: CharacterType.alphanumeric,
    //   maxLength: 138,
    //   validCharacters: 'Alphanumeric characters',
    //   description: 'Not supported by flutter_zxing library',
    // ),
    //
    // // GS1 DataBar - Not supported
    // BarcodeFormatData(
    //   format: 32, // Format.dataBar
    //   name: 'GS1 DataBar (Not Supported)',
    //   category: 'GS1 DataBar',
    //   characterType: CharacterType.numeric,
    //   fixedLength: 14,
    //   validCharacters: '0123456789',
    //   description: 'Not supported by flutter_zxing library',
    // ),
    // BarcodeFormatData(
    //   format: 64, // Format.dataBarExpanded
    //   name: 'GS1 DataBar Expanded (Not Supported)',
    //   category: 'GS1 DataBar',
    //   characterType: CharacterType.alphanumeric,
    //   maxLength: 74,
    //   validCharacters: 'Alphanumeric characters',
    //   description: 'Not supported by flutter_zxing library',
    // ),
  ];

  static BarcodeFormatData? getFormatData(int format) {
    try {
      return allFormats.firstWhere((f) => f.format == format);
    } catch (e) {
      return null;
    }
  }

  static List<BarcodeFormatData> getFormatsByCategory(String category) {
    return allFormats.where((f) => f.category == category).toList();
  }

  static BarcodeFormatData getFormatByName(String name) {
    try {
      return allFormats.firstWhere((f) => f.name == name);
    } catch (e) {
      return allFormats.firstWhere((f) => f.name == 'QR Code');
    }
  }

  static List<String> get categories {
    return allFormats.map((f) => f.category).toSet().toList();
  }

  static BarcodeFormatData get defaultFormat => getFormatByName('QR Code');
}

class BarcodeValidationResult {
  final bool isValid;
  final List<ValidationError> errors;
  final List<ValidationWarning> warnings;
  final int characterCount;

  const BarcodeValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.characterCount,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}

class ValidationError {
  final ValidationErrorType type;
  final String message;
  final int? position;

  const ValidationError({
    required this.type,
    required this.message,
    this.position,
  });
}

class ValidationWarning {
  final ValidationWarningType type;
  final String message;

  const ValidationWarning({
    required this.type,
    required this.message,
  });
}

enum ValidationErrorType {
  invalidCharacter,
  lengthExceeded,
  lengthTooShort,
  emptyInput,
  unsupportedFormat,
}

enum ValidationWarningType {
  approachingLimit,
  suboptimalLength,
}