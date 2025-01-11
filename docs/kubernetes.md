# Kubernetes Deployment Guide

## Prerequisites

- Kubernetes cluster (1.19+)
- kubectl configured
- Helm (optional)

## Installation

1. Create namespace:
```bash
kubectl create namespace driftdetect
```

2. Apply configurations:
```bash
kubectl apply -k k8s/
```

## Configuration

The DriftDetect Kubernetes deployment includes:
- Deployment with security context
- Persistent storage for configuration
- ConfigMap for DriftDetect settings
- NetworkPolicy for security
- Service for access

### Security Features

- Non-root user execution
- Read-only root filesystem
- Dropped capabilities
- Network policy restrictions
- Resource limits

### Monitoring

1. Install Prometheus Operator:
```bash
helm install prometheus prometheus-community/kube-prometheus-stack
```

2. Apply ServiceMonitor:
```bash
kubectl apply -f k8s/servicemonitor.yaml
```

### Scaling

The deployment can be scaled horizontally:
```bash
kubectl scale deployment driftdetect --replicas=3
```

## Maintenance

1. Update image:
```bash
kubectl set image deployment/driftdetect driftdetect=driftdetect:new-version
```

2. View logs:
```bash
kubectl logs -l app=driftdetect
```

3. Check status:
```bash
kubectl get pods -l app=driftdetect
``` 