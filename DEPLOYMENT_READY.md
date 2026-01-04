# Deployment Guide - Ready to Deploy

## ✅ What's Fixed and Ready

Your Terraform configuration is now **fully validated and ready to deploy**:
- Helm provider syntax: ✅ Fixed
- Terraform state: ✅ Clean
- Configuration validation: ✅ Passed
- AWS Load Balancer Controller: ✅ Auto-deploy configured

## 🚀 Quick Start - Deploy EKS Cluster

### Step 1: Deploy Bootstrap Infrastructure (One-Time)
Only needed if you haven't already created the S3 state bucket:

```bash
cd terraform/bootstrap
terraform init
terraform apply
# Note the bucket name output
```

### Step 2: Deploy Dev Environment Cluster

```bash
cd terraform/environments/dev
terraform init
terraform plan    # Review what will be created (~15-20 min to deploy)
terraform apply
```

**Resources Created:**
- EKS Cluster (Kubernetes 1.31)
- 1 t3.micro node (SPOT instance for cost savings)
- VPC with public subnets
- Security groups and IAM roles
- ECR repository (aetush-dev-cluster-ecr)
- **AWS Load Balancer Controller** (auto-installed via Helm)

**Estimated Cost:** ~$5-10/month for dev environment

### Step 3: Configure kubectl

```bash
# Use the output from terraform apply or run:
aws eks update-kubeconfig --region eu-central-1 --name aetush-dev-cluster

# Verify cluster access:
kubectl get nodes
kubectl get pods -n kube-system
```

### Step 4: Verify Load Balancer Controller

```bash
# Check if AWS Load Balancer Controller is running:
kubectl get pods -n kube-system | grep aws-load-balancer-controller
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller -f
```

## 📦 Deploy sre-portal Application

### Step 1: Build and Push Docker Image

```bash
cd app/sre-portal

# Build image
docker build -t sre-portal:v1.0.0 .

# Get login credentials and push to ECR
aws ecr get-login-password --region eu-central-1 | \
  docker login --username AWS --password-stdin 745865830379.dkr.ecr.eu-central-1.amazonaws.com

# Tag image
docker tag sre-portal:v1.0.0 \
  745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:v1.0.0

# Push to ECR
docker push 745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:v1.0.0
```

### Step 2: Deploy via Helm

```bash
# From project root
helm install sre-portal ./k8s/sre-portal \
  -f ./k8s/sre-portal/values-dev.yaml \
  --set image.tag=v1.0.0

# Verify deployment
kubectl get pods
kubectl logs -l app=sre-portal -f
```

### Step 3: Test Application

```bash
# Port forward to access locally
kubectl port-forward svc/sre-portal 3000:3000

# In browser: http://localhost:3000
# Check health: http://localhost:3000/health
# View metrics: http://localhost:3000/metrics
```

## 🔧 Troubleshooting

### Helm Provider Hangs on Waiting for Node
If `terraform apply` hangs waiting for the Helm release to install:
- This typically means the node hasn't fully initialized yet
- You can interrupt (Ctrl+C) and re-run `terraform apply`
- The module will skip already-created resources and retry the Helm release

**Alternative:** Deploy Helm release manually after cluster is ready:
```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=aetush-dev-cluster \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=<LB_CONTROLLER_ROLE_ARN>
```

### Ingress Not Working
1. Verify Load Balancer Controller is running: `kubectl get pods -n kube-system`
2. Check ingress status: `kubectl get ingress`
3. View ingress details: `kubectl describe ingress sre-portal`
4. Check AWS console → EC2 → Load Balancers for the ALB

### Out of Free Tier
If you get AWS service quota or billing warnings:
1. Set `desired_size = 0` in `terraform/environments/dev/terraform.tfvars`
2. Run `terraform apply` to spin down nodes
3. Cluster stays provisioned, just no running nodes
4. Set back to 1 when needed

## 📋 Architecture Summary

```
AWS Region: eu-central-1
├── VPC (10.0.0.0/16)
│   ├── Public Subnet 1 (10.0.0.0/24)
│   ├── Public Subnet 2 (10.0.1.0/24)
│   └── Internet Gateway
├── EKS Cluster (1.31)
│   ├── 1 t3.micro Node (SPOT)
│   ├── AWS Load Balancer Controller (Helm release)
│   └── 1 sre-portal Pod
├── ECR Repository (aetush-dev-cluster-ecr)
└── IAM Roles (Cluster, Nodes, LB Controller)
```

## ✨ What's Automated

✅ Cluster creation and configuration  
✅ VPC and networking setup  
✅ IAM roles and policies  
✅ ECR repository creation  
✅ AWS Load Balancer Controller installation  
✅ Kubernetes configuration  
✅ Multi-environment ready (just copy environments/dev → staging/prod)  

## 📝 Next: GitHub Actions CI/CD

Once everything is working, create `.github/workflows/deploy.yml` to automate:
- Building Docker images on git push
- Pushing to ECR
- Deploying via Helm to EKS
- Running tests and validations
