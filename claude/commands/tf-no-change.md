---
allowed-tools: Bash(terraform plan:*),Edit(./*)
description: "make Terrafom no change"
---

# Your tasks
 - Fix it so that the Terraform plan results in no changes
 - Fix it so that no warnings appear
 - Finally, run terraform plan and confirm that there are no changes and no warnings

# How to plan
1. cd $ARGUMENTS (once only)
2. direnv allow (once only)
3. terraform plan
4. fix code.
5. terraform plan.
6. check if plan results in no change and no warning
7. if not, back to step 5