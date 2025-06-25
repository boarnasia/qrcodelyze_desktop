import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/barcode_provider.dart';
import '../screens/format_selection_screen.dart';
import '../log/log_wrapper.dart';
import 'package:pasteboard/pasteboard.dart';
import '../widgets/common/help_balloon.dart';

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
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          // Top Section: Barcode display area
          Expanded(
            flex: 1,
            child: Container(
              key: const Key('barcode_image_container'),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Consumer<BarcodeProvider>(
                builder: (context, provider, _) {
                  final barcodeImage = provider.barcodeImage;
                  return Stack(
                    children: [
                      Center(
                        child: barcodeImage != null
                          ? GestureDetector(
                              onSecondaryTap: () async {
                                await Pasteboard.writeImage(barcodeImage);
                                logInfo('バーコード画像をクリップボードにコピーしました');
                              },
                              child: Image.memory(
                                barcodeImage,
                                key: const Key('barcode_image'),
                                fit: BoxFit.contain,
                              ),
                            )
                          : Text(
                              provider.inputText.isEmpty 
                                ? 'バーコードを生成するにはテキストを入力してください'
                                : 'バーコードの生成に失敗しました',
                              key: const Key('barcode_image_placeholder'),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                      ),
                      if (barcodeImage != null)
                        const Positioned(
                          key: Key('barcode_image_help_balloon_container'),
                          bottom: 8,
                          right: 8,
                          child: HelpBalloon(
                            key: Key('barcode_image_help_balloon'),
                            text: '右クリックでコピー',
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 4),
          
          // Middle Section: Format selector and info
          Consumer<BarcodeProvider>(
            builder: (context, provider, _) {
              return Row(
                children: [
                  // Format selector button
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormatSelectionScreen(
                              currentFormat: provider.currentFormat,
                              onFormatSelected: (format) {
                                provider.setFormat(format);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code),
                      label: Text(
                        provider.currentFormat.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  
                  // Format info
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          provider.currentFormat.characterType.description,
                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Count: ${provider.validationResult.characterCount} / ${provider.currentFormat.capacityInfo}',
                          style: TextStyle(
                            fontSize: 12, 
                            color: provider.validationResult.hasErrors 
                              ? Colors.red 
                              : Colors.green,
                            fontWeight: provider.validationResult.hasErrors 
                              ? FontWeight.normal 
                              : FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 4),
          
          // Content Input Section
          Expanded(
            flex: 1,
            key: const Key('barcode_text_container'),
            child: Consumer<BarcodeProvider>(
              builder: (context, provider, _) {
                return Stack(
                  children: [
                    KeyboardListener(
                      focusNode: _focusNode,
                      onKeyEvent: (event) {
                        if (event is KeyUpEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                          provider.clearInput();
                        }
                      },
                      child: TextField(
                        controller: provider.textController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: provider.validationResult.hasErrors 
                                ? Colors.red 
                                : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: provider.validationResult.hasErrors 
                                ? Colors.red 
                                : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: provider.validationResult.hasErrors 
                                ? Colors.red 
                                : Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          hintText: '${provider.currentFormat.name}用のテキストを入力してください',
                        ),
                        key: const Key('barcode_text_content'),
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (provider.inputText.isNotEmpty)
                      Positioned(
                        key: const Key('barcode_text_hint_clear_container'),
                        bottom: 8,
                        right: 8,
                        child: HelpBalloon(
                          key: const Key('barcode_text_hint_clear'),
                          text: 'ESCでクリア',
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