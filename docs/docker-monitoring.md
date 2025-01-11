# Docker Container Monitoring

## Basic Monitoring

1. Check container status:
```bash
docker-compose -f docker-compose.prod.yml ps
```

2. View container logs:
```bash
docker-compose -f docker-compose.prod.yml logs -f
```

3. Monitor resource usage:
```bash
docker stats driftdetect
```

## Health Checks

The container includes a health check that verifies DriftDetect functionality:
- Interval: 30 seconds
- Timeout: 3 seconds
- Test: Runs `driftdetect list repos`

## Prometheus Metrics

To enable Prometheus metrics, add the following to docker-compose.prod.yml:

```yaml
services:
  driftdetect:
    labels:
      - "prometheus.enable=true"
    ports:
      - "9090:9090"
```

## Logging Configuration

The container is configured to use JSON logging format for better integration with log aggregation systems. 