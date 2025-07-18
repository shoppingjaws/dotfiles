# 🏗️ CLAUDE.md - Claude Code Global Configuration

This file provides guidance to Claude Code (claude.ai/code) when working across all projects.

## 📋 Overview

- Language-specific best practices (Go, TypeScript, Python, Bash, Terraform, etc)

## PR Guidelines

- Create PR with draft
- PRs must always conform to the template format
- Focus on high-level problem and solution
- PR titles should be concise and clearly describe the changes made
- For PR templates, write 'NA' for any sections you don't understand

## Command Guidelines

- Do not use find command, use safe_find instead.(safe_find is not allowed to use -exec option) when file searching
- Do not use Fetch tool when fetch content from <https://github.com> , use gh command instead.

## Task Guidelines

- When creating scripts for temporary file operations or repetitive tasks, it is recommended to write them in Deno.
