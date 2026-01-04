# SRE Portal Application

A Python Flask web application demonstrating DevOps/SRE best practices with Kubernetes deployment.

## Features

- 🌐 Professional web dashboard with Tailwind CSS
- 📊 Real-time pod information and system uptime
- ✅ Health and readiness endpoints for Kubernetes probes
- 📈 Prometheus metrics endpoint
- 🐳 Multi-stage Docker build for optimized images
- 🔒 Non-root container user for security
- ♻️ Auto-refreshing dashboard

## Local Development

### Prerequisites
- Python 3.12+
- pip

### Run locally
```bash
cd app
pip install -r requirements.txt
python app.py
```

Visit http://localhost:3000

## Docker Build & Run

### Build image
```bash
cd app
docker build -t sre-portal:latest .
```

### Run container
```bash
docker run -p 3000:3000 sre-portal:latest
```

## Push to ECR

```bash
# Login to ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 745865830379.dkr.ecr.eu-central-1.amazonaws.com

# Tag image
docker tag sre-portal:latest 745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:latest

# Push to ECR
docker push 745865830379.dkr.ecr.eu-central-1.amazonaws.com/aetush-dev-cluster-ecr:latest
```

## Deploy to Kubernetes

### Using Helm
```bash
# Dev environment
helm install sre-portal ./k8s/sre-portal -f ./k8s/sre-portal/values-dev.yaml

# Production environment
helm install sre-portal ./k8s/sre-portal
```

### Upgrade deployment
```bash
helm upgrade sre-portal ./k8s/sre-portal -f ./k8s/sre-portal/values-dev.yaml
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Dashboard UI |
| `/api/info` | GET | Pod and system information (JSON) |
| `/health` | GET | Liveness probe endpoint |
| `/readiness` | GET | Readiness probe endpoint |
| `/action` | POST | Test action endpoint |
| `/metrics` | GET | Prometheus metrics |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` | Application port |
| `HOSTNAME` | (auto) | Pod name in Kubernetes |

## CI/CD Integration

The application is designed for automated CI/CD with GitHub Actions:

1. **Build**: Multi-stage Dockerfile creates optimized image
2. **Push**: Image pushed to ECR with version tags
3. **Deploy**: Helm chart updates Kubernetes deployment
4. **Verify**: Health checks ensure successful deployment

See `.github/workflows/` for pipeline configuration.

## Security Features

- ✅ Non-root user (UID 1000)
- ✅ Minimal base image (python:3.11-slim)
- ✅ No sensitive data in image
- ✅ Health checks for container orchestration
- ✅ Multi-stage build reduces attack surface

## Monitoring

- **Liveness Probe**: `/health` - checks if app is alive
- **Readiness Probe**: `/readiness` - checks if app is ready for traffic
- **Metrics**: `/metrics` - Prometheus-compatible metrics

## Architecture

```
app/
├── app.py              # Main Flask application
├── templates/
│   └── index.html      # Dashboard UI (Tailwind CSS)
├── requirements.txt     # Python dependencies
├── Dockerfile          # Multi-stage build
└── .dockerignore       # Build optimization
```
