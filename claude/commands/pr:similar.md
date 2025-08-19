---
allowed-tools: Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(git log:*), Bash(git push -u origin HEAD), Bash(git add:*), Bash(git commit:*), Bash(gh search prs:*)
description: "Search past PRs and create a similar PR based on selected template"
---

# Your Task

1. Search for past merged PRs based on the user's request keywords
2. Show the list of found PRs with their titles and numbers
3. If multiple candidates exist, ask the user to select one
4. Analyze the selected PR's structure and content
5. Create a new PR using the same format and style as the selected template
6. Ensure the new PR follows the project's PR template guidelines

# Process

1. **Search Past PRs**: Use `gh pr list --state merged --search "KEYWORDS"` or `gh search prs "KEYWORDS repo:OWNER/REPO is:merged"` to find relevant past PRs
2. **Display Candidates**: Show PR titles, numbers, and brief descriptions
3. **User Selection**: If multiple candidates, prompt user to choose
4. **Analyze Template**: Use `gh pr view NUMBER` to get the full PR details including description
5. **Apply Template**: Create new PR following the same structure and style

# Rules

- Always search for merged PRs only (successful patterns)
- Display all relevant candidates before proceeding
- Make sure to always create Pull Requests as Draft
- Must follow the style of the selected PR template
- Don't write based on speculation
- Output Pull Request URL only after creation
- Use `git push -u origin HEAD` to push when possible
- If no suitable past PRs found, fall back to @.github/PULL_REQUEST_TEMPLATE.md

# Example Usage

User: "Create a PR similar to past feature additions"
→ Search for past feature PRs
→ Show list of candidates
→ User selects one
→ Create new PR using that template