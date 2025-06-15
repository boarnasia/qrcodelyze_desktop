import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/image_source.dart';
import '../models/file_image_source.dart';
import '../models/clipboard_image_source.dart';
import '../log/log_wrapper.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'dart:io';

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

  // デバッグ用にピクセル値をCSVに出力
  StringBuffer csvBuffer = StringBuffer();
  csvBuffer.writeln('x,y,r,g,b');
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      img.Pixel pixel = decoded.getPixel(x, y);
      csvBuffer.writeln('$x,$y,${pixel.r},${pixel.g},${pixel.b}');
    }
  }
  File('C:\\Users\\masat\\OneDrive\\Desktop\\qrcode.csv').writeAsStringSync(csvBuffer.toString());

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
  String? _scanResult;
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
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyUpEvent &&
            event.logicalKey == LogicalKeyboardKey.keyV &&
            (HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft) ||
             HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlRight))) {
          _handlePaste();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 上半分: プレビュー画像
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
            // 下半分: デコード結果
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(12),
                child: _errorMessage != null
                    ? Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      )
                    : (_codeType != null || _codeContent != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                            ],
                          )
                        : const Text('画像を読み込むとコード情報が表示されます'),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      } else {
        _codeType = null;
        _codeContent = null;
        _errorMessage = 'コードが検出できませんでした';
      }
    });
  }

  Future<void> _handleFileSelect() async {
    setState(() {
      _currentSource = FileImageSource();
      _previewData = null;
      _scanResult = null;
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
      _scanResult = null;
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