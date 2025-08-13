---
allowed-tools: Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(git log:*),Bash(git push -u origin HEAD),Bash(git add:*),Bash(git commit:*),Bash(gh pr list:*)
description: "update existing PR"
---

# Your Task

- Find existing PR for current branch
- Analyzes changes since PR creation
- Update Pull Request description based on the result of analysis

# Rule

- Must find and update existing PR for current branch
- must follow the style of @.github/PULL_REQUEST_TEMPLATE.md
- don't write based on speculation.
- Output Pull Request URL only
- use `git push -u origin HEAD` to push as possible