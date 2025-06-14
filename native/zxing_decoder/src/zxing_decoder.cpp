#include "zxing_decoder.h"
#include <ZXing.h>
#include <iostream>
#include <vector>

using namespace ZXing;

// 最大出力文字数
constexpr int MAX_OUTPUT_SIZE = 256;

int decode_qrcode(
    const uint8_t* image_data,
    int width,
    int height,
    int stride,
    char* output_buffer,
    int output_buffer_size
) {
    // バッファサイズチェック
    if (output_buffer_size < MAX_OUTPUT_SIZE) {
        std::cerr << "Output buffer too small" << std::endl;
        return -2;
    }

    try {
        // RGB24をグレースケールに変換
        std::vector<uint8_t> gray_data(width * height);
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                const uint8_t* pixel = image_data + y * stride + x * 3;
                // RGBからグレースケールへの変換（標準的な重み付け）
                gray_data[y * width + x] = static_cast<uint8_t>(
                    pixel[0] * 0.299 + pixel[1] * 0.587 + pixel[2] * 0.114
                );
            }
        }

        // デコード設定
        DecodeHints hints;
        hints.setTryHarder(true);
        hints.setTryRotate(true);
        hints.setTryInvert(true);

        // 画像データをZXing形式に変換
        ImageView image{gray_data.data(), width, height, ImageFormat::Lum};
        
        // デコード実行
        auto results = MultiFormatReader(hints).read(image);
        
        if (results.empty()) {
            std::cerr << "No QR code found" << std::endl;
            return -1;
        }

        // 最初の結果を取得
        const auto& result = results[0];
        const auto& text = result.text();
        
        // バッファサイズチェック
        if (text.length() >= MAX_OUTPUT_SIZE) {
            std::cerr << "Decoded text too long" << std::endl;
            return -2;
        }

        // 結果をコピー
        std::copy(text.begin(), text.end(), output_buffer);
        output_buffer[text.length()] = '\0';

        return 0;
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return -1;
    }
    catch (...) {
        std::cerr << "Unknown error occurred" << std::endl;
        return -1;
    }
} 