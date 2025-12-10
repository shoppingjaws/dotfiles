---
allowed-tools: Bash(gh pr create --draft:*), Bash(gh pr view:*), Bash(gh pr edit:*), Bash(git log:*),Bash(git push -u origin HEAD),Bash(git add:*),Bash(git commit:*), Bash(gh search prs:*), Bash(gh repo view:*), Bash(gh pr comment:*)
description: "create or update PR (usage: /pr:create [optional overview])"
---

# Your Task

1. If user provided an overview as command argument, record it for later use in PR analysis
2. Check for uncommitted changes using `git status --porcelain`
3. If uncommitted changes exist, commit all changes first
4. Analyzes the purpose of committed changes.
5. Detect repository owner with the command `gh repo view --json owner --jq '.owner.login'`
6. Search for recent related PRs using the command: `gh search prs --author shoppingjaws --owner OWNER --limit 10 --sort updated`.
7. Read related PRs description using `gh pr view` to understand context and patterns
8. Search related backlog of this PR from $SHOPPINGJAWS_TASK_URL
9. Analyzes the purpose of this PR considering:
   - User-provided overview (if any)
   - Committed changes
   - Related PRs context
   - Related backlog items
10. Update or Create PullRequest description based on the result of analysis
11. Check for any misconfigurations and typos. If they exist, please add a comment about them.

# Rule

- If user provides an overview argument, use it as a guideline for PR purpose analysis
- Please write in a way that clearly explains the background and purpose of the changes
- DO NOT include a list of file changes in the PR description
- DO NOT mention indentation changes, formatting changes, or whitespace modifications
- Focus on functional changes and business value, not technical implementation details
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
- When referencing PR numbers, always include a space after the number (e.g., "#1234 がXXです" not "#1234がXXです")
- Search and analyze recent PRs (last 10) to find related context and maintain consistency