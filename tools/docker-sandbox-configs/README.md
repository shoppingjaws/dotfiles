# Docker Safe Sandbox

設定ファイルベースでDockerコンテナ内でスクリプトを安全に実行するためのツール。

## 概要

Claude Codeから内部スクリプトを安全に実行するために設計されたツールです。`.gitignore`を考慮してファイルをコピーし、依存関係は効率的に`-v`マウントで渡すことで、セキュアかつ高速な実行を実現します。

## ファイル構成

```
docker-sandbox-configs/
├── docker-safe-sandbox.ts  # メインスクリプト
├── README.md               # このファイル
├── bun.yaml                # Bun用設定
├── node.yaml               # Node.js用設定
├── deno.yaml               # Deno用設定
├── go.yaml                 # Go用設定
└── python.yaml             # Python用設定
```

## 使い方

### 基本的な使い方

```bash
docker-safe-sandbox <config.yaml> -- <command...>
```

### 実行例

```bash
# Bunでスクリプト実行
docker-safe-sandbox tools/docker-sandbox-configs/bun.yaml -- bun run script.ts

# Node.jsでスクリプト実行
docker-safe-sandbox tools/docker-sandbox-configs/node.yaml -- node script.js

# Denoでスクリプト実行
docker-safe-sandbox tools/docker-sandbox-configs/deno.yaml -- deno run script.ts

# Goでビルド
docker-safe-sandbox tools/docker-sandbox-configs/go.yaml -- go build

# Pythonでスクリプト実行
docker-safe-sandbox tools/docker-sandbox-configs/python.yaml -- python script.py
```

## Claude Code設定

`claude/settings.json` に以下の許可を追加：

```json
{
  "permissions": {
    "allow": [
      "Bash(docker-safe-sandbox :*)"
    ]
  }
}
```

これにより、Claude Codeから自動的にこのツールを使用してスクリプトを実行できます。

## 設定ファイルの構造

```yaml
# Dockerイメージ名（必須）
image: oven/bun:latest

# ワーキングディレクトリ（オプション、デフォルト: /workspace）
workdir: /workspace

# 追加マウントするボリューム（オプション）
volumes:
  - host: ./node_modules           # ホスト側のパス
    container: /workspace/node_modules  # コンテナ側のパス
    readonly: true                 # 読み取り専用（オプション、デフォルト: false）

# 環境変数（オプション）
environment:
  NODE_ENV: production
```

## 動作の仕組み

1. 一時ディレクトリを作成
2. `.gitignore`を考慮してGit管理ファイルをコピー
3. 設定ファイルで指定された追加ボリュームをマウント
4. Dockerコンテナ内でコマンドを実行
5. 一時ディレクトリを自動削除

## 主な特徴

### 1. セキュリティ

- **`.gitignore`の尊重**: `.env`などの機密ファイルは自動的に除外
- **読み取り専用マウント**: 依存関係は`readonly: true`で保護
- **自動クリーンアップ**: コンテナと一時ファイルは実行後に自動削除
- **サンドボックス化**: ホスト環境から隔離されたDocker環境で実行

### 2. パフォーマンス

- **効率的なマウント**: `node_modules`などの大量ファイルは`-v`マウントで高速化
- **選択的コピー**: Git管理ファイルのみをコピー、無駄なファイルコピーを回避
- **並列実行可能**: 複数のサンドボックスを同時実行可能

### 3. 柔軟性

- **YAML設定**: 言語ごとに最適な設定をカスタマイズ可能
- **複数ランタイム対応**: Bun, Node.js, Deno, Go, Python等をサポート
- **環境変数**: 実行環境を柔軟に制御

## 設定ファイルの詳細

### 利用可能な設定ファイル

| ファイル | イメージ | 用途 | 追加マウント |
|---------|---------|------|------------|
| `bun.yaml` | `oven/bun:latest` | Bunスクリプト実行 | `node_modules` (ro) |
| `node.yaml` | `node:24` | Node.jsスクリプト実行 | `node_modules` (ro) |
| `deno.yaml` | `denoland/deno:latest` | Denoスクリプト実行 | なし |
| `go.yaml` | `golang:latest` | Goビルド/実行 | `vendor` (ro) |
| `python.yaml` | `python:latest` | Pythonスクリプト実行 | `venv`, `.venv` (ro) |

### カスタム設定の作成

独自の設定ファイルを作成する例：

```yaml
# custom-runtime.yaml
image: alpine:latest
workdir: /workspace

volumes:
  - host: ./data
    container: /workspace/data
    readonly: false

environment:
  DEBUG: "true"
  LOG_LEVEL: info
```

## トラブルシューティング

### Q: `node_modules`が見つからない

A: `node_modules`が存在しない場合はマウントされません。先に`npm install`または`bun install`を実行してください。

### Q: ファイルが見つからない

A: `.gitignore`に含まれているファイルは自動的に除外されます。必要なファイルは`.gitignore`から削除するか、別途マウント設定を追加してください。

### Q: 実行速度が遅い

A: 初回実行時はDockerイメージのダウンロードに時間がかかります。2回目以降は高速になります。

## 実装の詳細

### 動作フロー

1. YAMLファイルの解析
2. 一時ディレクトリの作成 (`mktemp -d`)
3. `.gitignore`を考慮したファイルコピー (`rsync`)
4. 追加ボリュームのマウント準備
5. Dockerコンテナの起動と実行
6. 一時ディレクトリの削除

### 使用技術

- **Bun**: スクリプトランタイム
- **Docker**: コンテナ実行環境
- **rsync**: 効率的なファイルコピー
- **YAML**: 設定ファイル形式

## ライセンス

このツールはdotfilesの一部として提供されます。
