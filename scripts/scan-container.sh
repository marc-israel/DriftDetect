#!/bin/bash
set -euo pipefail

# Build the image first
docker-compose -f docker-compose.prod.yml build

# Get the image ID
IMAGE_ID=$(docker-compose -f docker-compose.prod.yml images -q driftdetect)

# Run Trivy scanner
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.cache:/root/.cache \
    aquasec/trivy image \
    --severity HIGH,CRITICAL \
    --exit-code 1 \
    "$IMAGE_ID"

# Run Docker Bench Security
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker/docker-bench-security 