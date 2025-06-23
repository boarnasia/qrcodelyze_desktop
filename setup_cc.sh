#!/bin/env bash

echo "=== QRCode Desktop Flutter Project Setup ==="

# プロジェクトディレクトリに移動
cd /mnt/e/masat/dev/qrcodelyze_desktop

# 環境変数設定
export FLUTTER_BIN="e:\masat\sdks\flutter\bin\flutter"

# エイリアス設定
alias flutter='cmd.exe /c "$FLUTTER_BIN"'
alias git='git.exe'

echo "プロジェクトディレクトリ: $(pwd)"
echo "Flutter環境準備完了"

# 環境確認
echo "Flutter Version:"
cmd.exe /c "$FLUTTER_BIN --version"

echo "Git Version:"
git.exe --version

echo ""
echo "使用可能なコマンド:"
echo "  flutter pub get"
echo "  flutter run"
echo "  flutter test"
echo "  flutter analyze"
echo "  git status"
echo ""
echo "セットアップ完了！開発を開始できます。"

