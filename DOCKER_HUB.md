# Docker Hub Deployment Guide

This guide explains how to build, publish, and deploy the ArrStack as Docker images on Docker Hub.

## Overview

The ArrStack primarily uses pre-built images from LinuxServer.io and other registries. However, if you have custom components (like `sab-stream-proxy`) or want to create a bundled deployment, you can build and publish your own images.

## Prerequisites

1. **Docker Hub Account**
   - Create a free account at [hub.docker.com](https://hub.docker.com)
   - Note your username for image naming

2. **Docker Installed**
   - Ensure Docker is installed and running
   - Verify: `docker --version`

3. **Repository Access**
   - Fork or clone this repository
   - Make any custom modifications needed

## Building Custom Images

### Option 1: Individual Service Customization

If you've modified individual services, build them separately:

```bash
# Example: Build a custom SABnzbd configuration
cd custom-services/sabnzbd
docker build -t yourusername/arrstack-sabnzbd:latest .
docker push yourusername/arrstack-sabnzbd:latest
```

### Option 2: Custom Sab-Stream-Proxy

If you're using the sab-stream-proxy service:

```bash
# Create the Dockerfile for sab-stream-proxy
cd sab-stream-proxy
docker build -t yourusername/sab-stream-proxy:latest .
docker push yourusername/sab-stream-proxy:latest
```

Update your `docker-compose.yaml`:
```yaml
sab-stream-proxy:
  image: yourusername/sab-stream-proxy:latest
  # ... rest of configuration
```

### Option 3: Complete Stack Image (Advanced)

For a complete bundled stack:

```bash
# Build the complete stack
docker build -t yourusername/arrstack:latest -f Dockerfile.stack .

# Tag with version
docker tag yourusername/arrstack:latest yourusername/arrstack:v1.0.0

# Push both tags
docker push yourusername/arrstack:latest
docker push yourusername/arrstack:v1.0.0
```

## Publishing to Docker Hub

### 1. Login to Docker Hub

```bash
docker login
# Enter your Docker Hub username and password
```

### 2. Tag Your Images

Use consistent naming:
```bash
docker tag local-image:latest yourusername/arrstack:latest
docker tag local-image:latest yourusername/arrstack:v1.0.0
```

### 3. Push to Docker Hub

```bash
# Push latest tag
docker push yourusername/arrstack:latest

# Push version tag
docker push yourusername/arrstack:v1.0.0
```

### 4. Verify Upload

- Visit `https://hub.docker.com/r/yourusername/arrstack`
- Confirm images are visible and correctly tagged

## Using Your Docker Hub Images

### Update .env File

Update image references in your `.env`:

```bash
# Custom images
RADARR_IMAGE=yourusername/arrstack-radarr:latest
SONARR_IMAGE=yourusername/arrstack-sonarr:latest
SAB_STREAM_PROXY_IMAGE=yourusername/sab-stream-proxy:latest
```

### Update docker-compose.yaml

If you created a custom image, update the compose file:

```yaml
services:
  sab-stream-proxy:
    image: ${SAB_STREAM_PROXY_IMAGE:-yourusername/sab-stream-proxy:latest}
    # ... rest of configuration
```

### Deploy from Docker Hub

```bash
# Pull latest images
docker compose pull

# Start the stack
docker compose up -d
```

## Automated Builds with GitHub Actions

For automated CI/CD, create `.github/workflows/docker-publish.yml`:

```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
    tags: [ 'v*.*.*' ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: docker.io
  IMAGE_NAME: ${{ secrets.DOCKERHUB_USERNAME }}/arrstack

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v4
        with:
          images: ${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```

### Setup GitHub Secrets

In your GitHub repository settings, add:
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Access token from Docker Hub (Account Settings > Security)

## Version Management

### Semantic Versioning

Use semantic versioning for releases:
- `v1.0.0` - Major release
- `v1.1.0` - Minor update (new features)
- `v1.1.1` - Patch (bug fixes)

### Creating Releases

```bash
# Tag a release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# Build and push with version tag
docker build -t yourusername/arrstack:v1.0.0 .
docker push yourusername/arrstack:v1.0.0
```

## Multi-Architecture Builds

To support different architectures (amd64, arm64):

```bash
# Create a builder
docker buildx create --name multiarch --use

# Build and push for multiple platforms
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t yourusername/arrstack:latest \
  --push .
```

## Image Size Optimization

### Best Practices

1. **Use multi-stage builds**
   ```dockerfile
   FROM node:18-alpine AS builder
   # Build steps
   
   FROM node:18-alpine
   COPY --from=builder /app /app
   ```

2. **Minimize layers**
   ```dockerfile
   RUN apt-get update && \
       apt-get install -y package1 package2 && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/*
   ```

3. **Use .dockerignore**
   ```
   .git
   .env
   node_modules
   *.md
   ```

## Pulling and Using Images

### For End Users

```bash
# Pull the latest image
docker pull yourusername/arrstack:latest

# Pull a specific version
docker pull yourusername/arrstack:v1.0.0

# Run with docker-compose
docker compose pull
docker compose up -d
```

### Update Strategy

```bash
# Pull new images
docker compose pull

# Restart with new images
docker compose up -d

# Remove old images
docker image prune -a
```

## Security Considerations

1. **Never commit secrets** to Docker images
2. **Use environment variables** for configuration
3. **Scan images** for vulnerabilities:
   ```bash
   docker scan yourusername/arrstack:latest
   ```
4. **Use specific version tags** in production, not `latest`
5. **Enable Docker Content Trust**:
   ```bash
   export DOCKER_CONTENT_TRUST=1
   ```

## Troubleshooting

### Build Failures

```bash
# Clear build cache
docker builder prune -a

# Build with no cache
docker build --no-cache -t yourusername/arrstack:latest .
```

### Push Failures

```bash
# Re-login to Docker Hub
docker logout
docker login

# Check authentication
docker info | grep Username
```

### Image Not Found

```bash
# Verify image exists locally
docker images | grep arrstack

# Verify on Docker Hub
docker pull yourusername/arrstack:latest
```

## Resources

- [Docker Hub Documentation](https://docs.docker.com/docker-hub/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [GitHub Actions for Docker](https://docs.github.com/en/actions/publishing-packages/publishing-docker-images)

## Support

For issues with:
- Image builds: Check the Dockerfile and build logs
- Registry issues: Verify Docker Hub credentials
- Deployment issues: Check docker-compose.yaml and .env configuration
