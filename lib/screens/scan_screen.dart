import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/image_source.dart';
import '../models/file_image_source.dart';
import '../models/clipboard_image_source.dart';
import '../log/log_wrapper.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:flutter/services.dart' show Clipboard;
import 'package:image_picker/image_picker.dart' as picker;
import 'package:file_selector/file_selector.dart';
import 'package:desktop_drop/desktop_drop.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

/// Uint8List (PNG/JPEGなど) を RGBX形式に変換
Uint8List convertToRGBX(img.Image decoded) {
  int width = decoded.width;
  int height = decoded.height;

  // RGBXバッファ作成
  Uint8List rgbxBytes = Uint8List(width * height * 4);
  int offset = 0;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      img.Pixel pixel = decoded.getPixel(x, y);

      rgbxBytes[offset++] = pixel.r.toInt();
      rgbxBytes[offset++] = pixel.g.toInt();
      rgbxBytes[offset++] = pixel.b.toInt();
      rgbxBytes[offset++] = 255; // X値（固定値）
    }
  }

  return rgbxBytes;
}

class _ScanScreenState extends State<ScanScreen> {
  ImageSource? _currentSource;
  Uint8List? _previewData;
  String? _errorMessage;
  String? _codeType;
  String? _codeContent;
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
          // 上半分: プレビュー画像
          Expanded(
            child: DropTarget(
              onDragDone: (details) async {
                if (details.files.isNotEmpty) {
                  setState(() {
                    _currentSource = FileImageSource(file: details.files.first);
                    _previewData = null;
                    _errorMessage = null;
                    _codeType = null;
                    _codeContent = null;
                  });
                  try {
                    await _decodeImageSource();
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                    logWarning('ファイル選択エラー: $e');
                  }
                }
              },
              child: GestureDetector(
                onDoubleTap: _handleFileSelect,
                onSecondaryTap: _handlePaste,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      if (_previewData != null)
                        Image.memory(_previewData!)
                      else
                        const Center(
                          child: Text('ダブルクリック: ファイルから選択\n右クリック: クリップボードから貼り付け\nドラッグ&ドロップ: ファイルをドロップ'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 下半分: デコード結果
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    )
                  else if (_codeType != null || _codeContent != null) ...[
                    if (_codeType != null)
                      Text(
                        'コード種別: $_codeType',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    const SizedBox(height: 8),
                    if (_codeContent != null)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _codeContent!,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                  ] else
                    const Text('画像を読み込むとコード情報が表示されます'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 画像を読み込んでコードを検出する
  Future<void> _decodeImageSource() async {
    final previewData = await _currentSource!.getPreviewData();
    setState(() {
      _previewData = previewData;
    });

    final imageData = convertToRGBX(_currentSource!.rawImage!);
    final width = _currentSource!.rawImage!.width;
    final height = _currentSource!.rawImage!.height;
    final params = DecodeParams(
      imageFormat: ImageFormat.rgbx,
      format: Format.any,
      width: width,
      height: height,
    );
    final result = zx.readBarcode(imageData, params);
    setState(() {
      if (result.isValid) {
        _codeType = result.format?.name;
        _codeContent = result.text;
        // コード内容をクリップボードにコピー
        if (_codeContent != null) {
          Clipboard.setData(ClipboardData(text: _codeContent!));
        }
        logInfo('コードを検出しました: $_codeType');
      } else {
        _codeType = null;
        _codeContent = null;
        _errorMessage = 'コードが検出できませんでした';
        logWarning('コードが検出できませんでした');
      }
    });
  }

  Future<void> _handleFileSelect() async {
    setState(() {
      _currentSource = FileImageSource();
      _previewData = null;
      _errorMessage = null;
      _codeType = null;
      _codeContent = null;
    });
    try {
      await _decodeImageSource();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      logWarning('ファイル選択エラー: $e');
    }
  }

  Future<void> _handlePaste() async {
    setState(() {
      _currentSource = ClipboardImageSource();
      _previewData = null;
      _errorMessage = null;
      _codeType = null;
      _codeContent = null;
    });
    try {
      await _decodeImageSource();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      logWarning('クリップボード貼り付けエラー: $e');
    }
  }
} 