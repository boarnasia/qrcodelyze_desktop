#pragma once

#include <cstdint>

#ifdef __cplusplus
extern "C" {
#endif

/// QRコードデコード関数
/// 
/// @param image_data RGB24形式の画像データ
/// @param width 画像の幅
/// @param height 画像の高さ
/// @param stride 1行あたりのバイト数（通常 width * 3）
/// @param output_buffer デコード結果格納先（UTF-8文字列）
/// @param output_buffer_size 格納バッファサイズ
/// @return 0=成功, -1=デコード失敗, -2=バッファ不足
__declspec(dllexport)
int decode_qrcode(
    const uint8_t* image_data,
    int width,
    int height,
    int stride,
    char* output_buffer,
    int output_buffer_size
);

#ifdef __cplusplus
}
#endif 