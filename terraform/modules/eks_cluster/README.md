# Terraform Module: EKS Cluster

This reusable module deploys a complete EKS cluster with VPC, security groups, and IAM roles.

## Usage

```hcl
module "eks_cluster" {
  source = "../../modules/eks_cluster"

  aws_region         = "eu-central-1"
  environment        = "dev"
  cluster_name       = "my-cluster"
  vpc_cidr           = "10.0.0.0/16"
  node_instance_type = "t3.micro"
  desired_size       = 1
  min_size           = 1
  max_size           = 2
}
```

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| aws_region | string | - | AWS region |
| environment | string | - | Environment name (dev, staging, prod) |
| cluster_name | string | - | EKS cluster name |
| vpc_cidr | string | - | VPC CIDR block |
| node_instance_type | string | - | EC2 instance type for worker nodes |
| desired_size | number | - | Desired number of worker nodes |
| min_size | number | - | Minimum number of worker nodes |
| max_size | number | - | Maximum number of worker nodes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | EKS cluster ID |
| cluster_endpoint | EKS cluster endpoint |
| cluster_name | EKS cluster name |
| configure_kubectl | Command to configure kubectl |
| oidc_provider_arn | OIDC provider ARN for IRSA |

## Resources Created

- VPC with 2 public subnets (multi-AZ)
- Internet Gateway
- Route Table and associations
- Security Groups (cluster & nodes)
- EKS Cluster (Kubernetes 1.28)
- EKS Node Group with auto-scaling
- IAM roles and policies
- OIDC provider for service account authentication
