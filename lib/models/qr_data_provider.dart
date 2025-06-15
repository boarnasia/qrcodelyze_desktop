import 'package:flutter/foundation.dart';

class QrDataProvider extends ChangeNotifier {
  String _qrData = '';

  String get qrData => _qrData;

  void updateQrData(String newData) {
    _qrData = newData;
    notifyListeners();
  }

  void clearQrData() {
    _qrData = '';
    notifyListeners();
  }
} 