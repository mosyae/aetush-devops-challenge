variable "bucket_suffix" {
  description = "Unique suffix for the Terraform state bucket"
  type        = string
  default     = "37a4e43e"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}
