#!/usr/bin/env bun

import * as path from "path";
import { parseArgs } from "util";

interface SyncOptions {
  source: string;
  target: string;
  force?: boolean;
  verbose?: boolean;
  dryRun?: boolean;
}

async function createHardlink(source: string, target: string, options: SyncOptions): Promise<void> {
  const { force, verbose, dryRun } = options;

  if (dryRun) {
    console.log(`[DRY RUN] Would create hard link: ${target} -> ${source}`);
    return;
  }

  // Check if source file exists
  const sourceFile = Bun.file(source);
  if (!(await sourceFile.exists())) {
    console.error(`Source file does not exist: ${source}`);
    return;
  }

  // Create parent directory if it doesn't exist
  const targetDir = path.dirname(target);
  const fs = await import("fs/promises");
  try {
    await fs.mkdir(targetDir, { recursive: true });
  } catch (error: any) {
    if (error.code !== "EEXIST") {
      throw error;
    }
  }

  // Check if target already exists
  let targetExists = false;
  let targetInode = "";
  let sourceInode = "";

  try {
    const targetStat = await fs.lstat(target);
    targetExists = true;
    targetInode = `${targetStat.dev}-${targetStat.ino}`;

    const sourceStat = await fs.stat(source);
    sourceInode = `${sourceStat.dev}-${sourceStat.ino}`;

    // If target is already a hard link to the same source, skip
    if (targetInode === sourceInode) {
      if (verbose) {
        console.log(`Already linked: ${target} -> ${source}`);
      }
      return;
    }

    // If force is enabled, remove existing file/link
    if (force) {
      await fs.unlink(target);
      if (verbose) {
        console.log(`Removed existing: ${target}`);
      }
    } else {
      console.warn(`Skipping: ${target} already exists (use --force to overwrite)`);
      return;
    }
  } catch (error: any) {
    if (error.code !== "ENOENT") {
      throw error;
    }
  }

  // Create hard link
  try {
    await fs.link(source, target);
    if (verbose) {
      console.log(`Created hard link: ${target} -> ${source}`);
    }
  } catch (error) {
    console.error(`Failed to create hard link for ${target}:`, error);
  }
}

async function syncDirectory(sourceDir: string, targetDir: string, options: SyncOptions): Promise<void> {
  const fs = await import("fs/promises");

  try {
    await fs.stat(sourceDir);
  } catch {
    console.error(`Source directory does not exist: ${sourceDir}`);
    process.exit(1);
  }

  const entries = await fs.readdir(sourceDir, { withFileTypes: true });

  for (const entry of entries) {
    const sourcePath = path.join(sourceDir, entry.name);
    const targetPath = path.join(targetDir, entry.name);

    if (entry.isDirectory()) {
      // Recursively sync subdirectories
      await syncDirectory(sourcePath, targetPath, options);
    } else if (entry.isFile()) {
      // Create hard link for files
      await createHardlink(sourcePath, targetPath, options);
    }
  }
}

async function main() {
  const { values, positionals } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      force: {
        type: "boolean",
        short: "f",
      },
      verbose: {
        type: "boolean",
        short: "v",
      },
      "dry-run": {
        type: "boolean",
      },
      help: {
        type: "boolean",
        short: "h",
      },
    },
    allowPositionals: true,
  });

  if (values.help || positionals.length < 2) {
    console.log(`
Usage: bun hardlink-sync.ts <source-dir> <target-dir> [options]

Creates hard links from source directory to target directory.

Options:
  -f, --force      Force overwrite existing files/links
  -v, --verbose    Show detailed output
  --dry-run        Show what would be done without making changes
  -h, --help       Show this help message

Example:
  bun hardlink-sync.ts ./fish ~/.config/fish --force --verbose
`);
    process.exit(0);
  }

  const sourceDir = path.resolve(positionals[0] as string);
  const targetDir = path.resolve(positionals[1] as string);

  const options: SyncOptions = {
    source: sourceDir,
    target: targetDir,
    force: values.force as boolean,
    verbose: values.verbose as boolean,
    dryRun: values["dry-run"] as boolean,
  };

  console.log(`Creating hard links from ${sourceDir} to ${targetDir}...`);

  await syncDirectory(sourceDir, targetDir, options);

  console.log("✅ Hard link sync completed successfully!");
}

main();