クィックスタート
=============

## 開発環境のセットアップ

### リポジトリのクローン
```bash
git clone git@github.com:boarnasia/qrcodelyze_desktop.git
cd qrcodelyze_desktop
```

### サブモジュールの取得
```bash
git submodule update --init --recursive
```

### 依存関係のインストール
```bash
flutter pub get
```

## 開発作業

### テストの実行
```bash
flutter test
```

### コード分析
```bash
flutter analyze
```

### アプリケーションの実行
```bash
flutter run -d windows
```

