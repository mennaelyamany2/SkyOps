# Monitoring Stack

This directory contains the monitoring stack configuration for the SkyOps project.

## Components

### Prometheus
Used for collecting Kubernetes and application metrics.

### Grafana
Used for visualizing monitoring metrics with dashboards.

### kube-state-metrics
Provides Kubernetes object metrics for Prometheus.

---

## Structure

monitoring/
├── namespace.yaml
├── prometheus
├── grafana
└── kube-state-metrics

---

## Deployment Order

1. Create namespace
2. Deploy Prometheus
3. Deploy Grafana
4. Deploy kube-state-metrics

---

## Example Commands

```bash
kubectl apply -f namespace.yaml

kubectl apply -f prometheus/
kubectl apply -f grafana/
kubectl apply -f kube-state-metrics/
