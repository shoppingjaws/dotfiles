---
name: terraform
description: Use when working with *.tf (terraform) files.
---

# Working in Each Workspace

When editing terraform resources, it is recommended to cd to each workspace before working. (Various necessary variables will be loaded by direnv)

# 📁 File Naming Convention

## Terraform File Naming Convention

This project follows the naming convention of [tflint-ruleset-file-name-is-resource-name](https://github.com/shoppingjaws/tflint-ruleset-file-name-is-resource-name):

## Basic Pattern
```
{resource_type}_{resource_name}.tf
```

### Resource File Examples:
- `google_storage_bucket.tf` - For Google Cloud Storage bucket resources
- `google_iam_workload_identity_pool.tf` - For Workload Identity Pool
- `google_project_iam_member.tf` - For project IAM members

### Data Source File Examples:
- `data_google_project.tf` - For Google Project data sources
- `data_google_client_config.tf` - For Google Client configuration data sources
- `data_google_service_account.tf` - For service account data sources

### Special Files:
- `variable.tf` - Module variable definitions
- `output.tf` - Module output definitions
- `provider.tf` - Provider configuration
- `locals.tf` - Local value definitions
- `main.tf` - Module declarations (when combining multiple modules)