import 'package:flutter/foundation.dart';
import '../models/image_source.dart';

class ScanProvider with ChangeNotifier {
  bool _isScanning = false;
  String? _lastScannedData;
  String? _errorMessage;
  String? _codeType;
  String? _codeContent;
  Uint8List? _previewData;
  ImageSource? _imageSource;

  bool get isScanning => _isScanning;
  String? get lastScannedData => _lastScannedData;
  String? get errorMessage => _errorMessage;
  String? get codeType => _codeType;
  String? get codeContent => _codeContent;
  Uint8List? get previewData => _previewData;
  ImageSource? get imageSource => _imageSource;

  void startScanning() {
    _isScanning = true;
    notifyListeners();
  }

  void stopScanning() {
    _isScanning = false;
    notifyListeners();
  }

  void setLastScannedData(String data) {
    _lastScannedData = data;
    notifyListeners();
  }

  void clearLastScannedData() {
    _lastScannedData = null;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setCodeResult({String? type, String? content}) {
    _codeType = type;
    _codeContent = content;
    notifyListeners();
  }

  void setPreviewData(Uint8List? data) {
    _previewData = data;
    notifyListeners();
  }

  void setImageSource(ImageSource source) {
    _imageSource = source;
    notifyListeners();
  }
} 