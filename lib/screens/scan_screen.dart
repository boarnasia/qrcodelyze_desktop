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
import '../widgets/common/help_balloon.dart';

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

  final _scanInstructionText =
    'ダブルクリックで画像をファイルから選択、\n'
    'もしくはドラッグ&ドロップ\n'
    '右クリックでクリップボードから貼り付け'
    ;

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
        //await Clipboard.setData(ClipboardData(text: result.text!));
        provider.setCodeResult(
          type: result.format?.name,
          content: result.text,
        );
        //logInfo('コードを検出: ${result.format?.name}, クリップボードへコピーしました');
        logInfo('コードを検出: ${result.format?.name}');
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
      padding: const EdgeInsets.all(4.0),
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
                  child: 
                    Consumer<ScanProvider>(
                      builder: (context, provider, _) {
                        return Stack(
                          children: [
                            Center(
                              child: 
                                provider.previewData != null
                                  ?   Image.memory(provider.previewData!)
                                  : Text(
                                      _scanInstructionText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                      key: Key('scan_instruction_text'),
                                    )
                            ),
                            if (provider.previewData != null)
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: HelpBalloon(
                                  key: Key('scan_help_balloon'),
                                  text: "$_scanInstructionText\nESCでクリア",
                                ),
                              ),
                          ],
                        );
                    }),
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          Consumer<ScanProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.qr_code, size: 20),
                    SizedBox(width: 8),
                    Text(
                      provider.currentFormat?.name ?? '未検出',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    if (provider.codeContent != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          'Count: ${provider.codeContent!.length} / ${provider.currentFormat?.capacityInfo ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 4),

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
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (provider.codeContent != null) ...
                        [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: SingleChildScrollView(
                                child: SelectableText(
                                  provider.codeContent!,
                                  style: const TextStyle(fontSize: 14, height: 1.5),
                                ),
                              ),
                            ),
                          ),
                        ]
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(Icons.info_outline, color: Colors.grey.shade600, size: 48),
                              SizedBox(height: 12),
                              Text(
                                '画像を読み込むとコード情報が表示されます',
                                key: Key('scan_result_help_text'),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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