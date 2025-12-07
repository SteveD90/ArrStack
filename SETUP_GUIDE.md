# Repository Setup and Docker Hub Deployment Checklist

This guide walks you through merging your working TrueNAS setup into the repo and preparing for Docker Hub deployment.

## Phase 1: Merge Working Configuration ✅ COMPLETED

- [x] Created `.env.example` with all required variables
- [x] Updated `docker-compose.yaml` to use environment variables
- [x] Updated `create_dirs.sh` to create all necessary directories
- [x] Enhanced README.md with comprehensive documentation
- [x] Updated `.gitignore` to exclude sensitive files
- [x] Updated `.dockerignore` for efficient builds

## Phase 2: Prepare Your Working Environment

### 1. Copy Your Working .env File

Since your TrueNAS setup is working, you likely have a `.env` file:

```bash
# If you have your working .env from TrueNAS
cp /path/to/working/.env ./c:\MyDockerApps\ArrStack-main/.env

# Or create from template and fill in your values
cp .env.example .env
nano .env
```

**Important values to update:**
- `PUID` and `PGID` (from your TrueNAS user)
- `MEDIA_PATH` (your media directory path)
- `CONFIG_BASE` and `DOWNLOADS_BASE`
- `SAB_APIKEY` (from your working SABnzbd)
- `BASE_URL` (your external access URL)

### 2. Copy Custom Format Files

If you have custom formats from your working setup:

```bash
# Copy custom format files to repo
cp /path/to/radarr-custom-formats.md ./radarr-custom-formats.md
cp /path/to/sonarr-custom-formats.md ./sonarr-custom-formats.md
```

### 3. Copy Database Files (Optional)

To preserve your current configuration:

```bash
# Radarr
cp /mnt/config/radarr/radarr.db ./backup/radarr.db

# Sonarr
cp /mnt/config/sonarr/sonarr.db ./backup/sonarr.db

# Store these safely - don't commit to git!
```

## Phase 3: Test the Stack Locally

### 1. Verify Configuration

```bash
cd c:\MyDockerApps\ArrStack-main

# Check .env file exists and is properly configured
cat .env

# Verify docker-compose syntax
docker compose config
```

### 2. Create Directories

```bash
# Make script executable
chmod +x create_dirs.sh

# Run directory creation (may need sudo)
sudo ./create_dirs.sh

# Verify directories were created
ls -la /srv/config
ls -la /srv/downloads
```

### 3. Start Stack

```bash
# Pull latest images
docker compose pull

# Start in foreground to watch for errors
docker compose up

# If all looks good, start in background
docker compose down
docker compose up -d
```

### 4. Verify Services

Check each service is accessible:
- Radarr: http://localhost:7878
- Sonarr: http://localhost:8989
- Prowlarr: http://localhost:9696
- Profilarr: http://localhost:6868
- Bazarr: http://localhost:6767
- SABnzbd: http://localhost:8080

### 5. Test Integration

1. Configure Prowlarr indexers
2. Test download in SABnzbd
3. Verify Radarr/Sonarr can see downloads
4. Check file permissions in media directories

## Phase 4: Git Repository Setup

### 1. Initialize/Update Repository

```bash
cd c:\MyDockerApps\ArrStack-main

# Initialize if needed
git init

# Add remote (use your repo URL)
git remote add origin https://github.com/yourusername/ArrStack.git

# Or update existing remote
git remote set-url origin https://github.com/yourusername/ArrStack.git
```

### 2. Verify Gitignore

```bash
# Ensure .env is NOT staged
git status

# Should NOT see .env in the list
# If you do, add it to .gitignore
echo ".env" >> .gitignore
```

### 3. Commit and Push

```bash
# Stage all changes
git add .

# Commit
git commit -m "Merge working TrueNAS configuration into repo"

# Push to GitHub
git push -u origin main
```

## Phase 5: Docker Hub Setup

### 1. Create Docker Hub Account

- Visit https://hub.docker.com
- Sign up or log in
- Note your username for image naming

### 2. Create Access Token

1. Go to Account Settings > Security
2. Click "New Access Token"
3. Name it "GitHub Actions" or similar
4. Copy the token (you won't see it again!)

### 3. Configure GitHub Secrets

In your GitHub repository:

1. Go to Settings > Secrets and variables > Actions
2. Add these secrets:
   - `DOCKERHUB_USERNAME` = your Docker Hub username
   - `DOCKERHUB_TOKEN` = the access token from step 2

### 4. Create Docker Hub Repository

1. Go to Docker Hub
2. Click "Create Repository"
3. Name it "arrstack" (or your preferred name)
4. Set visibility (public or private)
5. Create repository

## Phase 6: Build and Push Images

### Option A: Manual Build (For Testing)

```bash
# Login to Docker Hub
docker login

# Build image
docker build -t yourusername/arrstack:latest -f Dockerfile.example .

# Test locally
docker run -p 3000:3000 yourusername/arrstack:latest

# Push to Docker Hub
docker push yourusername/arrstack:latest
```

### Option B: Automated via GitHub Actions

1. Push code to GitHub (triggers workflow)
2. Watch Actions tab for build progress
3. Verify image appears on Docker Hub

### Option C: Tag a Release

```bash
# Create and push a version tag
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0

# GitHub Actions will build and push with version tag
```

## Phase 7: Deploy from Docker Hub

### Update docker-compose.yaml

Update image references to use your Docker Hub images:

```yaml
services:
  custom-service:
    image: yourusername/arrstack:latest
    # ... rest of config
```

### Deploy on New Server

```bash
# Clone repository
git clone https://github.com/yourusername/ArrStack.git
cd ArrStack

# Configure environment
cp .env.example .env
nano .env

# Create directories
chmod +x create_dirs.sh
sudo ./create_dirs.sh

# Deploy from Docker Hub
docker compose pull
docker compose up -d
```

## Phase 8: Maintenance

### Regular Updates

```bash
# Pull latest images
docker compose pull

# Restart with updates
docker compose up -d

# Clean up old images
docker image prune -a
```

### Backup Configuration

```bash
# Run backup script
chmod +x backup_configs.sh
./backup_configs.sh

# Backup is created in ./backups/ directory
```

### Monitor Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f radarr
```

## Troubleshooting

### Permission Issues

```bash
# Check ownership
ls -ln /srv/config

# Fix ownership
sudo chown -R 1000:1000 /srv/config
sudo chown -R 1000:1000 /srv/downloads
```

### Port Conflicts

```bash
# Check what's using a port
netstat -tulpn | grep 7878

# Update port in .env
nano .env
# Change RADARR_PORT=7878 to different port

# Restart
docker compose up -d
```

### Container Won't Start

```bash
# Check logs
docker compose logs servicename

# Check configuration
docker compose config

# Recreate container
docker compose up -d --force-recreate servicename
```

## Next Steps

1. **Add monitoring**: Consider Prometheus/Grafana
2. **Set up reverse proxy**: Traefik or Nginx with SSL
3. **Automate backups**: Rsync to NAS or cloud storage
4. **Add Watchtower**: Automatic container updates
5. **Document custom workflows**: Add to repo documentation

## Support Resources

- [Docker Compose Docs](https://docs.docker.com/compose/)
- [LinuxServer.io Images](https://docs.linuxserver.io/)
- [TrueNAS Forums](https://forums.truenas.com/)
- [Servarr Wiki](https://wiki.servarr.com/)

## Summary

You now have:
- ✅ A working configuration merged into the repo
- ✅ Proper .env.example template
- ✅ Documentation for deployment
- ✅ Docker Hub publishing setup
- ✅ GitHub Actions CI/CD pipeline
- ✅ Security best practices in place

Your repo is ready to be shared and deployed anywhere!
