import 'package:flutter/services.dart';
import 'package:file_selector/file_selector.dart';

class DragDropPlugin {
  static const MethodChannel _channel = MethodChannel('com.example.qrcodelyze_desktop/drag_drop');

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onFileDropped':
          final String filePath = call.arguments as String;
          final file = XFile(filePath);
          return file;
        default:
          throw PlatformException(
            code: 'Unimplemented',
            details: 'Method ${call.method} not implemented',
          );
      }
    });
  }
} 