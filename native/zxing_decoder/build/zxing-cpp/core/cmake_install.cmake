# Install script for directory: E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/zxing_decoder")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/Debug/ZXing.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/Release/ZXing.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/MinSizeRel/ZXing.lib")
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/RelWithDebInfo/ZXing.lib")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ZXing" TYPE FILE FILES
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Barcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BarcodeFormat.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitHacks.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ByteArray.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/CharacterSet.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Content.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Error.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Flags.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/GTIN.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ImageView.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Point.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Quadrilateral.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Range.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReadBarcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReaderOptions.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/StructuredAppend.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/TextUtfEncoding.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXingCpp.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXAlgorithms.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXVersion.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/DecodeHints.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Result.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrixIO.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Matrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/MultiFormatWriter.h"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ZXing" TYPE FILE FILES
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Barcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BarcodeFormat.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitHacks.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ByteArray.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/CharacterSet.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Content.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Error.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Flags.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/GTIN.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ImageView.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Point.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Quadrilateral.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Range.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReadBarcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReaderOptions.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/StructuredAppend.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/TextUtfEncoding.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXingCpp.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXAlgorithms.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXVersion.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/DecodeHints.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Result.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrixIO.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Matrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/MultiFormatWriter.h"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ZXing" TYPE FILE FILES
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Barcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BarcodeFormat.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitHacks.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ByteArray.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/CharacterSet.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Content.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Error.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Flags.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/GTIN.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ImageView.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Point.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Quadrilateral.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Range.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReadBarcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReaderOptions.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/StructuredAppend.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/TextUtfEncoding.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXingCpp.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXAlgorithms.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXVersion.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/DecodeHints.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Result.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrixIO.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Matrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/MultiFormatWriter.h"
      )
  elseif(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ZXing" TYPE FILE FILES
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Barcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BarcodeFormat.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitHacks.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ByteArray.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/CharacterSet.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Content.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Error.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Flags.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/GTIN.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ImageView.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Point.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Quadrilateral.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Range.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReadBarcode.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ReaderOptions.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/StructuredAppend.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/TextUtfEncoding.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXingCpp.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXAlgorithms.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/ZXVersion.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/DecodeHints.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Result.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/BitMatrixIO.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/Matrix.h"
      "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/zxing-cpp/core/src/MultiFormatWriter.h"
      )
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/Version.h")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg]|[Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE FILE OPTIONAL FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/ZXing.pdb")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing/ZXingTargets.cmake")
    file(DIFFERENT _cmake_export_file_changed FILES
         "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing/ZXingTargets.cmake"
         "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets.cmake")
    if(_cmake_export_file_changed)
      file(GLOB _cmake_old_config_files "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing/ZXingTargets-*.cmake")
      if(_cmake_old_config_files)
        string(REPLACE ";" ", " _cmake_old_config_files_text "${_cmake_old_config_files}")
        message(STATUS "Old export file \"$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing/ZXingTargets.cmake\" will be replaced.  Removing files [${_cmake_old_config_files_text}].")
        unset(_cmake_old_config_files_text)
        file(REMOVE ${_cmake_old_config_files})
      endif()
      unset(_cmake_old_config_files)
    endif()
    unset(_cmake_export_file_changed)
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets.cmake")
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets-debug.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets-minsizerel.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets-relwithdebinfo.cmake")
  endif()
  if(CMAKE_INSTALL_CONFIG_NAME MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/CMakeFiles/Export/f9e04a807b27a41299a115186893fdf1/ZXingTargets-release.cmake")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/ZXing" TYPE FILE FILES
    "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/ZXingConfig.cmake"
    "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/ZXingConfigVersion.cmake"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "E:/masat/dev/qrcodelyze_desktop/native/zxing_decoder/build/zxing-cpp/core/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
