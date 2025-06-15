import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/qr_data_provider.dart';
import '../log/log_wrapper.dart';
import 'package:pasteboard/pasteboard.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Consumer<QrDataProvider>(
                  builder: (context, provider, _) {
                    final qrCodeImage = provider.qrCodeImage;
                    if (qrCodeImage != null) {
                      return GestureDetector(
                        onSecondaryTap: () async {
                          await Pasteboard.writeImage(qrCodeImage);
                          logInfo('QRコード画像をクリップボードにコピーしました');
                        },
                        child: Image.memory(
                          qrCodeImage,
                        ),
                      );
                    }
                    return const Text('QRコードの生成に失敗しました');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<QrDataProvider>(
              builder: (context, provider, _) {
                return Stack(
                  children: [
                    KeyboardListener(
                      focusNode: _focusNode,
                      onKeyEvent: (event) {
                        if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                          setState(() {
                            logInfo("テキストをクリアしました。");
                            Provider.of<QrDataProvider>(context, listen: false).clearQrData();
                            provider.textController.clear();
                          });
                        }
                      },
                      child: TextField(
                        controller: provider.textController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text',
                        ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}