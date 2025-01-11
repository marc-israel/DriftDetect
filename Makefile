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