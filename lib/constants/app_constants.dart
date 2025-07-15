import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'QR Codelyze';
  static const double windowWidth = 282;
  static const double windowHeight = 547;
  static const Size windowSize = Size(windowWidth, windowHeight);
  static const String defaultQrData = 'QR Codelyze';
  static const int logBufferSize = 1000;
  static const int qrCodeUpdateDelayMs = 500; // QRコード更新の遅延時間（ミリ秒）
  
  const AppConstants._();
} 