#!/usr/bin/env bun

import { $ } from "bun";

// 現在いるディレクトリがworktreeであれば、このworktreeを削除する。
// 削除する際に、remoteへ未pushの変更がある場合は、確認を行う。

const currentDir = process.cwd();

// Check if current directory is a worktree
const worktreeList = await $`git worktree list`.text();
if (!worktreeList.includes(currentDir)) {
  console.error("Not in a worktree");
  process.exit(1);
}
// Check for unpushed changes and uncommitted changes
const branch = (await $`git branch --show-current`.text()).trim();

let unpushedCommits = 0;
try {
  const result = await $`git rev-list --count HEAD ^origin/${branch}`
    .quiet()
    .text();
  unpushedCommits = parseInt(result.trim(), 10);
} catch {
  // If the command fails (e.g., no upstream branch), assume 0
  unpushedCommits = 0;
}

const statusOutput = await $`git status --porcelain`.text();
const hasChanges = statusOutput.trim().length > 0;

// Prompt for confirmation if there are unpushed or uncommitted changes
if (unpushedCommits > 0 || hasChanges) {
  if (unpushedCommits > 0) {
    process.stderr.write(`Unpushed changes detected (${unpushedCommits} commits).\n`);
  }
  if (hasChanges) {
    process.stderr.write("Uncommitted changes detected.\n");
  }
  process.stderr.write("Continue? (y/N) ");

  // Read user input
  const answer = prompt("");
  if (answer?.toLowerCase() !== "y") {
    console.log("Cancelled");
    process.exit(1);
  }
}

// Get main worktree path
const worktreeLines = worktreeList.trim().split("\n");
const mainWorktree = worktreeLines[0].split(/\s+/)[0];

// Remove worktree
try {
  await $`git worktree remove ${currentDir} --force`;
  console.log("Worktree removed");

  // Output CD marker to move to main worktree
  console.log(`CD_TO:${mainWorktree}`);
} catch (error) {
  console.error("Failed to remove worktree:", error);
  process.exit(1);
}
