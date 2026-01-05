# Infrastructure as Code (Terraform)

This directory contains the Terraform configuration to provision the AWS EKS environment.

## 🏗️ Modules

- **`eks_cluster`**: Provisions the EKS Control Plane, Node Groups, VPC CNI, and IAM roles.
- **`monitoring`**: Deploys the PLG Stack (Prometheus, Loki, Grafana) via Helm.
- **`networking`**: VPC, Subnets, and Security Groups.

## ⚙️ Configuration

The environment is configured in `environments/dev/terraform.tfvars`.

| Variable | Value | Description |
|----------|-------|-------------|
| `instance_types` | `["t3.small"]` | Cost-effective Spot instances. |
| `desired_size` | `2` | Initial node count. |
| `max_size` | `3` | Max node count for Autoscaler. |

## 🔐 IAM & Security

- **OIDC**: Enabled for GitHub Actions and Service Accounts.
- **IRSA**: Used for Load Balancer Controller, Autoscaler, and EBS CSI Driver.
