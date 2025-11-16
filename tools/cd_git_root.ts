#!/usr/bin/env bun

import { $ } from "bun";

// Git リポジトリのルートディレクトリへ移動するための出力を行う

try {
  const gitRoot = await $`git rev-parse --show-toplevel`.quiet().text();
  const rootPath = gitRoot.trim();

  if (rootPath) {
    console.log(`CD_TO:${rootPath}`);
  } else {
    console.error("Not in a git repository");
    process.exit(1);
  }
} catch (error) {
  console.error("Not in a git repository");
  process.exit(1);
}
