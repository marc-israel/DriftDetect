.PHONY: docker-prod docker-scan

# Production Docker commands
docker-prod-build:
	docker-compose -f docker-compose.prod.yml build

docker-prod-run:
	docker-compose -f docker-compose.prod.yml run driftdetect

# Security scanning
docker-scan:
	./scripts/scan-container.sh

# Clean production volumes
clean-prod:
	docker-compose -f docker-compose.prod.yml down -v 

# Debugging
docker-debug:
	docker-compose -f docker-compose.debug.yml up

# Advanced security scanning
docker-scan-full:
	docker-compose -f docker-compose.prod.yml build
	trivy filesystem --security-checks vuln,config,secret .
	dockle -d --format json driftdetect:latest
	grype driftdetect:latest

# Container optimization
docker-slim:
	docker-slim build --http-probe=false driftdetect:latest