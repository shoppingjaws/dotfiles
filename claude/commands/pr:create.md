---
allowed-tools: Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(git log:*),Bash(git push -u origin HEAD),Bash(git add:*),Bash(git commit:*)
description: "create or update PR"
---

# Your Task

- Check for uncommitted changes using `git status --porcelain`
- If uncommitted changes exist, commit all changes first
- Analyzes committed changes
- Update or Create PullRequest description based on the result of analysis

# Rule

- Must commit all changes before creating PR (use `git add -A` and `git commit`)
- Make sure to always create Pull Requests as Draft.
- must follow the style of @.github/PULL_REQUEST_TEMPLATE.md
- don't write based on speculation.
- Output Pull Request URL only
- use `git push -u origin HEAD` to push as possible