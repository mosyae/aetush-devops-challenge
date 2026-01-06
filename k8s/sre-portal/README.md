# SRE Portal Helm Chart

Helm chart for deploying the SRE Portal application to Kubernetes.

## Installation

### Dev Environment
```bash
helm install sre-portal ./k8s/sre-portal \
	-f ./k8s/sre-portal/values-dev.yaml \
	--set image.repository=123456789012.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr
```

### Production Environment
```bash
helm install sre-portal ./k8s/sre-portal \
	--set image.repository=123456789012.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr
```

## Upgrade
```bash
helm upgrade sre-portal ./k8s/sre-portal \
	-f ./k8s/sre-portal/values-dev.yaml \
	--set image.repository=123456789012.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr
```

## Uninstall
```bash
helm uninstall sre-portal
```

## Configuration

Key values you can override:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `2` |
| `image.repository` | Container image repository | (required) |
| `image.tag` | Container image tag | `latest` |
| `service.port` | Service port | `80` |
| `ingress.enabled` | Enable ingress | `true` |
| `autoscaling.enabled` | Enable HPA | `true` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |

## Prerequisites

- Kubernetes 1.30+
- Helm 3+
- AWS Load Balancer Controller (for ingress)
