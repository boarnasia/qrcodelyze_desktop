import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../log/log_wrapper.dart';
import '../models/qr_data_provider.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // 初期値を設定
    final qrDataProvider = Provider.of<QrDataProvider>(context, listen: false);
    _textController.text = qrDataProvider.qrData;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateQrCode(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: AppConstants.qrCodeUpdateDelayMs), () {
      Provider.of<QrDataProvider>(context, listen: false).updateQrData(value);
      logInfo("QR コードを生成・更新しました。");
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = size.width < size.height ? size.width * 0.8 : size.height * 0.4;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Consumer<QrDataProvider>(
                  builder: (context, qrDataProvider, child) {
                    return QrImageView(
                      data: qrDataProvider.qrData.isEmpty ? AppConstants.defaultQrData : qrDataProvider.qrData,
                      version: QrVersions.auto,
                      size: qrSize,
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  KeyboardListener(
                    focusNode: _focusNode,
                    onKeyEvent: (event) {
                      if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                        setState(() {
                          logInfo("テキストをクリアしました。");
                          Provider.of<QrDataProvider>(context, listen: false).clearQrData();
                          _textController.clear();
                        });
                      }
                    },
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter text',
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      onChanged: _updateQrCode,
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Text(
                      'ESC でクリア',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}