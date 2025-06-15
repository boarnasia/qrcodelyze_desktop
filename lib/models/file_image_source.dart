import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:image/image.dart' as img;
import 'image_source.dart';
import '../log/log_wrapper.dart';

/// ファイル選択による画像入力ソース
class FileImageSource implements ImageSource {
  Uint8List? _imageData;
  img.Image? _rawImage;
  
  @override
  img.Image? get rawImage => _rawImage;

  @override
  String get sourceName => 'ファイル';

  @override
  Future<Uint8List> getImageData() async {
    if (_imageData != null) {
      return _imageData!;
    }
    
    final typeGroup = XTypeGroup(
      label: '画像',
      extensions: ['jpg', 'jpeg', 'png', 'bmp'],
    );
    
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      throw Exception('ファイルが選択されませんでした');
    }

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw Exception('ファイルの読み込みに失敗しました');
    }
    
    _imageData = bytes;
    logFine('画像ファイルを読み込みました: ${file.name}');
    return _imageData!;
  }

  @override
  Future<Uint8List> getPreviewData() async {
    final data = await getImageData();
    // プレビュー用に画像をリサイズ
    final image = img.decodeImage(data);
    if (image == null) {
      throw Exception('画像のデコードに失敗しました');
    }
    _rawImage = image;
    
    final resized = img.copyResize(
      image,
      width: 300,  // プレビュー用の適度なサイズ
      height: 300,
    );
    
    return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  }
} 