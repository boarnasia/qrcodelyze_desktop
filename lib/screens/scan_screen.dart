import 'package:flutter/material.dart';

enum ScanMode { photos, camera }

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanMode _mode = ScanMode.photos;

  void _toggleMode() {
    setState(() {
      _mode = _mode == ScanMode.photos ? ScanMode.camera : ScanMode.photos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 上部: カメラプレビュー or 画像（ダミー）
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                child: Text(
                  _mode == ScanMode.photos ? '画像プレビュー（ダミー）' : 'カメラプレビュー（ダミー）',
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
            ),
            // 下部: スキャン状態表示＋トグルボタン
            Expanded(
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    // スキャン状態表示を下部コンテナいっぱいに
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Scanning中、スキャン結果がこちらに表示されます。',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ),
                    // Scan from Photos/Cameraトグルボタン
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _toggleMode,
                            child: Text(_mode == ScanMode.photos ? 'Scan from Camera' : 'Scan from Photos'),
                          ),
                        ),
                      ],
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