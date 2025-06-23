#!/bin/env bash

echo "=== QRCodelyze Desktop Flutter Project Setup ==="

# プロジェクトディレクトリに移動
cd /mnt/e/masat/dev/qrcodelyze_desktop

# 環境変数設定
export FLUTTER_BIN="e:\masat\sdks\flutter\bin\flutter"

# エイリアス設定
alias flutter='cmd.exe /c "$FLUTTER_BIN"'
alias git='git.exe'

echo "プロジェクトディレクトリ: $(pwd)"

# === 重要：プロジェクトコンテキストの自動読み込み ===
echo ""
echo "=== プロジェクトコンテキスト読み込み中... ==="
if [ -f ".claude-context.md" ]; then
    echo "📋 .claude-context.md を読み込みます..."
    cat .claude-context.md
    echo ""
    echo "✅ プロジェクトコンテキストを理解しました"
else
    echo "⚠️  .claude-context.md が見つかりません"
fi

echo ""
echo "=== 環境確認 ==="

# Flutter環境確認
echo "Flutter Version:"
cmd.exe /c "$FLUTTER_BIN --version"

echo "Git Version:"
git.exe --version

echo ""
echo "=== 使用可能なコマンド ==="
echo "  flutter pub get    # 依存関係取得"
echo "  flutter run        # アプリ実行" 
echo "  flutter test       # テスト実行"
echo "  flutter test --coverage  # カバレッジ付きテスト"
echo "  flutter analyze    # 静的解析"
echo "  git status         # Git状態確認"
echo ""
echo "🚀 セットアップ完了！開発を開始できます。"
echo "📝 コンテキスト情報は上記で確認済みです。"