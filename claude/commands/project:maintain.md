---
allowed-tools: Read(*), Glob(*.md), Glob(**/*skill*), Glob(**/*Skill*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Edit(*), MultiEdit(*)
description: "comprehensive project maintenance - check documentation, skills, and overall project health"
---

# Your Task

## 1. Documentation Check
- Check for CLAUDE.md and README.md files
- Verify documentation is up-to-date with current project state
- Identify missing or outdated documentation
- Check for consistency across documentation files
- Look for other relevant .md files in docs/ or documentation/ directories

## 2. Skills Maintenance
- Search for existing Skills files in the project
- Identify patterns and conventions used for Skills
- Check for outdated or broken Skills
- Suggest new Skills based on project needs

## 3. Project Health Assessment
- Review overall project structure
- Check for inconsistencies or areas needing improvement
- Identify opportunities for optimization

# Rule

- Prioritize CLAUDE.md for Claude-specific instructions
- Check README.md for general project documentation
- Verify documentation matches actual code/configuration
- Search common Skills locations: skills/, Skills/, src/skills/, etc.
- Follow existing code style and patterns
- Suggest updates only when clearly needed
- Don't create files unless explicitly requested
- Provide a comprehensive report with actionable suggestions
- Focus on maintaining existing quality rather than adding unnecessary features