---
allowed-tools: Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh pr create:*), Bash(gh pr edit:*), Bash(git log:*), Bash(git push -u origin HEAD), Bash(git add:*), Bash(git commit:*), Bash(gh search prs:*)
description: "Search past PRs and create a similar PR based on selected template"
---

# Your Task

1. Analyze current changes to understand the scope and type of modifications
2. Search for past merged PRs based on the user's request keywords AND change patterns
3. Evaluate relevance of found PRs by comparing file changes and context
4. Show filtered candidates with relevance scores
5. If multiple candidates exist, ask the user to select one
6. Verify the selected PR is appropriate for the current changes
7. Create a new PR using the same format and style as the selected template
8. Ensure the new PR follows the project's PR template guidelines

# Process

1. **Analyze Current Changes**:
   - Run `git diff --name-only` to see changed files
   - Run `git diff --stat` to understand change scope
   - Identify patterns (e.g., config files, feature additions, refactoring, documentation)

2. **Search Past PRs**:
   - Use `gh pr list --state merged --search "KEYWORDS"` or `gh search prs "KEYWORDS repo:OWNER/REPO is:merged"` to find relevant past PRs
   - Limit to reasonable number (e.g., --limit 20)

3. **Evaluate Relevance**:
   - For each candidate PR, use `gh pr view NUMBER --json files` to get changed files
   - Compare file patterns with current changes (e.g., same directories, similar file types)
   - Check if PR titles/descriptions match the type of change being made
   - Filter out PRs that are clearly unrelated

4. **Display Filtered Candidates**:
   - Show only PRs that have relevance to current changes
   - Include: PR number, title, similarity indicators (e.g., "Same directory", "Similar files")
   - Sort by relevance

5. **User Selection**:
   - If multiple candidates remain, prompt user to choose
   - If only one highly relevant candidate, suggest it but allow user to decline

6. **Verify Template**:
   - Show user key aspects of selected PR (title format, section structure, level of detail)
   - Ask for confirmation that this template is appropriate

7. **Analyze Template**:
   - Use `gh pr view NUMBER` to get the full PR details including description
   - Identify the structure (sections, formatting, tone)

8. **Apply Template**:
   - Create new PR as DRAFT following the same structure and style
   - Use `gh pr create --draft` to ensure PR is created as draft
   - Adapt content to current changes (don't copy unrelated content)

# Rules

- Always search for merged PRs only (successful patterns)
- MUST analyze current changes before searching for PRs
- MUST filter candidates based on file/directory similarity
- Display only relevant candidates (max 10) before proceeding
- Make sure to always create Pull Requests as Draft
- Must follow the style of the selected PR template, but adapt content to current changes
- Don't copy content from template PR that is unrelated to current changes
- Don't write based on speculation
- Output Pull Request URL only after creation
- Use `git push -u origin HEAD` to push when possible
- If no suitable past PRs found after filtering, fall back to @.github/PULL_REQUEST_TEMPLATE.md

# Example Usage

User: "Create a PR similar to past feature additions"
→ Analyze current git diff (files changed, scope)
→ Search for past feature PRs with --limit 20
→ Get changed files for each candidate PR
→ Filter candidates based on file pattern similarity
→ Show top 5-10 relevant candidates with similarity indicators
→ User selects one
→ Show template structure and ask for confirmation
→ Create new PR using that template (adapting content to current changes)
