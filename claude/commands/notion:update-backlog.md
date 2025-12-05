---
allowed-tools: "mcp__notion__notion-get-self","mcp__notion__notion-fetch", "mcp__notion__notion-search","mcp__notion__notion-get-comments","mcp__notion__notion-update-page", "Bash(echo $SHOPPINGJAWS_TASK_URLS)", "Bash(git branch --show-current)", "Bash(gh pr view:*)", "Bash(gh pr list:*)"
description: "Update My Backlog"
---

# Your Task

You are tasked with updating the Notion backlog with the progress of the current Claude Code task.

Follow these steps:

1. **Get Notion Database URL**: Use `echo $SHOPPINGJAWS_TASK_URLS` to retrieve the URL of the Notion database where tasks are managed.

2. **Get Current User Info**: Use `notion-get-self` to retrieve information about the current Notion user (bot user).

3. **Get GitHub PR Information**:
   - Use `git branch --show-current` to get the current branch name
   - Use `gh pr view --json url,title,number` to get PR information for the current branch
   - If no PR exists for the current branch, check if there are any recent PRs using `gh pr list --limit 5 --json url,title,number`
   - Store the PR URL, title, and number for inclusion in the update

4. **Fetch Database**: Use `notion-fetch` with the database URL to get the database schema and contents.

5. **Find Matching Task**:
   - Search through the database for pages that are assigned to the current user
   - Compare page titles with the current Claude Code task context
   - Identify the most appropriate Notion page based on title similarity and assignment

6. **Read Current Page**: Use `notion-fetch` to read the full content of the identified page.

7. **Update Progress**: Use `notion-update-page` with the `insert_content_after` command to insert progress information **at the top of the page (immediately after the title)** using the AI update format (see Rule section below). Include the GitHub PR information if available. **IMPORTANT**: NEVER use `replace_content` or `replace_content_range` - only use `insert_content_after` to ensure existing content is preserved.

# Rule

## AI Update Format

When updating Notion pages, ALWAYS use the following format to clearly indicate that the update was made by AI:

```markdown
<callout icon="🤖" color="blue_bg">
**AI進捗更新** - {{YYYY-MM-DD HH:MM}}

{{このClaude Codeセッションで行った作業の簡潔な要約（日本語）}}

**関連PR:** [#{{PR_NUMBER}} - {{PR_TITLE}}]({{PR_URL}})

**主な変更点:**
- {{変更内容1（日本語）}}
- {{変更内容2（日本語）}}
- {{変更内容3（日本語）}}
</callout>
```

**Note**: PRが見つからない場合は、「関連PR」の行を省略してください。

## Guidelines

- **ALWAYS WRITE IN JAPANESE**: All progress updates, summaries, and key changes MUST be written in Japanese (日本語)
- **NEVER DELETE OR REPLACE EXISTING CONTENT**: Always use `insert_content_after` to append new updates
- **DO NOT** use `replace_content` or `replace_content_range` commands
- **INSERT AT THE TOP**: Always insert progress updates at the very top of the page content, immediately after the page title
- Keep progress summaries concise and factual
- Focus on concrete changes and outcomes
- Use bullet points for clarity
- Always include the timestamp
- When using `insert_content_after`, select the page title as the snippet to insert after, so the update appears at the top of the page
- The most recent update should always be at the top, creating a chronological order (newest first)
