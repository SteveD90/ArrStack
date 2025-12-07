# Quick Reference - ArrStack

## 🚀 Quick Deploy

```bash
# 1. Clone and setup
git clone <your-repo-url>
cd ArrStack
cp .env.example .env
nano .env  # Edit with your values

# 2. Create directories
chmod +x create_dirs.sh
sudo ./create_dirs.sh

# 3. Deploy
docker compose up -d

# 4. Check status
docker compose ps
docker compose logs -f
```

## 📋 Essential Commands

### Stack Management
```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# Restart a service
docker compose restart radarr

# View logs
docker compose logs -f [service-name]

# Update images and restart
docker compose pull
docker compose up -d
```

### Directory Setup
```bash
# Create directories with correct permissions
sudo ./create_dirs.sh

# Check permissions
ls -ln /srv/config
ls -ln /srv/downloads
```

### Backups
```bash
# Backup configurations
./backup_configs.sh

# Restore (example)
tar -xzf backups/backup-YYYYMMDD-HHMMSS.tar.gz -C /
```

## 🌐 Service URLs (Default Ports)

| Service | URL | Default Port |
|---------|-----|--------------|
| Radarr | http://localhost:7878 | 7878 |
| Sonarr | http://localhost:8989 | 8989 |
| Prowlarr | http://localhost:9696 | 9696 |
| Profilarr | http://localhost:6868 | 6868 |
| Bazarr | http://localhost:6767 | 6767 |
| SABnzbd | http://localhost:8080 | 8080 |
| Stream Proxy | http://localhost:3000 | 3000 |

## ⚙️ Essential .env Variables

```bash
# User and timezone
PUID=1000
PGID=1000
TZ=America/New_York

# Paths
MEDIA_PATH=/mnt/media
CONFIG_BASE=/srv/config
DOWNLOADS_BASE=/srv/downloads

# SABnzbd
SAB_APIKEY=your_api_key_here
BASE_URL=http://your-server:3000
```

## 🔧 Common Troubleshooting

### Permission Issues
```bash
# Fix ownership
sudo chown -R 1000:1000 /srv/config
sudo chown -R 1000:1000 /srv/downloads
sudo chown -R 1000:1000 /mnt/media
```

### Port Conflicts
```bash
# Check port usage
netstat -tulpn | grep 7878

# Update in .env
RADARR_PORT=7879  # Change to available port
docker compose up -d --force-recreate radarr
```

### Container Won't Start
```bash
# Check logs
docker compose logs radarr

# Recreate container
docker compose up -d --force-recreate radarr

# Full reset
docker compose down
docker compose up -d
```

### Can't Access Service
```bash
# Check if running
docker compose ps

# Check network
docker network ls
docker network inspect arrstack-main_media-net

# Check firewall
sudo ufw status
sudo ufw allow 7878/tcp
```

## 📦 Docker Hub Deployment

### Setup GitHub Secrets
1. Go to GitHub repo → Settings → Secrets
2. Add: `DOCKERHUB_USERNAME`
3. Add: `DOCKERHUB_TOKEN`

### Create Release
```bash
# Tag version
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# GitHub Actions automatically builds and pushes
```

### Use Custom Image
```yaml
# Update docker-compose.yaml
services:
  custom-service:
    image: yourusername/arrstack:latest
```

## 🔐 Security Checklist

- [ ] `.env` file is in `.gitignore`
- [ ] All passwords are strong and unique
- [ ] SAB_APIKEY is generated and secure
- [ ] Firewall rules are configured
- [ ] Services not exposed to internet (use reverse proxy)
- [ ] Regular backups scheduled
- [ ] Images updated regularly

## 📁 Important File Locations

### Configuration Files
```
/srv/config/radarr/
/srv/config/sonarr/
/srv/config/prowlarr/
/srv/config/profilarr/
/srv/config/bazarr/
/srv/config/sabnzbd/
```

### Download Paths
```
/srv/downloads/movies/    # Radarr
/srv/downloads/tv/        # Sonarr
/srv/downloads/           # SABnzbd
```

### Media Paths
```
/mnt/media/movies/
/mnt/media/tv/
```

## 🆘 Getting Help

1. **Check documentation**: `README.md`, `SETUP_GUIDE.md`
2. **Check logs**: `docker compose logs -f`
3. **Verify config**: `docker compose config`
4. **Check GitHub Issues**: Existing solutions
5. **Servarr Wiki**: https://wiki.servarr.com/

## 📊 Health Checks

```bash
# Check all containers
docker compose ps

# Check specific service health
docker inspect radarr | grep -A 10 Health

# Check disk space
df -h

# Check memory usage
docker stats

# Check network connectivity
docker exec radarr ping -c 3 sabnzbd
```

## 🔄 Update Workflow

```bash
# 1. Backup first
./backup_configs.sh

# 2. Pull new images
docker compose pull

# 3. Restart services
docker compose up -d

# 4. Verify
docker compose ps
docker compose logs -f

# 5. Cleanup old images
docker image prune -a
```

## 💾 Backup Strategy

### What to Backup
- `/srv/config/*` - All service configurations
- `.env` file - Your environment settings
- `docker-compose.yaml` - If customized

### Automated Backup
```bash
# Add to crontab
crontab -e

# Run backup daily at 2 AM
0 2 * * * /path/to/backup_configs.sh

# Copy to NAS
0 3 * * * rsync -av /path/to/backups/ /mnt/nas/backups/
```

## 🎯 Performance Tips

1. **Use SSD** for config directories
2. **Separate volumes** for downloads and media
3. **Limit container resources** if needed:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '2'
         memory: 2G
   ```
4. **Monitor logs** regularly for issues
5. **Keep images updated** for performance improvements

## 📝 Quick Notes

- Default username/password: Check service documentation
- Services communicate via Docker network (use service names)
- SABnzbd categories: `movies` and `tv`
- Path mappings must match in all *arr services
- PUID/PGID must match file ownership

---

For complete documentation, see:
- [README.md](README.md) - Full overview
- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Detailed setup
- [DOCKER_HUB.md](DOCKER_HUB.md) - Publishing guide
