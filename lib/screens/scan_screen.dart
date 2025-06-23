import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../log/log_wrapper.dart';
import '../models/clipboard_image_source.dart';
import '../models/file_image_source.dart';
import '../models/image_source.dart';
import '../providers/scan_provider.dart';
import '../utils/image_processor.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

/// Uint8List (PNG/JPEGなど) を RGBX形式に変換
Uint8List convertToRGBX(img.Image decoded) {
  final width = decoded.width;
  final height = decoded.height;
  final rgbxBytes = Uint8List(width * height * 4);
  var offset = 0;

  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final pixel = decoded.getPixel(x, y);
      rgbxBytes[offset++] = pixel.r.toInt();
      rgbxBytes[offset++] = pixel.g.toInt();
      rgbxBytes[offset++] = pixel.b.toInt();
      rgbxBytes[offset++] = 255;
    }
  }

  return rgbxBytes;
}

class _ScanScreenState extends State<ScanScreen> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleImageSource(ImageSource source) async {
    final provider = context.read<ScanProvider>();
    provider.setImageSource(source);
    provider.clearError(); // エラーをクリア

    try {
      final previewData = await source.getPreviewData();
      provider.setPreviewData(previewData);

      final result = await ImageProcessor.decodeImageSource(source);
      
      if (result.isValid && result.text != null) {
        await Clipboard.setData(ClipboardData(text: result.text!));
        provider.setCodeResult(
          type: result.format?.name,
          content: result.text,
        );
        logInfo('コードを検出: ${result.format?.name}, クリップボードへコピーしました');
      } else {
        provider.setCodeResult(type: null, content: null);
        provider.setError('コードが検出できませんでした - 画像にバーコード/QRコードが含まれていない可能性があります');
        logWarning('コードが検出できませんでした');
      }
    } catch (e) {
      provider.setCodeResult(type: null, content: null);
      provider.setError('エラー: ${e.toString()}');
      logWarning('画像処理エラー: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: DropTarget(
              onDragDone: (details) {
                if (details.files.isNotEmpty) {
                  _handleImageSource(FileImageSource(file: details.files.first));
                }
              },
              child: GestureDetector(
                onDoubleTap: () => _handleImageSource(FileImageSource()),
                onSecondaryTap: () => _handleImageSource(ClipboardImageSource()),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Consumer<ScanProvider>(
                          builder: (context, provider, _) {
                            return provider.previewData != null
                                ? Image.memory(provider.previewData!)
                                : const Text(
                                    'ダブルクリック: ファイルから選択\n'
                                    '右クリック: クリップボードから貼り付け\n'
                                    'ドラッグ&ドロップ: ファイルをドロップ',
                                    key: Key('scan_instruction_text'),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(12),
              child: Consumer<ScanProvider>(
                builder: (context, provider, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.errorMessage != null)
                        Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (provider.codeType != null || provider.codeContent != null) ...[
                        if (provider.codeType != null)
                          Text(
                            'コード種別: ${provider.codeType}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        const SizedBox(height: 8),
                        if (provider.codeContent != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                provider.codeContent!,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                      ] else
                        const Text(
                          '画像を読み込むとコード情報が表示されます',
                          key: Key('scan_result_help_text'),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 