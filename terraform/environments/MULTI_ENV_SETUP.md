# Multi-Environment Setup Guide

This Terraform configuration is designed to be simple yet multi-environment ready.

## Directory Structure

```
terraform/
├── bootstrap/           # One-time setup (state bucket, OIDC)
├── environments/
│   ├── dev/            # Development environment
│   ├── staging/        # (To be created)
│   └── prod/           # (To be created)
└── modules/            # (Optional: shared modules)
```

## How to Add a New Environment

Adding a new environment (e.g., `staging`) is straightforward:

### 1. Copy the dev environment
```bash
cp -r terraform/environments/dev terraform/environments/staging
```

### 2. Update terraform.tfvars
Edit `terraform/environments/staging/terraform.tfvars`:
```hcl
environment        = "staging"
cluster_name       = "aetush-staging-cluster"
node_instance_type = "t3.small"   # Can upgrade for staging
desired_size       = 2             # More nodes for staging
```

### 3. Initialize and deploy
```bash
cd terraform/environments/staging
terraform init \
  -backend-config="bucket=aetush-infra-state-37a4e43e" \
  -backend-config="key=staging/terraform.tfstate" \
  -backend-config="region=eu-central-1" \
  -backend-config="dynamodb_table=terraform-locks"

terraform apply
```

## Configuration Hierarchy

Files are organized from global to specific:

1. **variables.tf** - Declare all variables
2. **locals.tf** - Compute common values
3. **terraform.tfvars** - Environment-specific values (CUSTOMIZABLE)
4. **backend.tf** - State management setup
5. **main.tf** - Provider config
6. ***.tf** - Resource definitions

## Best Practices

✅ **Change only terraform.tfvars** per environment
❌ **Don't modify** resource definitions per environment
✅ **Use locals** for computed values
✅ **Use variables** for configuration
✅ **Use tags** for cost allocation and management

## Quick Reference

### Deploy Dev
```bash
cd terraform/environments/dev
terraform init -backend-config=... # (if first time)
terraform apply
```

### Deploy Staging
```bash
cd terraform/environments/staging
terraform init -backend-config=... # (if first time)
terraform apply
```

### Destroy Dev
```bash
cd terraform/environments/dev
terraform destroy
```

## Cost Optimization by Environment

| Environment | Instance Type | Nodes | Cost/Month |
|-------------|---------------|-------|-----------|
| dev         | t3.micro      | 1     | $0 (free tier) |
| staging     | t3.small      | 2     | ~$15 |
| prod        | t3.medium     | 3+    | ~$50+ |

Adjust `terraform.tfvars` per environment to control costs.
