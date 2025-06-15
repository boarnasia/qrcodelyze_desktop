import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:pasteboard/pasteboard.dart';
import 'image_source.dart';

class ClipboardImageSource implements ImageSource {
  img.Image? _rawImage;

  @override
  String get sourceName => 'クリップボード';

  @override
  img.Image? get rawImage => _rawImage;

  @override
  Future<Uint8List> getImageData() async {
    final data = await Pasteboard.image;
    if (data == null) {
      throw Exception('クリップボードに画像がありません');
    }

    return data;
  }

  @override
  Future<Uint8List> getPreviewData() async {
    final data = await getImageData();
    final image = img.decodeImage(data);
    if (image == null) {
      throw Exception('画像のデコードに失敗しました');
    }
    _rawImage = image;

    return Uint8List.fromList(img.encodeJpg(image, quality: 85));
  }
}
