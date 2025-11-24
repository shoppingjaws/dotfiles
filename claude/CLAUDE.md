# CLAUDE.md - Claude Code Global Configuration

This file provides guidance to Claude Code (claude.ai/code) when working across all projects.

## 📋 Overview

- Language-specific best practices (Go, TypeScript, Python, Bash, Terraform, etc)

## Command Guidelines

- Use safe_find instead of find command (safe_find is not allowed to use -exec option) when file searching
- Use gh command instead of Fetch tool when fetch content from <https://github.com>
- Use cdr command to navigate to the git repository root directory
- Use .yaml instead of .yml extension when creating nwe YAML file
- Use bin/kustomize for Kustomize operations (allowed command)
- Use kzdiff to see changes of kustomize build result (see @docs/kzdiff.md )

## Task Guidelines

- When creating scripts for temporary file operations or repetitive tasks, it is recommended to write them in Deno.

## Script Execution with Docker Safe Sandbox

### Overview

`docker-safe-sandbox` is a tool for safely executing scripts in Docker containers. It respects `.gitignore` to exclude sensitive files and efficiently mounts dependencies like `node_modules` via `-v` for fast execution.

### Before Running Scripts

**IMPORTANT**: Always check available runtimes first:

```bash
docker-safe-sandbox ls
```

This command shows all available runtime configurations and their Docker images.

### Usage

```bash
docker-safe-sandbox --runtime <name> -- <command...>
```

### Examples

```bash
# Bun
docker-safe-sandbox --runtime bun -- bun run script.ts

# Node.js (if configured)
docker-safe-sandbox --runtime node -- node script.js

# Deno (if configured)
docker-safe-sandbox --runtime deno -- deno run script.ts
```

### Key Features

- **Security**: Automatically excludes files in `.gitignore` (e.g., `.env`)
- **Performance**: Dependencies are mounted read-only via `-v` for speed
- **Isolation**: Scripts run in isolated Docker containers
- **Cleanup**: Temporary files and containers are automatically removed

### Workflow

1. Check available runtimes: `docker-safe-sandbox ls`
2. Select appropriate runtime based on available options
3. Execute script with `--runtime` option
