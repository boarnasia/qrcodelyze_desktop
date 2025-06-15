import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/image_source.dart';

class ScanProvider extends ChangeNotifier {
  ImageSource? _currentSource;
  Uint8List? _previewData;
  String? _errorMessage;
  String? _codeType;
  String? _codeContent;

  ImageSource? get currentSource => _currentSource;
  Uint8List? get previewData => _previewData;
  String? get errorMessage => _errorMessage;
  String? get codeType => _codeType;
  String? get codeContent => _codeContent;

  void setImageSource(ImageSource source) {
    _currentSource = source;
    _resetState();
    notifyListeners();
  }

  void _resetState() {
    _previewData = null;
    _errorMessage = null;
    _codeType = null;
    _codeContent = null;
  }

  void setPreviewData(Uint8List data) {
    _previewData = data;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setCodeResult({String? type, String? content}) {
    _codeType = type;
    _codeContent = content;
    notifyListeners();
  }
} 