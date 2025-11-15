#!/usr/bin/env bun

import { $ } from "bun";

// デフォルトブランチ（main or master）にチェックアウトする

// まずsymbolic-refで確認
let defaultBranch = "";
try {
  const result = await $`git symbolic-ref refs/remotes/origin/HEAD`.quiet().text();
  defaultBranch = result.trim().replace(/^refs\/remotes\/origin\//, "");
} catch {
  // symbolic-refが失敗した場合はgrepで探す
  try {
    const branches = await $`git branch -r`.text();
    const match = branches.match(/origin\/(main|master)/);
    if (match) {
      defaultBranch = match[1];
    }
  } catch {
    // 何もしない
  }
}

if (!defaultBranch) {
  console.error("Could not determine default branch");
  process.exit(1);
}

try {
  await $`git checkout ${defaultBranch}`;
} catch (error) {
  console.error(`Failed to checkout ${defaultBranch}`);
  process.exit(1);
}
