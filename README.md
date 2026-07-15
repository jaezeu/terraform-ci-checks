# terraform-ci-checks

A minimal Terraform project used to run CI checks for Terraform code in GitHub Actions. The repository provisions an example AWS S3 bucket and includes workflows that run formatting, validation, linting, security scanning, planning, and apply steps for changes to the Terraform configuration.

## What this repository contains

This repository currently defines:

- AWS provider configured for `ap-southeast-1`
- S3 backend configuration for Terraform state (`sctp-ce12-tfstate-bucket`)
- One sample resource: `aws_s3_bucket.example`
- GitHub Actions workflows for Terraform CI, plan, and apply

## CI checks performed

The main CI workflow (`.github/workflows/terraform-ci.yaml`) runs on pull requests to `main` and executes:

1. `terraform fmt -check`
2. `terraform init`
3. `terraform validate`
4. `tflint --init` and `tflint -f compact`
5. Checkov scan (`bridgecrewio/checkov-action` with `framework: terraform`)
6. `terraform plan`

Additional workflows:

- **Terraform Plan** (`terraform-plan.yaml`): runs `terraform init` + `terraform plan` on pull requests to `main`
- **Terraform Apply** (`terraform-apply.yaml`): runs `terraform apply -auto-approve` on pushes to `main`

## Repository structure

| Path | Purpose |
|---|---|
| `main.tf` | Defines the sample `aws_s3_bucket` resource |
| `provider.tf` | Configures AWS provider region |
| `backend.tf` | Sets Terraform version, backend, and provider requirements |
| `.terraform.lock.hcl` | Provider dependency lock file |
| `.github/workflows/terraform-ci.yaml` | Full CI checks workflow |
| `.github/workflows/terraform-plan.yaml` | Plan-only workflow |
| `.github/workflows/terraform-apply.yaml` | Apply workflow on `main` pushes |

## Prerequisites

To run checks locally, install:

- Terraform `>= 1.14` (as required by `backend.tf`)
- AWS credentials with access to the configured backend bucket and target resources
- TFLint
- Checkov (for reproducing the security scan locally)

## Run checks locally

From repository root:

```bash
terraform fmt -check
terraform init
terraform validate
tflint --init
tflint -f compact
checkov -d . --framework terraform
terraform plan
```

If you only need to initialize without contacting the remote backend during local verification:

```bash
terraform init -backend=false
```

## GitHub Actions triggers

| Workflow | Trigger |
|---|---|
| `terraform-ci.yaml` | `pull_request` targeting `main` |
| `terraform-plan.yaml` | `pull_request` targeting `main` |
| `terraform-apply.yaml` | `push` to `main` |

## Required GitHub Secrets

These workflows expect the following repository secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

No GitHub Actions repository variables are referenced in the current workflow files.
