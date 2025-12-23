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

### Wezterm Pane Operations

Use `wezterm-peer` command to interact with panes in the same tab:
- `wezterm-peer list` - List all panes in the current tab
- `wezterm-peer read <pane-id> [--start-line N] [--end-line N]` - Read text from a specific pane in the same tab

Note: This command only accesses panes within the same tab for security reasons.

## Task Guidelines

- When creating scripts for temporary file operations or repetitive tasks, it is recommended to write them in Deno.

## MCP

### container-use MCP

ALWAYS use ONLY Environments for ANY and ALL file, code, or shell operations—NO EXCEPTIONS—even for simple or generic requests.

DO NOT install or use the git cli with the environment_run_cmd tool. All environment tools will handle git operations for you. Changing ".git" yourself will compromise the integrity of your environment.

You MUST inform the user how to view your work using `container-use log <env_id>` AND `container-use checkout <env_id>`. Failure to do this will make your work inaccessible to others.