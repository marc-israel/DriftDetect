# Docker Security Guidelines

## Production Container Security Features

- Multi-stage build to minimize attack surface
- Non-root user execution
- Read-only root filesystem
- Resource limits and constraints
- Security options (no new privileges)
- Minimal base image (Alpine)
- Regular security scanning

## Security Best Practices

1. Always use the production Docker configuration in production environments:
```bash
docker-compose -f docker-compose.prod.yml up
```

2. Regularly scan the container for vulnerabilities:
```bash
make docker-scan
```

3. Keep the base images updated:
```bash
docker-compose -f docker-compose.prod.yml pull
```

4. Monitor container resource usage:
```bash
docker stats driftdetect
```

## Volume Management

The production configuration uses a named volume for persistent configuration:
- Location: `driftdetect-config`
- Purpose: Store DriftDetect configuration and repositories
- Backup: Use `docker volume backup` for data persistence

## Security Considerations

1. The container runs as non-root user `driftdetect`
2. Filesystem is read-only except for specific mount points
3. Container has no additional privileges
4. Resource limits prevent DoS scenarios
5. Regular security scanning is implemented 