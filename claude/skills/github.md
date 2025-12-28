---
name: github
description: Use when working with GitHub operations (PRs, Issues, Workflows, etc). Requires unsandbox mode.
---

# GitHub Operations Skill

This skill provides guidance for working with GitHub using the `gh` CLI.

## Important: Sandbox Mode

GitHub operations require **unsandbox mode** to execute. Commands that interact with GitHub's API will fail in sandboxed mode.

## Available Commands

### Pull Requests

| Operation | Command |
|-----------|---------|
| List PRs | `gh pr list` |
| View PR details | `gh pr view <number>` |
| View PR diff | `gh pr diff <number>` |
| Check PR status | `gh pr checks <number>` |
| Create draft PR | `gh pr create --draft` |
| Create PR | `gh pr create --title "title" --body "body"` |
| Review PR | `gh pr review <number> --approve` |
| Merge PR | `gh pr merge <number>` |

### Issues

| Operation | Command |
|-----------|---------|
| List issues | `gh issue list` |
| View issue | `gh issue view <number>` |
| Create issue | `gh issue create --title "title" --body "body"` |
| Close issue | `gh issue close <number>` |
| Reopen issue | `gh issue reopen <number>` |
| Add labels | `gh issue edit <number> --add-label "bug"` |

### Workflows (GitHub Actions)

| Operation | Command |
|-----------|---------|
| List workflows | `gh workflow list` |
| View workflow | `gh workflow view <workflow>` |
| List runs | `gh run list` |
| View run details | `gh run view <run-id>` |
| Watch run | `gh run watch <run-id>` |
| Download artifacts | `gh run download <run-id>` |
| Rerun workflow | `gh run rerun <run-id>` |

### Repository

| Operation | Command |
|-----------|---------|
| View repo | `gh repo view` |
| Clone repo | `gh repo clone <owner/repo>` |
| Fork repo | `gh repo fork` |
| List releases | `gh release list` |
| View release | `gh release view <tag>` |

### API Access

For advanced operations, use the API directly:

```bash
# Get PR comments
gh api repos/{owner}/{repo}/pulls/{number}/comments

# Get issue comments
gh api repos/{owner}/{repo}/issues/{number}/comments

# Get workflow runs
gh api repos/{owner}/{repo}/actions/runs
```

## Best Practices

1. **Use `gh` instead of WebFetch** for GitHub content - it handles authentication automatically
2. **Prefer draft PRs** when work is in progress: `gh pr create --draft`
3. **Check PR status** before merging: `gh pr checks <number>`
4. **Use `--json` flag** for machine-readable output: `gh pr list --json number,title,state`
5. **Watch workflow runs** for real-time updates: `gh run watch <run-id>`

## Common Workflows

### Create and Push a PR

```bash
# 1. Check current status
git status

# 2. Stage and commit changes
git add . && git commit -m "feat: description"

# 3. Push to remote
git push -u origin <branch>

# 4. Create PR
gh pr create --title "feat: description" --body "## Summary\n- Changes made"
```

### Investigate CI Failures

```bash
# 1. List recent workflow runs
gh run list --limit 5

# 2. View failed run details
gh run view <run-id>

# 3. View run logs
gh run view <run-id> --log-failed
```

### Review and Merge PR

```bash
# 1. View PR changes
gh pr diff <number>

# 2. Check PR status
gh pr checks <number>

# 3. Approve if satisfied
gh pr review <number> --approve

# 4. Merge
gh pr merge <number> --squash
```
