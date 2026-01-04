# Backend configuration
# Initialize with: terraform init \
#   -backend-config="bucket=aetush-infra-state-37a4e43e" \
#   -backend-config="key=dev/terraform.tfstate" \
#   -backend-config="region=eu-central-1" \
#   -backend-config="dynamodb_table=terraform-locks"

terraform {
  backend "s3" {
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
