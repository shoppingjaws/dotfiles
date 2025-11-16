#!/usr/bin/env bun

import { $ } from "bun";

// すべてのworktree（メインworktree以外）を削除する
// 削除する際に、remoteへ未pushの変更がある場合は、警告を表示する

const currentDir = process.cwd();

// Get all worktrees
const worktreeList = await $`git worktree list`.text();
const worktreeLines = worktreeList.trim().split("\n");

if (worktreeLines.length <= 1) {
  console.log("No worktrees to remove");
  process.exit(0);
}

// メインworktree（最初のエントリ）を取得
const mainWorktree = worktreeLines[0].split(/\s+/)[0];

// メインworktree以外のworktreeを取得
const worktreesToRemove = worktreeLines.slice(1).map((line) => {
  const parts = line.split(/\s+/);
  return {
    path: parts[0],
    branch: parts[2]?.replace(/[\[\]]/g, ""), // [branch] から branch を抽出
  };
});

console.log(`Found ${worktreesToRemove.length} worktree(s) to remove:`);
worktreesToRemove.forEach((wt) => {
  console.log(`  - ${wt.path} (${wt.branch || "detached"})`);
});

// 各worktreeで未pushの変更や未コミットの変更をチェック
const warnings: string[] = [];

for (const worktree of worktreesToRemove) {
  try {
    // worktreeのディレクトリに移動してチェック
    const statusOutput = await $`git -C ${worktree.path} status --porcelain`.text();
    const hasChanges = statusOutput.trim().length > 0;

    if (hasChanges) {
      warnings.push(
        `${worktree.path}: Uncommitted changes detected`
      );
    }

    // ブランチがある場合は未pushのコミットをチェック
    if (worktree.branch) {
      try {
        const result = await $`git -C ${worktree.path} rev-list --count HEAD ^origin/${worktree.branch}`
          .quiet()
          .text();
        const unpushedCommits = parseInt(result.trim(), 10);
        if (unpushedCommits > 0) {
          warnings.push(
            `${worktree.path}: ${unpushedCommits} unpushed commit(s)`
          );
        }
      } catch {
        // upstream branchがない場合は無視
      }
    }
  } catch (error) {
    // エラーが発生してもスキップして続行
  }
}

// 警告がある場合は表示して確認
if (warnings.length > 0) {
  console.log("\nWarnings:");
  warnings.forEach((warning) => console.log(`  ⚠ ${warning}`));
  console.log("\nContinue removing all worktrees? (y/N)");

  const answer = prompt("");
  if (answer?.toLowerCase() !== "y") {
    console.log("Cancelled");
    process.exit(1);
  }
}

// すべてのworktreeを削除
console.log("\nRemoving worktrees...");
let removedCount = 0;
let failedCount = 0;

for (const worktree of worktreesToRemove) {
  try {
    await $`git worktree remove ${worktree.path} --force`;
    console.log(`✓ Removed: ${worktree.path}`);
    removedCount++;
  } catch (error) {
    console.error(`✗ Failed to remove: ${worktree.path}`);
    failedCount++;
  }
}

console.log(
  `\nRemoved ${removedCount} worktree(s)${failedCount > 0 ? `, ${failedCount} failed` : ""}`
);

// メインworktreeに戻る（現在のディレクトリがworktreeだった場合）
if (!currentDir.startsWith(mainWorktree)) {
  console.log(`CD_TO:${mainWorktree}`);
}
