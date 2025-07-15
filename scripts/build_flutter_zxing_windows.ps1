# scripts/build_flutter_zxing_windows.ps1

# スクリプトをプロジェクトルートから実行前提
# 例: <project_root>\scripts\build_flutter_zxing_windows.ps1

# パス設定
$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$SubmodulePath = Join-Path $ProjectRoot "third_party\flutter_zxing\windows"
$BuildPath = Join-Path $SubmodulePath "build"
$OutputDllPath = Join-Path $BuildPath "shared\Release\flutter_zxing.dll"
$DestDllPath = Join-Path $ProjectRoot "windows\runner\resources\flutter_zxing.dll"

# CMake build directory 確保
if (!(Test-Path $BuildPath)) {
    New-Item -ItemType Directory -Path $BuildPath | Out-Null
}

# CMake configure
Push-Location $BuildPath
cmake .. -G "Visual Studio 17 2022" -A x64
Pop-Location

# CMake build
cmake --build $BuildPath --config Release

# DLL確認
if (!(Test-Path $OutputDllPath)) {
    Write-Error "flutter_zxing.dll not found after build."
    exit 1
}

# 配置先フォルダ準備
$DestFolder = Split-Path $DestDllPath -Parent
if (!(Test-Path $DestFolder)) {
    New-Item -ItemType Directory -Path $DestFolder | Out-Null
}

# DLLをコピー
Copy-Item $OutputDllPath $DestDllPath -Force

Write-Host "✅ flutter_zxing.dll build and copied successfully."
