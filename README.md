# ArrStack - Complete Media Automation Stack

A production-ready Docker Compose stack for automated media management, featuring Radarr, Sonarr, Prowlarr, Profilarr, Bazarr, and SABnzbd.

## What's Included

- **Radarr** - Movie collection manager
- **Sonarr** - TV series collection manager  
- **Prowlarr** - Indexer manager for *arr apps
- **Profilarr** - Custom format profile manager
- **Bazarr** - Subtitle management
- **SABnzbd** - Usenet downloader
- **sab-stream-proxy** - Stream downloads directly from SABnzbd (optional)

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- User with appropriate permissions (note your PUID/PGID)
- Storage paths configured (local or NAS-mounted)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd ArrStack
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   nano .env
   ```
   
   Update at minimum:
   - `PUID` and `PGID` (run `id <username>` to find yours)
   - `TZ` (your timezone, e.g., `America/New_York`)
   - `MEDIA_PATH` (where your media is stored)
   - `CONFIG_BASE` and `DOWNLOADS_BASE` (config and download directories)

3. **Create directories and set permissions**
   ```bash
   chmod +x create_dirs.sh
   sudo ./create_dirs.sh
   ```

4. **Start the stack**
   ```bash
   docker compose up -d
   ```

5. **Access the applications**
   - Radarr: `http://<server-ip>:7878`
   - Sonarr: `http://<server-ip>:8989`
   - Prowlarr: `http://<server-ip>:9696`
   - Profilarr: `http://<server-ip>:6868`
   - Bazarr: `http://<server-ip>:6767`
   - SABnzbd: `http://<server-ip>:8080`
   - Stream Proxy: `http://<server-ip>:3000`

## Configuration Guides

See the following documentation for detailed setup:
- [SABnzbd Configuration](./SABnzbd-Configuration.md)
- [Sonarr/Radarr Path Mappings](./Sonarr-Radarr-Path-Mappings.md)
- [Mounting SMB Shares](./Mount-SMB-Share.md)

## File Structure

```
ArrStack/
├── docker-compose.yaml       # Service definitions
├── .env.example              # Environment variable template
├── .env                      # Your configuration (gitignored)
├── create_dirs.sh            # Directory creation script
├── backup_configs.sh         # Backup utility
├── README.md                 # This file
└── docs/                     # Configuration guides
```

## Management Commands

**View logs**
```bash
docker compose logs -f [service-name]
```

**Stop the stack**
```bash
docker compose down
```

**Update containers**
```bash
docker compose pull
docker compose up -d
```

**Backup configurations**
```bash
chmod +x backup_configs.sh
./backup_configs.sh
```

## TrueNAS / NAS Integration

If running on TrueNAS or mounting NAS shares:

1. Mount SMB/NFS shares with correct `uid` and `gid` options
2. Ensure the mount points match your `.env` paths
3. Verify permissions: `ls -ln /mnt/media`
4. See [Mount-SMB-Share.md](./Mount-SMB-Share.md) for details

## Security Considerations

- **Never commit `.env`** - It's in `.gitignore` by default
- Use strong passwords for all services
- Consider a reverse proxy (Traefik/Nginx) with SSL for remote access
- Limit port exposure to trusted networks
- Keep images updated regularly

## Troubleshooting

**Container can't write to directories**
- Verify PUID/PGID matches file ownership: `ls -ln /srv/config`
- Re-run `create_dirs.sh` with correct values
- Check NAS mount options include correct `uid`/`gid`

**Services can't communicate**
- All services are on the `media-net` network
- Use service names (e.g., `sabnzbd`) not IPs in configurations

**Port conflicts**
- Check if ports are already in use: `netstat -tulpn | grep <port>`
- Update port mappings in `.env` if needed

## Docker Hub Deployment

To build and publish custom images:

1. **Build the image**
   ```bash
   docker build -t yourusername/arrstack:latest .
   ```

2. **Push to Docker Hub**
   ```bash
   docker login
   docker push yourusername/arrstack:latest
   ```

3. **Update docker-compose.yaml**
   ```yaml
   image: yourusername/arrstack:latest
   ```

See [DOCKER_HUB.md](./DOCKER_HUB.md) for detailed instructions.

## Optional Enhancements

- Add Watchtower for automatic container updates
- Implement monitoring with Prometheus/Grafana
- Configure Traefik for SSL/reverse proxy
- Set up automated backups to cloud storage
- Add healthchecks to services

## Support & Contributing

- Report issues via GitHub Issues
- Submit pull requests for improvements
- See contributing guidelines before submitting PRs

## License

[Your License Here]