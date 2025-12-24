---
allowed-tools: Bash(peer list:*), Bash(peer read:*)
description: "troubleshoot errors from peer panes - read terminal output, identify issues, and suggest fixes"
---

# Your Task

- Use the `peer` command to read terminal output from other panes in the same tab
- Identify errors, warnings, or issues in the output
- Analyze the root cause of the problem
- Provide actionable troubleshooting steps

# Workflow

1. Run `peer list` to see available panes in the current tab
2. Run `peer read <pane-id>` to read the content from target pane(s)
3. Analyze the output for errors, stack traces, or warning messages
4. Identify the likely cause of the issue
5. Suggest concrete solutions or next debugging steps

# Rule

- Always start by listing available panes with `peer list`
- Read from panes that likely contain error output (e.g., running processes, test output)
- Focus on finding error messages, stack traces, and warning logs
- When identifying issues, look for:
  - Exception/error messages
  - Exit codes
  - Failed assertions
  - Timeout errors
  - Connection failures
  - Syntax errors
  - Permission issues
- Provide clear, actionable recommendations
- If the error is ambiguous, suggest additional debugging steps
- Don't assume context - base analysis on actual output
- Prioritize the most recent or critical errors first
