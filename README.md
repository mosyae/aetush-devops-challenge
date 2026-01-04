# DevOps/SRE Technical Challenge

This repository contains a complete DevOps/SRE solution demonstrating practical skills in application deployment, containerization, CI/CD, cloud infrastructure, and monitoring.

## 🎯 Project Overview

This project fulfills the following requirements:
- ✅ Interactive web application (Choose: .NET, Python, or Node.js)
- ✅ Containerized deployment on Kubernetes
- ✅ CI/CD pipelines for automated build and deployment
- ✅ Cloud hosting on AWS
- ✅ Comprehensive monitoring with logs, metrics, and dashboards

## 📁 Repository Structure

```
.
├── app/                    # Application source code
│   ├── src/               # Application code
│   ├── Dockerfile         # Container image definition
│   ├── package.json       # Dependencies (Node.js)
│   └── tests/             # Application tests
│
├── k8s/                   # Kubernetes manifests
│   ├── deployment.yaml    # Application deployment
│   ├── service.yaml       # Service definition
│   ├── ingress.yaml       # Ingress configuration
│   ├── hpa.yaml           # Horizontal Pod Autoscaler
│   └── configmap.yaml     # Configuration management
│
├── terraform/             # Infrastructure as Code
│   ├── bootstrap/         # Initial AWS setup
│   │   └── main.tf       # S3 state bucket & OIDC provider
│   └── environments/      # Environment-specific configs
│       └── dev/          # Development environment
│           ├── main.tf
│           ├── eks.tf
│           ├── networking.tf
│           └── monitoring.tf
│
├── .github/              # CI/CD pipelines
│   └── workflows/
│       ├── build.yml     # Build and test
│       ├── deploy.yml    # Deploy to K8s
│       └── terraform.yml # Infrastructure deployment
│
└── docs/                 # Additional documentation
    ├── architecture.md
    └── deployment.md
```

## 🚀 Quick Start

### Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured (`aws configure`)
- Terraform >= 1.0
- kubectl configured
- Docker installed
- Node.js/Python/.NET SDK (depending on chosen stack)

### 1. Bootstrap Infrastructure

First, set up the Terraform state bucket and GitHub OIDC provider:

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

The output will show the state bucket name. Copy it for the next step:
```
Outputs:

state_bucket_name = "aetush-infra-state-37a4e43e"
```

### 2. Deploy Infrastructure

Deploy the EKS cluster and supporting infrastructure:

```bash
cd terraform/environments/dev
terraform init \
  -backend-config="bucket=aetush-infra-state-37a4e43e" \
  -backend-config="key=dev/terraform.tfstate" \
  -backend-config="region=eu-central-1"

terraform apply
```

### 3. Configure kubectl

Connect to the EKS cluster:

```bash
aws eks update-kubeconfig --region eu-central-1 --name aetush-dev-cluster
```

### 4. Build and Run Locally

```bash
cd app

# Build Docker image
docker build -t app:local .

# Run locally
docker run -p 3000:3000 app:local
```

Visit http://localhost:3000

### 5. Deploy to Kubernetes

```bash
kubectl apply -f k8s/
```

## 🔄 CI/CD Pipeline

The project uses GitHub Actions for automated deployments:

### Build Pipeline (`build.yml`)
- Triggered on: Push to `main`, Pull Requests
- Steps:
  1. Code checkout
  2. Run tests
  3. Build Docker image
  4. Push to container registry
  5. Security scanning

### Deploy Pipeline (`deploy.yml`)
- Triggered on: Successful build on `main` branch
- Steps:
  1. Authenticate to AWS (using OIDC)
  2. Update kubectl context
  3. Apply Kubernetes manifests
  4. Verify deployment health

### Infrastructure Pipeline (`terraform.yml`)
- Triggered on: Changes to `terraform/**`
- Steps:
  1. Terraform plan (on PR)
  2. Terraform apply (on merge to main)

## ☁️ AWS Architecture

### Components

- **EKS Cluster**: Managed Kubernetes service
- **VPC**: Isolated network with public/private subnets
- **ALB**: Application Load Balancer for ingress
- **ECR**: Container image registry
- **CloudWatch**: Logs and metrics
- **S3**: Terraform state storage
- **IAM Roles**: OIDC-based GitHub Actions authentication

### Network Design

- VPC CIDR: 10.0.0.0/16
- Public Subnets: 10.0.1.0/24, 10.0.2.0/24 (2 AZs)
- Private Subnets: 10.0.10.0/24, 10.0.11.0/24 (2 AZs)
- NAT Gateways: High availability setup

## 📊 Monitoring and Observability

### Logs
- **Application Logs**: Sent to CloudWatch Logs
- **Kubernetes Logs**: Collected via Fluent Bit
- **Access Logs**: ALB logs to S3

### Metrics
- **Application Metrics**: Prometheus format (via `/metrics` endpoint)
- **Infrastructure Metrics**: CloudWatch Container Insights
- **Custom Metrics**: Business KPIs

### Dashboards
- CloudWatch Dashboard: Infrastructure overview
- Application Dashboard: Request rate, latency, errors
- Cost Dashboard: Resource utilization

### Alerts
- High error rate (>5% for 5 minutes)
- High latency (p99 > 1s)
- Pod restarts (>3 in 10 minutes)
- CPU/Memory thresholds

## 🔧 Application Details

### Technology Stack
- **Language**: [Node.js/Python/.NET]
- **Framework**: [Express/Flask/ASP.NET Core]
- **Database**: [Optional - PostgreSQL/DynamoDB]

### Features
- Interactive user interface
- Health check endpoint: `/health`
- Metrics endpoint: `/metrics`
- Graceful shutdown handling
- Request logging and tracing

### API Endpoints

```
GET  /              - Home page
GET  /health        - Health check
GET  /metrics       - Prometheus metrics
POST /api/...       - Application endpoints
```

## 🧪 Testing

```bash
# Unit tests
npm test

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e

# Load testing
npm run test:load
```

## 🔒 Security Considerations

- **OIDC Authentication**: No long-lived AWS credentials
- **Network Policies**: Pod-to-pod communication restrictions
- **Secret Management**: AWS Secrets Manager / Kubernetes Secrets
- **Image Scanning**: Automated vulnerability scanning
- **RBAC**: Least privilege access control
- **TLS/SSL**: HTTPS-only communication

## 📈 Scalability

- **Horizontal Pod Autoscaling**: CPU/Memory-based scaling
- **Cluster Autoscaling**: Automatic node provisioning
- **Load Balancing**: Multi-AZ distribution
- **Caching**: [Optional - Redis/ElastiCache]

## 💰 Cost Optimization

- Spot instances for non-critical workloads
- Right-sized instance types
- Auto-scaling to match demand
- S3 lifecycle policies
- CloudWatch log retention policies

## 🚧 Future Enhancements

- [ ] Multi-region deployment
- [ ] Blue-green deployments
- [ ] Canary releases
- [ ] Service mesh (Istio/Linkerd)
- [ ] GitOps with ArgoCD/Flux
- [ ] Advanced observability (Jaeger, Grafana)
- [ ] Database migration automation

## 📝 Documentation

- [Architecture Diagram](docs/architecture.md)
- [Deployment Guide](docs/deployment.md)
- [Troubleshooting Guide](docs/troubleshooting.md)
- [API Documentation](docs/api.md)

## 🤝 Contributing

1. Create a feature branch
2. Make changes and add tests
3. Submit a Pull Request
4. CI pipeline must pass
5. Code review required

## 📄 License

MIT License

## 👤 Author

**Aetush**

---

**Note**: This is a technical assessment project demonstrating DevOps/SRE capabilities including containerization, Kubernetes orchestration, infrastructure as code, CI/CD automation, and cloud-native monitoring practices.
