#!/usr/bin/env bun

import { $ } from "bun";

// リモートに同名のブランチが存在していたら、ローカルにチェックアウトする
// 存在していなかったら、現在のブランチからチェックアウトする

// ブランチ名を引数から取得
let branchName = process.argv[2];

if (!branchName) {
  console.error("Usage: git_checkout_branch <branch_name>");
  process.exit(1);
}

// プレフィックスを適用（環境変数GIT_BRANCH_PREFIXが設定されていれば）
if (process.env.GIT_BRANCH_PREFIX) {
  branchName = `${process.env.GIT_BRANCH_PREFIX}${branchName}`;
}

// リモートブランチの存在を確認
let remoteBranchExists = false;
try {
  const result = await $`git ls-remote --heads origin ${branchName}`.text();
  if (result.includes(branchName)) {
    remoteBranchExists = true;
  }
} catch {
  remoteBranchExists = false;
}

try {
  if (remoteBranchExists) {
    console.log("Checking out remote branch");
    await $`git checkout ${branchName}`;
  } else {
    console.log("Creating new branch");
    await $`git checkout -b ${branchName}`;
  }
  console.log(`Done: ${branchName}`);
} catch (error) {
  console.error("Failed");
  process.exit(1);
}
