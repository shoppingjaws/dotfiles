---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Read(*)
description: "review git diff for typos, config mistakes, and potential issues"
---

# Your Task

- Review the current git changes (staged and unstaged) for potential issues
- Identify typos, configuration mistakes, and common errors
- Report findings with specific line references and suggestions

# Workflow

1. Run `git status` to understand the scope of changes
2. Run `git diff` for unstaged changes and `git diff --cached` for staged changes
3. Analyze each changed file for issues
4. If needed, read full files for additional context
5. Report findings in a clear, actionable format

# What to Look For

## Typos
- Misspelled variable/function names
- Incorrect string literals
- Typos in comments and documentation
- Wrong file names or paths

## Configuration Mistakes
- Invalid JSON/YAML syntax
- Missing required fields
- Wrong environment variable names
- Incorrect port numbers or URLs
- Mismatched quotes or brackets

## Code Quality Issues
- Unused imports or variables (if obvious from diff)
- Hardcoded secrets or credentials
- Debug code left in (console.log, print, etc.)
- Commented-out code that should be removed
- Inconsistent naming conventions

## Common Errors
- Off-by-one errors
- Null/undefined handling issues
- Missing error handling
- Incorrect operator usage (== vs ===, = vs ==)
- Copy-paste errors

# Output Format

Report findings as:
```
## [Filename]

### [Severity: Critical/Warning/Info] - [Issue Type]
- Line: [line number or range]
- Issue: [description]
- Suggestion: [how to fix]
```

# Rule

- Focus only on the changed lines and their immediate context
- Prioritize critical issues (security, syntax errors) over style issues
- Be specific about line numbers and exact problems
- Don't report issues in unchanged code unless directly related to changes
- If no issues found, explicitly state the changes look good
- For large diffs, focus on the most impactful files first
