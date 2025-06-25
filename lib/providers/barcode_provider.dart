import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import '../models/barcode_format.dart';
import '../log/log_wrapper.dart';
import '../utils/checksum_calculator.dart';

class BarcodeProvider extends ChangeNotifier {
  static const Duration _validationDelay = Duration(milliseconds: 500);

  BarcodeFormatData _currentFormat = BarcodeFormats.getFormatByName('QR Code');
  final TextEditingController _textController = TextEditingController();
  BarcodeValidationResult _validationResult = const BarcodeValidationResult(
    isValid: true,
    errors: [],
    warnings: [],
    characterCount: 0,
  );
  Uint8List? _barcodeImage;
  Timer? _validationTimer;
  
  BarcodeFormatData get currentFormat => _currentFormat;
  TextEditingController get textController => _textController;
  BarcodeValidationResult get validationResult => _validationResult;
  Uint8List? get barcodeImage => _barcodeImage;
  String get inputText => _textController.text;

  BarcodeProvider() {
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _validationTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void setFormat(BarcodeFormatData format) {
    if (_currentFormat.format != format.format) {
      _currentFormat = format;
      logInfo('バーコード形式を変更しました: ${_currentFormat.name}');
      _validateAndGenerate();
      notifyListeners();
    }
  }

  void _onTextChanged() {
    _validationTimer?.cancel();
    _validationTimer = Timer(_validationDelay, () {
      _validateAndGenerate();
    });
  }

  void _validateAndGenerate() {
    final text = _textController.text;
    _validationResult = _validateInput(text);
    
    if (_validationResult.isValid && text.isNotEmpty) {
      // Apply auto-corrections for UPC/EAN formats
      final processedText = _applyAutoCorrections(text);
      _generateBarcode(processedText);
    } else {
      _barcodeImage = null;
    }
    
    // Log validation results
    if (_validationResult.hasErrors) {
      for (final error in _validationResult.errors) {
        logSevere('入力エラー: ${error.message}');
      }
    }
    
    if (_validationResult.hasWarnings) {
      for (final warning in _validationResult.warnings) {
        logInfo('入力警告: ${warning.message}');
      }
    }
    
    notifyListeners();
  }

  BarcodeValidationResult _validateInput(String text) {
    final List<ValidationError> errors = [];
    final List<ValidationWarning> warnings = [];
    
    if (text.isEmpty) {
      return BarcodeValidationResult(
        isValid: false,
        errors: [const ValidationError(
          type: ValidationErrorType.emptyInput,
          message: 'テキストを入力してください',
        )],
        warnings: [],
        characterCount: 0,
      );
    }

    // Check if format is supported by flutter_zxing
    if (!_isFormatSupported()) {
      errors.add(ValidationError(
        type: ValidationErrorType.unsupportedFormat,
        message: '${_currentFormat.name}はflutter_zxingライブラリでサポートされていません',
      ));
      return BarcodeValidationResult(
        isValid: false,
        errors: errors,
        warnings: warnings,
        characterCount: text.length,
      );
    }

    // Check character count
    final characterCount = text.length;
    
    // Special handling for UPC/EAN formats with checksum auto-calculation
    if (_isUpcEanFormat()) {
      final expectedLength = _getExpectedInputLength();
      if (characterCount != expectedLength && characterCount != _currentFormat.fixedLength!) {
        if (characterCount < expectedLength) {
          errors.add(ValidationError(
            type: ValidationErrorType.lengthTooShort,
            message: '${_currentFormat.name}は$expectedLength文字（チェックサム除く）または${_currentFormat.fixedLength!}文字（チェックサム含む）である必要があります',
          ));
        } else {
          errors.add(ValidationError(
            type: ValidationErrorType.lengthExceeded,
            message: '${_currentFormat.name}は$expectedLength文字（チェックサム除く）または${_currentFormat.fixedLength!}文字（チェックサム含む）である必要があります',
          ));
        }
      }
    }
    // Check fixed length requirements for non-UPC/EAN formats
    else if (_currentFormat.hasFixedLength) {
      if (characterCount != _currentFormat.fixedLength!) {
        errors.add(ValidationError(
          type: characterCount < _currentFormat.fixedLength! 
            ? ValidationErrorType.lengthTooShort 
            : ValidationErrorType.lengthExceeded,
          message: '${_currentFormat.name}は${_currentFormat.fixedLength}文字である必要があります',
        ));
      }
    }
    
    // Check maximum length
    else if (_currentFormat.hasMaxLength) {
      if (characterCount > _currentFormat.maxLength!) {
        errors.add(ValidationError(
          type: ValidationErrorType.lengthExceeded,
          message: '${_currentFormat.name}の最大文字数は${_currentFormat.maxLength}文字です',
        ));
      } else if (characterCount > (_currentFormat.maxLength! * 0.8).round()) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.approachingLimit,
          message: '推奨文字数に近づいています',
        ));
      }
    }
    
    // Check recommended length
    else if (_currentFormat.hasRecommendedLength) {
      if (characterCount > _currentFormat.recommendedLength!) {
        warnings.add(ValidationWarning(
          type: ValidationWarningType.suboptimalLength,
          message: '推奨文字数(${_currentFormat.recommendedLength})を超えています',
        ));
      }
    }

    // Validate characters based on format type
    final invalidCharacters = _findInvalidCharacters(text);
    if (invalidCharacters.isNotEmpty) {
      errors.add(ValidationError(
        type: ValidationErrorType.invalidCharacter,
        message: '無効な文字が含まれています: ${invalidCharacters.join(", ")}',
      ));
    }

    return BarcodeValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      characterCount: characterCount,
    );
  }

  List<String> _findInvalidCharacters(String text) {
    final Set<String> invalidChars = {};
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (!_isValidCharacter(char)) {
        invalidChars.add(char);
      }
    }
    
    return invalidChars.toList();
  }

  bool _isValidCharacter(String char) {
    final code = char.codeUnitAt(0);
    
    switch (_currentFormat.characterType) {
      case CharacterType.numeric:
        return char.contains(RegExp(r'[0-9]'));
      
      case CharacterType.alphanumeric:
        if (_currentFormat.format == Format.code39) {
          return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.* \$/+%'.contains(char);
        } else if (_currentFormat.format == Format.codabar) {
          return '0123456789-\$:/.+ABCD'.contains(char);
        } else {
          return char.contains(RegExp(r'[A-Z0-9]'));
        }
      
      case CharacterType.ascii:
        return code >= 0 && code <= 127;
      
      case CharacterType.extended:
      case CharacterType.binary:
        return true; // All characters allowed
    }
  }

  void _generateBarcode(String text) {
    try {
      // Use flutter_zxing to generate barcode
      final result = zx.encodeBarcode(
        contents: text,
        params: EncodeParams(
          format: _currentFormat.format,
          width: 400,
          height: 200,
        ),
      );
      
      if (result.isValid && result.data != null) {
        // Convert raw barcode data to PNG format
        _barcodeImage = pngFromBytes(result.data!, 400, 200);
        logInfo('バーコードを生成しました: ${_currentFormat.name} - $text');
      } else {
        _barcodeImage = null;
        logSevere('バーコード生成に失敗しました: ${result.error}');
      }
    } catch (e) {
      _barcodeImage = null;
      logSevere('バーコード生成エラー: $e');
    }
  }

  bool _isFormatSupported() {
    const supportedFormats = [
      Format.qrCode,
      Format.dataMatrix,
      Format.aztec,
      Format.codabar,
      Format.code39,
      Format.code93,
      Format.code128,
      Format.ean8,
      Format.ean13,
      Format.itf,
      Format.upca,
      Format.upce,
    ];
    return supportedFormats.contains(_currentFormat.format);
  }

  bool _isUpcEanFormat() {
    return [Format.upca, Format.upce, Format.ean13, Format.ean8]
        .contains(_currentFormat.format);
  }

  int _getExpectedInputLength() {
    switch (_currentFormat.format) {
      case Format.upca:
        return 11; // 11 digits + 1 checksum
      case Format.upce:
        return 6; // 6 digits + 1 checksum
      case Format.ean13:
        return 12; // 12 digits + 1 checksum
      case Format.ean8:
        return 7; // 7 digits + 1 checksum
      default:
        return _currentFormat.fixedLength ?? 0;
    }
  }

  String _applyAutoCorrections(String text) {
    if (!_isUpcEanFormat()) {
      return text;
    }

    final expectedLength = _getExpectedInputLength();
    
    // If input is the expected length without checksum, calculate and append checksum
    if (text.length == expectedLength) {
      final checksum = ChecksumCalculator.calculateChecksum(_currentFormat.format, text);
      if (checksum != null) {
        final correctedText = text + checksum.toString();
        logInfo('チェックサムを自動計算しました: $checksum (完全なコード: $correctedText)');
        return correctedText;
      }
    }
    
    return text;
  }

  void clearInput() {
    _textController.clear();
    _barcodeImage = null;
    _validationResult = const BarcodeValidationResult(
      isValid: true,
      errors: [],
      warnings: [],
      characterCount: 0,
    );
    logInfo('入力をクリアしました');
    notifyListeners();
  }

  // Get highlighted text spans for validation display
  List<TextSpan> getHighlightedTextSpans(String text) {
    if (_validationResult.isValid) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> spans = [];
    final invalidCharacters = _findInvalidCharacters(text);
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final isInvalid = invalidCharacters.contains(char);
      final isOverLimit = _currentFormat.hasMaxLength && 
                         i >= _currentFormat.maxLength!;
      
      Color? backgroundColor;
      Color? color;
      TextDecoration? decoration;
      
      if (isInvalid || isOverLimit) {
        backgroundColor = Colors.red;
        color = Colors.white;
      } else if (_currentFormat.hasRecommendedLength && 
                 i >= _currentFormat.recommendedLength!) {
        decoration = TextDecoration.underline;
      }
      
      spans.add(TextSpan(
        text: char,
        style: TextStyle(
          backgroundColor: backgroundColor,
          color: color,
          decoration: decoration,
        ),
      ));
    }
    
    return spans;
  }
}