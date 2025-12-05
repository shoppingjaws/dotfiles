---
allowed-tools: Bash(gh pr create:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(git log:*),Bash(git push -u origin HEAD),Bash(git add:*),Bash(git commit:*), Bash(gh search prs:*), Bash(gh repo view:*), Bash(gh pr comment:*)
description: "create or update PR"
---

# Your Task

1. Check for uncommitted changes using `git status --porcelain`
2. If uncommitted changes exist, commit all changes first
3. Analyzes the purpose of committed changes.
4. Detect repository owner with the command `gh repo view --json owner --jq '.owner.login'`
5. Search for related PRs using the command to retrieve the PR purpose: `gh search prs --author shoppingjaws --owner OWNER`.
6. Read related PRs description `gh pr view`
7. Search related backlog of this PR from $SHOPPINGJAWS_TASK_URL
8. Analyzes the purpose of this PR
9. Update or Create PullRequest description based on the result of analysis
10. Check for any misconfigurations and typos. If they exist, please add a comment about them.

# Rule

- Please write in a way that clearly explains the background and purpose of the changes
- A list of file changes is not necessary in the PR description
- Must commit all changes before creating PR (use `git add -A` and `git commit`)
- Make sure to always create Pull Requests as Draft.
- must follow the style of @.github/PULL_REQUEST_TEMPLATE.md
- don't write based on speculation.
- Output Pull Request URL only
- use `git push -u origin HEAD` to push as possible
- DO NOT create temporary files or use Edit/Write tools for PR descriptions
- Use HEREDOC to pass PR body directly to `gh pr create --body` command
- Example: `gh pr create --draft --title "..." --body "$(cat <<'EOF'\n...\nEOF\n)"`
- NEVER use /tmp/ or any temporary file for storing PR descriptions