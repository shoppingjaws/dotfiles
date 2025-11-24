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
