#!/usr/bin/env bun

import { $ } from "bun";
import { existsSync } from "fs";
import { resolve } from "path";

// ブランチ名を引数から取得
const inputBranchName = process.argv[2];

if (!inputBranchName) {
  console.error("Usage: git_worktree_branch <branch_name>");
  process.exit(1);
}

// develop/ プレフィックスを追加（すでに含まれていない場合のみ）
const branchName = inputBranchName.startsWith("develop/")
  ? inputBranchName
  : `develop/${inputBranchName}`;

// 変更をstash
console.log("Stashing changes...");
let stashed = false;
try {
  const result = await $`git stash push -u -m "Auto stash before creating worktree for ${branchName}"`.text();
  if (!result.includes("No local changes to save")) {
    stashed = true;
    console.log("✓ Changes stashed");
  } else {
    console.log("No changes to stash");
  }
} catch (error) {
  console.log("No changes to stash");
}

// 最新化
console.log("Pulling latest changes...");
await $`git pull`;

// リポジトリのリモートURLからrepo_pathを取得
const remoteUrl = (await $`git config --get remote.origin.url`.text()).trim();
const repoMatch = remoteUrl.match(/github\.com[:/](.+?)(?:\.git)?$/);
if (!repoMatch) {
  console.error("Could not parse repository path from remote URL");
  process.exit(1);
}
const repoPath = repoMatch[1];

// worktreeディレクトリのパスを生成
const worktreeDir = resolve(
  process.env.HOME!,
  `worktrees/github.com/${repoPath}/${branchName}`
);

// ディレクトリが既に存在する場合はそこへcd
if (existsSync(worktreeDir)) {
  console.log(`Worktree already exists at: ${worktreeDir}`);
  console.log(`✓ Moving to existing worktree`);

  // stashしていた場合はpop
  if (stashed) {
    console.log("Popping stashed changes...");
    await $`git stash pop`;
    console.log("✓ Stashed changes restored");
  }

  // fishのrun_with_auto_cdがcdするためのマーカー
  console.log(`CD_TO:${worktreeDir}`);
  process.exit(0);
}

// ローカルブランチの存在を確認
let localBranchExists = false;
try {
  await $`git rev-parse --verify ${branchName}`.quiet();
  localBranchExists = true;
  console.log(`Found existing local branch: ${branchName}`);
} catch {
  localBranchExists = false;
}

// リモートブランチの存在を確認
let remoteBranchExists = false;
if (!localBranchExists) {
  try {
    await $`git rev-parse --verify origin/${branchName}`.quiet();
    remoteBranchExists = true;
    console.log(`Found existing remote branch: origin/${branchName}`);
  } catch {
    remoteBranchExists = false;
  }
}

// worktreeを作成
console.log(`Creating worktree at: ${worktreeDir}`);

try {
  if (localBranchExists) {
    // ローカルブランチが存在する場合はそれを使用
    await $`git worktree add ${worktreeDir} ${branchName}`;
  } else if (remoteBranchExists) {
    // リモートブランチが存在する場合はそれをチェックアウト
    await $`git worktree add ${worktreeDir} -b ${branchName} origin/${branchName}`;
  } else {
    // どちらも存在しない場合は現在のブランチから新規作成
    console.log(`Creating new branch from current branch: ${branchName}`);
    await $`git worktree add ${worktreeDir} -b ${branchName}`;
  }

  console.log(`✓ Worktree created successfully at: ${worktreeDir}`);

  // stashしていた場合はpop
  if (stashed) {
    console.log("Popping stashed changes...");
    await $`git stash pop`;
    console.log("✓ Stashed changes restored");
  }

  // fishのrun_with_auto_cdがcdするためのマーカー
  console.log(`CD_TO:${worktreeDir}`);
} catch (error) {
  console.error("Failed to create worktree:", error);
  // エラー時もstashをpop
  if (stashed) {
    console.log("Popping stashed changes...");
    await $`git stash pop`;
    console.log("✓ Stashed changes restored");
  }
  process.exit(1);
}
