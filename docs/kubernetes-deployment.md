# Advanced Kubernetes Deployment Guide

## Helm Installation

1. Add the DriftDetect Helm repository:
```bash
helm repo add driftdetect https://charts.driftdetect.com
helm repo update
```

2. Install DriftDetect:
```bash
helm install driftdetect driftdetect/driftdetect \
  --namespace driftdetect \
  --create-namespace \
  --values custom-values.yaml
```

## Advanced Configuration

### Autoscaling
Enable HPA in values.yaml:
```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
```

### Monitoring
Enable ServiceMonitor:
```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
    interval: 30s
```

### Security
Configure PodSecurityPolicy:
```yaml
podSecurityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000
```

## Production Best Practices

1. Resource Management
   - Set appropriate resource requests/limits
   - Enable autoscaling
   - Monitor resource usage

2. Security
   - Enable NetworkPolicies
   - Use RBAC
   - Configure SecurityContext
   - Regular security scanning

3. High Availability
   - Multiple replicas
   - Pod anti-affinity
   - Node affinity rules
   - PodDisruptionBudget 