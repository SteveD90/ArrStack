# Extracted Configuration from Working TrueNAS Setup

## ✅ Successfully Extracted and Applied

### User Settings
- **PUID**: 568 (TrueNAS apps user)
- **PGID**: 568 (TrueNAS apps group)
- **Timezone**: America/New_York

### Paths (TrueNAS Structure)
- **Media**: `/mnt/tank/media` (your media library)
- **Config**: `/mnt/ssd/appdata` (application configs)
- **Data**: `/mnt/ssd/data` (working directory)
- **Usenet**: `/mnt/ssd/data/usenet` (download location)

### Docker Images (Hotio)
Using hotio images (optimized for stability):
- Radarr: `ghcr.io/hotio/radarr:latest`
- Sonarr: `ghcr.io/hotio/sonarr:latest`
- Prowlarr: `ghcr.io/hotio/prowlarr:latest`
- Bazarr: `ghcr.io/hotio/bazarr:latest`
- SABnzbd: `ghcr.io/hotio/sabnzbd:latest`

### Network
- Network name: `arr-network`
- All services have `.internal` hostnames

### Ports (Unchanged)
- Radarr: 7878
- Sonarr: 8989
- Prowlarr: 9696
- Bazarr: 6767
- SABnzbd: 8080, 9090

## Key Differences from Template

### Volume Mappings
Your TrueNAS setup uses a smart path structure:
- `/data` - Working directory for downloads in progress
- `/usenet` - Completed downloads
- `/media` - Final media destination

This allows for atomic moves and hardlinks, improving efficiency.

### Images
Switched from LinuxServer.io to Hotio images to match your working setup. Both are excellent, but consistency is important.

## What's Ready

Your `.env` file now contains:
✅ Correct PUID/PGID for TrueNAS
✅ All your actual paths
✅ Hotio image references
✅ Proper network name
✅ All port mappings

Your `docker-compose.yaml` now:
✅ Uses environment variables
✅ Matches your working structure
✅ Includes all volume mounts
✅ Has hostnames configured
✅ Uses json-file logging

## Validation

```bash
# Configuration validated successfully
docker compose config
# ✅ No errors, all variables resolved
```

## Next Steps

1. **Get SABnzbd API Key** from your working instance:
   ```bash
   # On TrueNAS, check the config file
   grep -i api_key /mnt/ssd/appdata/sabnzbd/sabnzbd.ini
   ```

2. **Update .env** with the API key:
   ```bash
   nano .env
   # Change: SAB_APIKEY=your_actual_key_here
   ```

3. **Test deployment** (optional):
   ```bash
   docker compose up -d
   docker compose ps
   docker compose logs -f
   ```

4. **Commit to Git**:
   ```bash
   git add .
   git commit -m "Update configuration with TrueNAS paths and hotio images"
   git push
   ```

## Important Notes

- Your working configuration has been preserved
- All paths match your TrueNAS mount structure
- PUID/PGID 568 is standard for TrueNAS SCALE
- The repo is now ready for deployment or Docker Hub publishing
