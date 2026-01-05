# SRE Portal Application

A Python Flask web application demonstrating DevOps/SRE best practices, including built-in instrumentation for metrics, logs, and chaos testing.

## 🚀 Features

- **Web Dashboard**: Real-time pod info and system uptime (Tailwind CSS).
- **Observability**:
  - **Metrics**: Exposes `/metrics` for Prometheus scraping.
  - **Logs**: Structured JSON logging for easy parsing by Loki/Promtail.
- **Chaos Testing**: Simulates errors to test alerting pipelines.
- **Kubernetes Ready**: Health/Readiness probes and graceful shutdown.
- **Security**: Runs as non-root user.

## 🛠️ Instrumentation Details

### Metrics (`/metrics`)
Uses `prometheus-flask-exporter` to expose:
- `flask_http_request_duration_seconds`: Latency distribution.
- `flask_http_request_total`: Total request count by status/method.
- `flask_http_request_exceptions_total`: Exception counts.

### Logging
Configured to output logs to `stdout` (standard output), which are collected by Promtail and sent to Loki.

### Chaos Endpoint (`/action`)
A special endpoint to simulate application failures for testing alerts.
- **Behavior**: 20% chance of returning HTTP 500 (Internal Server Error).
- **Usage**: Click the "Action" button on the dashboard multiple times to generate error spikes.

## 🏃 Local Development

### Prerequisites
- Python 3.12+
- pip

### Run locally
```bash
cd app/sre-portal
pip install -r requirements.txt
python app.py
```
Visit http://localhost:3000

## 🐳 Docker Build & Run

### Build image
```bash
docker build -t sre-portal:latest .
```

### Run container
```bash
docker run -p 3000:3000 sre-portal:latest
```

## ☸️ Kubernetes Deployment

Deployed via Helm. See `k8s/sre-portal/README.md` for details.

## 🔌 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Dashboard UI |
| `/api/info` | GET | Pod and system information (JSON) |
| `/health` | GET | Liveness probe endpoint |
| `/readiness` | GET | Readiness probe endpoint |
| `/action` | POST | **Chaos Endpoint**: Simulates 500 errors (20% probability) |
| `/metrics` | GET | Prometheus metrics |

## ⚙️ Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` | Application port |
| `HOSTNAME` | (auto) | Pod name in Kubernetes |

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
