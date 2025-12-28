---
name: terraform-editor
description: Use when creating or editing *.tf (terraform) files. Enforces file naming conventions.
---

# Terraform Editor Guidelines

When creating or editing Terraform files, follow these strict naming conventions based on [tflint-ruleset-file-name-is-resource-name](https://github.com/shoppingjaws/tflint-ruleset-file-name-is-resource-name).

## File Naming Rules

### Special Files (Fixed Names)

| Content Type | File Name |
|-------------|-----------|
| Variables | `variable.tf` |
| Modules | `main.tf` |
| Providers | `provider.tf` |
| Outputs | `output.tf` |
| Locals | `locals.tf` |

### Data Sources

**Pattern:** `data_{data_source_type}.tf`

| Valid | Invalid |
|-------|---------|
| `data_aws_instance.tf` | `data.tf` |
| `data_google_project.tf` | `datasources.tf` |
| `data_google_client_config.tf` | |

### Resources

**Pattern:** `{resource_type}.tf`

File name must match the resource type (without the `resource_` prefix).

| Valid | Invalid |
|-------|---------|
| `aws_instance.tf` | `ec2.tf` |
| `google_storage_bucket.tf` | `storage.tf` |
| `google_iam_workload_identity_pool.tf` | `iam.tf` |
| `google_project_iam_member.tf` | `members.tf` |

## Rules When Editing

1. **Creating a new resource**: Create a new file named `{resource_type}.tf`
2. **Creating a new data source**: Create a new file named `data_{data_source_type}.tf`
3. **Multiple resources of the same type**: Place them in the same file (e.g., multiple `aws_instance` resources go in `aws_instance.tf`)
4. **Never use generic names** like `main.tf` for resources (only use for module declarations)

## Examples

```hcl
# File: google_storage_bucket.tf
resource "google_storage_bucket" "my_bucket" {
  name     = "my-bucket"
  location = "US"
}

resource "google_storage_bucket" "another_bucket" {
  name     = "another-bucket"
  location = "EU"
}
```

```hcl
# File: data_google_project.tf
data "google_project" "current" {}

data "google_project" "other" {
  project_id = "other-project"
}
```
