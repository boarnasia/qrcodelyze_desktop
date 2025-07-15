import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:image/image.dart' as imglib;
import 'dart:async';
import '../constants/app_constants.dart';
import '../log/log_wrapper.dart';

class QrDataProvider extends ChangeNotifier {
  String _qrData = '';
  final TextEditingController textController = TextEditingController();
  Uint8List? _qrCodeImage;
  Timer? _debounceTimer;

  QrDataProvider() {
    textController.text = _qrData;
    textController.addListener(_onTextChanged);
    _generateQrCode(isDefaultValue: true);
  }

  String get qrData => _qrData;
  Uint8List? get qrCodeImage => _qrCodeImage;

  void _onTextChanged() {
    _qrData = textController.text;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs), () {
      _generateQrCode(isDefaultValue: false);
      notifyListeners();
      logInfo("QR コードを生成・更新しました。");
    });
  }

  void _generateQrCode({bool isDefaultValue = true}) {
    final data = _qrData.isEmpty ? AppConstants.defaultQrData : _qrData;
    final result = zx.encodeBarcode(
      contents: data,
      params: EncodeParams(
        format: Format.qrCode,
        width: 1000,
        height: 1000,
        margin: 0,
        eccLevel: EccLevel.low,
      ),
    );
    if (result.isValid && result.data != null) {
      final img = imglib.Image.fromBytes(
        width: 1000,
        height: 1000,
        bytes: result.data!.buffer,
        numChannels: 1,
      );
      _qrCodeImage = imglib.encodePng(img);
    } else {
      _qrCodeImage = null;
    }
  }

  void updateQrData(String value) {
    _qrData = value;
    _generateQrCode(isDefaultValue: false);
    notifyListeners();
  }

  void clearQrData() {
    _qrData = '';
    textController.clear();
    _generateQrCode(isDefaultValue: false);
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    textController.dispose();
    super.dispose();
  }
} 