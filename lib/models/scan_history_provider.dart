import 'package:flutter/foundation.dart';

class ScanHistoryProvider with ChangeNotifier {
  final List<String> _scanHistory = [];

  List<String> get scanHistory => List.unmodifiable(_scanHistory);

  void addToHistory(String data) {
    _scanHistory.add(data);
    notifyListeners();
  }

  void clearHistory() {
    _scanHistory.clear();
    notifyListeners();
  }
} 