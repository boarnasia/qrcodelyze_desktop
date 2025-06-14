import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pasteboard/pasteboard.dart';
import 'image_preprocessor.dart';

class ClipboardImageSource {
  Uint8List? _cachedRaw;
  img.Image? _cachedDecoded;

  /// クリップボードから画像のRawデータ（JPEG/PNG等バイナリ）を取得
  Future<Uint8List> getRawImageData() async {
    if (_cachedRaw != null) return _cachedRaw!;

    final data = await Pasteboard.image;
    if (data == null) {
      throw Exception('クリップボードに画像がありません');
    }

    _cachedRaw = data;
    _cachedDecoded = img.decodeImage(data);
    if (_cachedDecoded == null) {
      throw Exception('画像のデコードに失敗しました');
    }

    return _cachedRaw!;
  }

  /// QRスキャン用の補正済み画像を取得
  Future<img.Image> getPreprocessedImage() async {
    if (_cachedDecoded == null) {
      await getRawImageData();
    }
    final preprocessor = ImagePreprocessor(_cachedDecoded!);
    return preprocessor.preprocessForQrScan();
  }
}
