cmake_minimum_required(VERSION 3.14)
project(zxing_decoder)

# C++17を要求
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# zxing-cppをサブモジュールとして追加
add_subdirectory(zxing-cpp)

# DLLの出力設定
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
add_library(zxing_decoder SHARED
    src/zxing_decoder.cpp
)

# zxing-cppへのリンク
target_link_libraries(zxing_decoder PRIVATE
    ZXing
)

# インクルードディレクトリの設定
target_include_directories(zxing_decoder PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/zxing-cpp/core/src
)

# DLLの出力先を設定
set_target_properties(zxing_decoder PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
) 