# プロジェクト固有指示

このプロジェクトはWSL環境からWindowsのFlutterプロジェクトを操作します。

## 🚨 重要：最初に必ず実行

```bash
# セットアップスクリプト実行（.claude-context.mdも自動読み込み）
source ./setup_cc.sh
```

このコマンドで以下が自動実行されます：
- 環境変数とエイリアスの設定
- **プロジェクトコンテキスト(.claude-context.md)の読み込み**
- 開発環境の確認

## 環境
- 作業ディレクトリ: /mnt/e/masat/dev/qrcodelyze_desktop
- Flutter: cmd.exe /c "e:\masat\sdks\flutter\bin\flutter"
- Git: git.exe

## プロジェクトポリシー（.claude-context.mdで詳細確認済み）
- メインライブラリ: flutter_zxing ^2.1.0
- 最低コードカバレッジ: 80%
- テスト必須: 新機能には必ずテスト作成
- TDDアプローチ推奨

## コマンド例
- `cmd.exe /c "e:\masat\sdks\flutter\bin\flutter pub get"`
- `cmd.exe /c "e:\masat\sdks\flutter\bin\flutter test --coverage"`
- `git.exe status`

**注意**: setup_cc.shによってプロジェクトコンテキストは既に読み込まれているので、追加の指示は不要です。