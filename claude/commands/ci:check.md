---
allowed-tools: Bash(gh pr checks:*), Bash(gh pr view:*), Bash(gh run view:*), Bash(gh run list:*), Bash(gh workflow view:*), Bash(git log:*), Bash(git diff:*), Edit(*)
description: "investigate CI failure causes (usage: /ci:check [GitHub Actions URL])"
---

# Your Task

- Investigate the causes of CI failures
- Analyze failed checks, workflows, and test results
- Provide actionable insights for fixing the failures

# Arguments

$ARGUMENTS

- If a GitHub Actions URL is provided (e.g., `https://github.com/owner/repo/actions/runs/12345`), investigate that specific workflow run
- If no argument is provided, investigate CI failures in the current PR

# Rule

- If URL is provided, extract run ID and use `gh run view <run-id>` to investigate
- If no URL, check PR status and associated checks first
- Identify specific failing workflows or tests
- Analyze recent commits that might have caused the failure
- Provide clear explanation of failure causes
- Suggest concrete steps to fix the issues
- Don't speculate without evidence from CI logs
- Skip the failure that does not related to this PR
- Try to avoid using the ⁠gh api command if possible