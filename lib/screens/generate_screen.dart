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
              key: Key('qr_code_image_container'),
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
                          key: Key('qr_code_image'),
                        ),
                      );
                    }
                    return const Text(
                      'QRコードの生成に失敗しました',
                      key: Key('qr_code_image_error'),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            key: Key('qr_code_text_container'),
            child: Consumer<QrDataProvider>(
              builder: (context, provider, _) {
                return Stack(
                  children: [
                    KeyboardListener(
                      focusNode: _focusNode,
                      onKeyEvent: (event) {
                        if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                          setState(() {
                            Provider.of<QrDataProvider>(context, listen: false).clearQrData();
                            provider.textController.clear();
                            logInfo("テキストをクリアしました。");
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
                          hintText: '内容を入力してください',
                        ),
                        key: Key('qr_code_text_content'),
                      ),
                    ),
                    Positioned(
                      key: Key('qr_code_text_hint_text_clear'),
                      right: 12,
                      bottom: 12,
                      child: Text(
                        key: Key('qr_code_text_hint_text_clear_label'),
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