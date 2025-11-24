#!/usr/bin/env bun
import { $ } from "bun";
import { existsSync } from "fs";
import { resolve, basename } from "path";

// Simple YAML parser for basic key-value structures
function parseYAML(content: string): any {
  const lines = content.split("\n");
  const result: any = {};
  let currentKey: string | null = null;
  let currentArray: any[] | null = null;

  for (const line of lines) {
    // Skip comments and empty lines
    if (line.trim().startsWith("#") || line.trim() === "") continue;

    // Handle array items
    if (line.trim().startsWith("- ")) {
      if (!currentArray) continue;

      const itemMatch = line.match(/^\s*-\s+(\w+):\s*(.+)$/);
      if (itemMatch) {
        const [, key, value] = itemMatch;
        if (!currentArray.length || typeof currentArray[currentArray.length - 1] !== 'object') {
          currentArray.push({});
        }
        const lastItem = currentArray[currentArray.length - 1];
        lastItem[key] = value.trim();
      }
      continue;
    }

    // Handle nested keys (indented)
    const nestedMatch = line.match(/^\s{2,}(\w+):\s*(.+)$/);
    if (nestedMatch && currentArray) {
      const [, key, value] = nestedMatch;
      const lastItem = currentArray[currentArray.length - 1];
      if (lastItem) {
        lastItem[key] = value === "true" ? true : value === "false" ? false : value.trim();
      }
      continue;
    }

    // Handle top-level keys
    const keyMatch = line.match(/^(\w+):\s*(.*)$/);
    if (keyMatch) {
      const [, key, value] = keyMatch;
      currentKey = key;

      if (value.trim() === "") {
        // Empty value means it's an object or array
        if (key === "volumes") {
          result[key] = [];
          currentArray = result[key];
        } else if (key === "environment") {
          result[key] = {};
          currentArray = null;
        } else {
          result[key] = {};
          currentArray = null;
        }
      } else {
        result[key] = value.trim();
        currentArray = null;
      }
    }

    // Handle environment variables
    if (currentKey === "environment" && line.match(/^\s{2,}(\w+):\s*(.+)$/)) {
      const [, envKey, envValue] = line.match(/^\s{2,}(\w+):\s*(.+)$/)!;
      result.environment[envKey] = envValue.trim().replace(/^["']|["']$/g, '');
    }
  }

  return result;
}

interface SandboxConfig {
  image: string;
  workdir?: string;
  volumes?: Array<{
    host: string;
    container: string;
    readonly?: boolean;
  }>;
  environment?: Record<string, string>;
}

async function main() {
  // 引数のパース: docker-safe-sandbox <config.yaml> -- <command...>
  const args = process.argv.slice(2);
  const separatorIndex = args.indexOf("--");

  if (separatorIndex === -1 || separatorIndex === 0) {
    console.error("Usage: docker-safe-sandbox <config.yaml> -- <command...>");
    console.error("");
    console.error("Example:");
    console.error("  docker-safe-sandbox bun.yaml -- bun run script.ts");
    process.exit(1);
  }

  const configPath = args[0];
  const dockerCommand = args.slice(separatorIndex + 1);

  if (dockerCommand.length === 0) {
    console.error("Error: No command specified after '--'");
    process.exit(1);
  }

  // 設定ファイルの読み込み
  if (!existsSync(configPath)) {
    console.error(`Error: Config file not found: ${configPath}`);
    process.exit(1);
  }

  const configContent = await Bun.file(configPath).text();
  const config: SandboxConfig = parseYAML(configContent);

  // 必須フィールドのチェック
  if (!config.image) {
    console.error("Error: 'image' field is required in config file");
    process.exit(1);
  }

  // 一時ディレクトリ作成
  const tmpDir = await $`mktemp -d`.text();
  const tmpDirPath = tmpDir.trim();

  console.log("Creating temporary workspace...");

  try {
    // .gitignoreを考慮してファイルをコピー
    await $`rsync -a --filter=':- .gitignore' --exclude='.git' ./ ${tmpDirPath}/`;

    // Dockerコマンドの構築
    const workdir = config.workdir || "/workspace";
    const dockerArgs = ["run", "--rm"];

    // ワークスペースのマウント
    dockerArgs.push("-v", `${tmpDirPath}:${workdir}`);

    // 追加のボリュームマウント
    if (config.volumes) {
      for (const volume of config.volumes) {
        const hostPath = resolve(volume.host);
        if (existsSync(hostPath)) {
          const mountOption = volume.readonly ? "ro" : "rw";
          console.log(`Mounting ${basename(hostPath)}...`);
          dockerArgs.push(
            "-v",
            `${hostPath}:${volume.container}:${mountOption}`
          );
        } else {
          console.warn(`Warning: ${hostPath} not found, skipping mount`);
        }
      }
    }

    // 環境変数の設定
    if (config.environment) {
      for (const [key, value] of Object.entries(config.environment)) {
        dockerArgs.push("-e", `${key}=${value}`);
      }
    }

    // ワーキングディレクトリの設定
    dockerArgs.push("-w", workdir);

    // イメージ名
    dockerArgs.push(config.image);

    // 実行するコマンド
    dockerArgs.push(...dockerCommand);

    // Dockerコンテナ実行
    console.log(`Running in Docker: ${config.image}`);
    console.log(`Command: ${dockerCommand.join(" ")}`);
    console.log("");

    const result = await $`docker ${dockerArgs}`;

    // 標準出力をそのまま表示
    process.exit(result.exitCode);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  } finally {
    // 一時ディレクトリの削除
    await $`rm -rf ${tmpDirPath}`;
  }
}

main();
