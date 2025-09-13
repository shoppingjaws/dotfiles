#!/usr/bin/env -S deno run --allow-read --allow-write

import * as path from "https://deno.land/std@0.224.0/path/mod.ts";

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
  try {
    await Deno.stat(source);
  } catch (error) {
    console.error(`Source file does not exist: ${source}`);
    return;
  }

  // Create parent directory if it doesn't exist
  const targetDir = path.dirname(target);
  try {
    await Deno.mkdir(targetDir, { recursive: true });
  } catch (error) {
    if (!(error instanceof Deno.errors.AlreadyExists)) {
      throw error;
    }
  }

  // Check if target already exists
  let targetExists = false;
  let targetInode = "";
  let sourceInode = "";

  try {
    const targetStat = await Deno.lstat(target);
    targetExists = true;
    targetInode = `${targetStat.dev}-${targetStat.ino}`;

    const sourceStat = await Deno.stat(source);
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
      await Deno.remove(target);
      if (verbose) {
        console.log(`Removed existing: ${target}`);
      }
    } else {
      console.warn(`Skipping: ${target} already exists (use --force to overwrite)`);
      return;
    }
  } catch (error) {
    if (!(error instanceof Deno.errors.NotFound)) {
      throw error;
    }
  }

  // Create hard link
  try {
    await Deno.link(source, target);
    if (verbose) {
      console.log(`Created hard link: ${target} -> ${source}`);
    }
  } catch (error) {
    console.error(`Failed to create hard link for ${target}:`, error);
  }
}

async function syncDirectory(sourceDir: string, targetDir: string, options: SyncOptions): Promise<void> {
  try {
    await Deno.stat(sourceDir);
  } catch {
    console.error(`Source directory does not exist: ${sourceDir}`);
    Deno.exit(1);
  }

  for await (const entry of Deno.readDir(sourceDir)) {
    const sourcePath = path.join(sourceDir, entry.name);
    const targetPath = path.join(targetDir, entry.name);

    if (entry.isDirectory) {
      // Recursively sync subdirectories
      await syncDirectory(sourcePath, targetPath, options);
    } else if (entry.isFile) {
      // Create hard link for files
      await createHardlink(sourcePath, targetPath, options);
    }
  }
}

async function main() {
  const args = Deno.args;

  let force = false;
  let verbose = false;
  let dryRun = false;
  let help = false;
  const positionals: string[] = [];

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === "-f" || arg === "--force") {
      force = true;
    } else if (arg === "-v" || arg === "--verbose") {
      verbose = true;
    } else if (arg === "--dry-run") {
      dryRun = true;
    } else if (arg === "-h" || arg === "--help") {
      help = true;
    } else if (!arg.startsWith("-")) {
      positionals.push(arg);
    }
  }

  if (help || positionals.length < 2) {
    console.log(`
Usage: deno run --allow-read --allow-write hardlink-sync.ts <source-dir> <target-dir> [options]

Creates hard links from source directory to target directory.

Options:
  -f, --force      Force overwrite existing files/links
  -v, --verbose    Show detailed output
  --dry-run        Show what would be done without making changes
  -h, --help       Show this help message

Example:
  deno run --allow-read --allow-write hardlink-sync.ts ./fish ~/.config/fish --force --verbose
`);
    Deno.exit(0);
  }

  const sourceDir = path.resolve(positionals[0]);
  const targetDir = path.resolve(positionals[1]);

  const options: SyncOptions = {
    source: sourceDir,
    target: targetDir,
    force,
    verbose,
    dryRun,
  };

  console.log(`Creating hard links from ${sourceDir} to ${targetDir}...`);

  await syncDirectory(sourceDir, targetDir, options);

  console.log("✅ Hard link sync completed successfully!");
}

if (import.meta.main) {
  main();
}