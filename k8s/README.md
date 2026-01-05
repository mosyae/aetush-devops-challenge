# Kubernetes Manifests & Helm Charts

This directory contains the Kubernetes configurations for the application and supporting infrastructure.

## 📂 Structure

- **`sre-portal/`**: Helm chart for the SRE Portal application.
- **`storage-class.yaml`**: Defines the `gp3` StorageClass using the AWS EBS CSI Driver.

## 📦 Deployment

### 1. Apply Storage Class
Required for Loki to provision persistent storage on AWS EBS.
```bash
kubectl apply -f storage-class.yaml
```

### 2. Deploy Application (via Helm)
```bash
helm install sre-portal ./sre-portal -f ./sre-portal/values-dev.yaml
```

## ☸️ Helm Chart Details (`sre-portal`)

The application chart manages:
- **Deployment**: Replicas, container image, ports.
- **Service**: ClusterIP service for internal access.
- **Ingress**: ALB configuration for external access.
- **HPA**: Horizontal Pod Autoscaler configuration.
- **ServiceAccount**: IRSA annotation for AWS permissions.
