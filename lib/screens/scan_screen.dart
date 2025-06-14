import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/image_source.dart';
import '../models/file_image_source.dart';
import '../models/clipboard_image_source.dart';
import '../log/log_wrapper.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ImageSource? _currentSource;
  Uint8List? _previewData;
  String? _scanResult;
  String? _errorMessage;
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (event) {
        if (event.isControlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
          _handlePaste();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // プレビュー表示エリア
            Expanded(
              child: GestureDetector(
                onDoubleTap: _handleFileSelect,
                onSecondaryTap: _handlePaste,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _previewData != null
                      ? Image.memory(_previewData!)
                      : const Center(
                          child: Text('ダブルクリック: ファイルから選択\n右クリック/Ctrl+V: クリップボードから貼り付け'),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // スキャン結果表示エリア
            if (_scanResult != null || _errorMessage != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _errorMessage != null ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage ?? _scanResult!,
                  style: TextStyle(
                    color: _errorMessage != null ? Colors.red : Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFileSelect() async {
    try {
      setState(() {
        _currentSource = FileImageSource();
        _previewData = null;
        _scanResult = null;
        _errorMessage = null;
      });
      
      final previewData = await _currentSource!.getPreviewData();
      setState(() {
        _previewData = previewData;
      });
      
      // TODO: FFI実装後にデコード処理を追加
      setState(() {
        _scanResult = 'ファイルから画像を読み込みました（デコード処理は未実装）';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      logWarning('ファイル選択エラー: $e');
    }
  }

  Future<void> _handlePaste() async {
    try {
      setState(() {
        _currentSource = ClipboardImageSource();
        _previewData = null;
        _scanResult = null;
        _errorMessage = null;
      });
      
      final previewData = await _currentSource!.getPreviewData();
      setState(() {
        _previewData = previewData;
      });
      
      // TODO: FFI実装後にデコード処理を追加
      setState(() {
        _scanResult = 'クリップボードから画像を読み込みました（デコード処理は未実装）';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      logWarning('クリップボード貼り付けエラー: $e');
    }
  }
} 