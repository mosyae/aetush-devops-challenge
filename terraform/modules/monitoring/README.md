# Monitoring Module

This module deploys the PLG (Prometheus, Loki, Grafana) stack using Helm charts.

## Components

- **kube-prometheus-stack**: Includes Prometheus, Alertmanager, and Grafana.
- **loki-stack**: Includes Loki (log aggregation) and Promtail (log collector).

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"
}
```
