# Build stage
FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make

WORKDIR /app
COPY . .

# Build with security flags
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o driftdetect

# Runtime stage
FROM alpine:latest AS runtime

# Add non-root user
RUN adduser -D driftdetect && \
    mkdir -p /home/driftdetect/.driftdetect && \
    chown -R driftdetect:driftdetect /home/driftdetect

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata

# Copy binary from builder
COPY --from=builder /app/driftdetect /usr/local/bin/
COPY --from=builder /app/example-ttps /home/driftdetect/example-ttps/

# Set working directory
WORKDIR /home/driftdetect

# Use non-root user
USER driftdetect

# Set environment variables
ENV HOME=/home/driftdetect \
    PATH="/usr/local/bin:${PATH}"

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD driftdetect list repos >/dev/null || exit 1

ENTRYPOINT ["driftdetect"]
