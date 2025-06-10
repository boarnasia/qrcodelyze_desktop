import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants/app_constants.dart';
import '../log/logger.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  String qrData = '';
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
                child: QrImageView(
                  data: qrData.isEmpty ? AppConstants.defaultQrData : qrData,
                  version: QrVersions.auto,
                  size: qrSize,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter text',
                        ),
                        enabled: true,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          setState(() {
                            qrData = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        appLogger.fine('Clearボタンが押されました');
                        setState(() {
                          qrData = '';
                          _textController.clear();
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}