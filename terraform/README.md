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

## 💸 Minimizing AWS Costs (Pause vs Destroy)

EKS has two different "stop" levels:

- **Pause compute (keep cluster)**: scales node groups to 0 so you stop paying for EC2 worker nodes.
	You will still pay for the **EKS control plane** and any leftover AWS resources (e.g., Load Balancers, EBS volumes, NAT Gateways).
- **Destroy everything (lowest cost)**: removes the EKS cluster and supporting infra via Terraform.
	This is the only way to stop paying for the EKS control plane.

### Option A — Pause compute (scale nodes to 0)

From `terraform/environments/dev`:

```sh
terraform init
terraform apply \
	-var "min_size=0" -var "desired_size=0" -var "max_size=1" \
	-var "stateful_min_size=0" -var "stateful_desired_size=0" -var "stateful_max_size=1"
```

To resume later, apply your normal sizes again (or just run `terraform apply` with your `terraform.tfvars`).

### Option B — Destroy the environment (lowest ongoing cost)

From `terraform/environments/dev`:

Recommended (to avoid orphaned billable resources like ALBs and EBS volumes):

```sh
# Remove app Ingress (deletes the ALB created by AWS Load Balancer Controller)
helm -n default uninstall sre-portal

# Optional: remove monitoring first so Loki PVCs (EBS) are deleted
helm -n monitoring uninstall loki-stack
helm -n monitoring uninstall kube-prometheus-stack
```

Then destroy the infrastructure:

```sh
terraform init
terraform destroy
```

Notes:
- If you created any external resources manually (outside Terraform), those won’t be destroyed automatically.
- Persistent data may still have cost if it’s stored outside the cluster (e.g., EBS volumes or S3).
