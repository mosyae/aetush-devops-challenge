locals {
  common_tags = {
    Environment = var.environment
    Project     = "aetush-devops-challenge"
    Terraform   = "true"
  }

  public_subnet_azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}
