import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _autoSave = true;

  bool get darkMode => _darkMode;
  bool get autoSave => _autoSave;

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void toggleAutoSave() {
    _autoSave = !_autoSave;
    notifyListeners();
  }
} 