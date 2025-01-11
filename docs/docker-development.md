# Docker Development Guide

## Debugging with Delve

1. Start the debug container: 

```bash
make docker-debug
```


2. Connect using your IDE:
- VS Code: Use the Go debugger with remote configuration
- GoLand: Use "Go Remote" configuration with port 2345

## Development Best Practices

1. Use multi-stage builds to keep images small
2. Leverage BuildKit cache:

```bash
DOCKER_BUILDKIT=1 docker-compose build
```


3. Use volume mounts for faster development:

```yaml
volumes:
  - .:/app:cached
```

4. Enable BuildKit inline cache:
dockerfile
syntax=docker/dockerfile:1.4
RUN --mount=type=cache,target=/go/pkg/mod ...

## Container Optimization

1. Analyze image layers:

```bash
docker history driftdetect:latest
```

2. Optimize with docker-slim:

```bash
make docker-slim
```

3. Use multi-arch builds:

```bash
docker buildx build --platform linux/amd64,linux/arm64 .
```

4. Add a Docker CI/CD pipeline configuration (update existing workflow referenced in lines 1-24 of .github/workflows/docker.yml):

```yaml
name: Set up QEMU
uses: docker/setup-qemu-action@v3
name: Set up Docker Buildx
uses: docker/setup-buildx-action@v3
name: Build and push multi-arch images
uses: docker/build-push-action@v5
with:
platforms: linux/amd64,linux/arm64
push: false
cache-from: type=gha
cache-to: type=gha,mode=max
