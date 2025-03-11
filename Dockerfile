# Build stage
FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make

WORKDIR /app

# Initialize a new module (if go.mod doesn't exist)
RUN go mod init driftdetect || true

# Add required dependencies
RUN go get github.com/facebookincubator/ttpforge/pkg/fileutils && \
    go get github.com/facebookincubator/ttpforge/pkg/logging

# Copy the source code
COPY . .

# Download all dependencies
RUN go mod tidy && go mod download

# Build with security flags and ignore VCS info
RUN CGO_ENABLED=0 GOOS=linux go build -buildvcs=false -gcflags=all=-l -a -installsuffix cgo -ldflags="-w -s" -o driftdetect

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
