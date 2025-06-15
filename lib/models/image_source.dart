import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// 画像入力ソースの抽象クラス
abstract class ImageSource {
  /// 画像データを取得する
  Future<Uint8List> getImageData();
  
  /// 画像のプレビュー用データを取得する
  Future<Uint8List> getPreviewData();
  
  /// 入力ソースの名前を取得する
  String get sourceName;

  /// 生の画像データを取得する
  img.Image? get rawImage;
} 