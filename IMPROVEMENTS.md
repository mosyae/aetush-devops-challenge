# Future Improvements Roadmap

This document outlines potential enhancements for the SRE Portal project, focusing on security, observability, application features, and infrastructure robustness.

## 🛡️ Security Enhancements

### Network & Access Control
- **Implement Network Policies**: Restrict traffic between pods to only what is necessary (e.g., prevent SRE Portal from accessing other services unless explicitly allowed).
- **Private EKS Endpoint**: Restrict the Kubernetes API server endpoint to be private-only or accessible only from specific VPN IPs.
- **WAF Integration**: Attach AWS WAF to the Application Load Balancer to protect against common web exploits (SQL injection, XSS).

### Application Security
- **Authentication/Authorization**: Add a login layer (e.g., OIDC with GitHub/Google or Keycloak) to the SRE Portal. Currently, the "Chaos" buttons are public.
- **Container Scanning**: Integrate Trivy or Clair in the CI/CD pipeline to scan Docker images for vulnerabilities before deployment.
- **Secrets Management**: Replace environment variable secrets with External Secrets Operator (fetching from AWS Secrets Manager or HashiCorp Vault).

### Role-Based Access Control (RBAC)
- **Granular IAM Roles**: Further restrict IRSA (IAM Roles for Service Accounts) policies to least privilege.
- **K8s RBAC**: Create specific `ServiceAccount` and `Role` definitions for users viewing the dashboard vs. admin users.

## 👁️ Observability & Monitoring

### Advanced Dashboarding
- **SLO/SLI Error Budget Panels**: Visualize error budgets burning down in real-time.
- **Business Metrics**: Track custom application logic (e.g., "Number of Chaos Experiments Run").
- **Infrastructure Dashboards**: detailed node-level metrics (Disk I/O, Network bandwidth).

### Alerting
- **Alertmanager Integration**: configure critical alerts (e.g., "High Error Rate > 5%", "Pod CrashLooping") to be sent to Slack, PagerDuty, or Email.
- **Synthetic Monitoring**: Implement black-box probes to check the health of the /status endpoint from outside the cluster.

### Tracing
- **Distributed Tracing**: Implement OpenTelemetry or Jaeger to trace requests as they travel from the ingress, through the app, to databases/downstream services.

## 🚀 Application Features

### SRE Portal Enhancements
- **Latency Injection**: Add a button to simulate high latency (e.g., `time.sleep(2)`) to test timeout configurations and P99 monitoring.
- **Memory Leak Simulation**: Add a route that steadily consumes memory to test HPA (Horizontal Pod Autoscaler) and OOMKilled alerts.
- **Feature Flags**: Toggle features on/off dynamically without redeploying.
- **Database Connectivity**: Connect to a stateful backend (Postgres/Redis) to demonstrate monitoring of database connections and query performance.

## 🏗️ Infrastructure & DevOps

### CI/CD Improvements
- **GitOps (ArgoCD/Flux)**: Move from reducing "Terraform apply" to a GitOps model for Kubernetes manifests, ensuring synchronization between Git and the Cluster.
- **Pre-commit Hooks**: Enforce linting (tfsec, pylint) and formatting before code is committed.
- **Canary Deployments**: Use Flagger or Argo Rollouts to implement progressive delivery.

### Cost Optimization
- [x] **Spot Instances**: Use AWS Spot instances to reduce compute costs (Current setup uses `capacity_type = "SPOT"`).
- **Karpenter**: Replace Cluster Autoscaler with [Karpenter](https://karpenter.sh/) for faster, smarter node scaling (e.g., picking the cheapest instance type dynamically).
- **Cost Allocation Tags**: Enforce tagging strategies in Terraform for granular AWS cost tracking.
