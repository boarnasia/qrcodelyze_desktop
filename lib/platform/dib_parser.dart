import 'dart:typed_data';
import 'package:image/image.dart' as img;

class DIBParser {
  final Uint8List dibData;

  DIBParser(this.dibData);

  img.Image decode() {
    final header = dibData.buffer.asByteData();

    final headerSize = header.getInt32(0, Endian.little);
    final width = header.getInt32(4, Endian.little);
    final rawHeight = header.getInt32(8, Endian.little);
    final height = rawHeight.abs();
    final planes = header.getInt16(12, Endian.little);
    final bitCount = header.getInt16(14, Endian.little);
    final compression = header.getInt32(16, Endian.little);
    final imageSize = header.getInt32(20, Endian.little);

    if (planes != 1) {
      throw Exception('Unsupported planes count: $planes');
    }

    final pixelDataOffset = headerSize;

    if (compression == 4 || compression == 5) {
      // BI_JPEG / BI_PNG
      final compressed = dibData.sublist(pixelDataOffset, pixelDataOffset + imageSize);
      final decoded = img.decodeImage(compressed);
      if (decoded == null) {
        throw Exception('Failed to decode embedded JPEG/PNG');
      }
      return decoded;
    }

    if (compression != 0 && compression != 3) {
      throw Exception('Unsupported compression format: $compression');
    }

    final bytesPerPixel = bitCount ~/ 8;
    final rowLength = width * bytesPerPixel;

    final output = img.Image(width: width, height: height);

    if (compression == 0) {
      // BI_RGB (非圧縮)
      for (var y = 0; y < height; y++) {
        final srcY = rawHeight > 0 ? (height - 1 - y) : y;
        final rowStart = pixelDataOffset + srcY * rowLength;
        for (var x = 0; x < width; x++) {
          final offset = rowStart + x * bytesPerPixel;
          final b = dibData[offset];
          final g = dibData[offset + 1];
          final r = dibData[offset + 2];
          final a = (bitCount == 32) ? dibData[offset + 3] : 255;
          output.setPixelRgba(x, y, r, g, b, a);
        }
      }
    }

    if (compression == 3) {
      // BI_BITFIELDS
      if (bitCount != 32) {
        throw Exception('Only 32bit supported for BITFIELDS');
      }

      const offsetMask = 40;
      final redMask = header.getUint32(offsetMask, Endian.little);
      final greenMask = header.getUint32(offsetMask + 4, Endian.little);
      final blueMask = header.getUint32(offsetMask + 8, Endian.little);
      final alphaMask = header.getUint32(offsetMask + 12, Endian.little);

      final redShift = _maskShift(redMask);
      final greenShift = _maskShift(greenMask);
      final blueShift = _maskShift(blueMask);
      final alphaShift = _maskShift(alphaMask);

      for (var y = 0; y < height; y++) {
        final srcY = rawHeight > 0 ? (height - 1 - y) : y;
        final rowStart = pixelDataOffset + srcY * rowLength;
        for (var x = 0; x < width; x++) {
          final offset = rowStart + x * 4;
          final pixel = dibData.buffer.asByteData().getUint32(offset, Endian.little);

          int a = (alphaMask != 0) ? ((pixel & alphaMask) >> alphaShift) & 0xFF : 255;
          a = (a == 0) ? 1 : a; // 0除算対策 (透明扱い)
          final rRaw = ((pixel & redMask) >> redShift) & 0xFF;
          final gRaw = ((pixel & greenMask) >> greenShift) & 0xFF;
          final bRaw = ((pixel & blueMask) >> blueShift) & 0xFF;

          // アンプレ乗算補正
          final r = (rRaw * 255 ~/ a).clamp(0, 255);
          final g = (gRaw * 255 ~/ a).clamp(0, 255);
          final b = (bRaw * 255 ~/ a).clamp(0, 255);

          output.setPixelRgba(x, y, r, g, b, a);
        }
      }
    }

    return output;
  }

  int _maskShift(int mask) {
    if (mask == 0) return 0;
    int shift = 0;
    while ((mask & 1) == 0) {
      mask >>= 1;
      shift++;
    }
    return shift;
  }
}
