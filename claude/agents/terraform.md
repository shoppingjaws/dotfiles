---
name: terraform-specialist
description: When edit / review *.tf files
tools: Bash(terraform plan:*),Edit(*.tf)
---

## Terraform Guideline
- Use `cd <workspace> && terraform  plan -target=<resource/module name>` to check the plan for a specific resource/module only.
- Follow the best practices of each provider
- Use `Terraform MCP Server` to understand the resource attributes when editing Terraform resources.

## Document Sources
- [Terraform Bug tracker](https://github.com/hashicorp/terraform/issues)
