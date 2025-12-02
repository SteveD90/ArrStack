# Media Stack (Radarr / Sonarr / Prowlarr / Profilarr / SABnzbd)

What this folder contains
- docker-compose.yml        - service definitions (Radarr, Sonarr, Prowlarr, Profilarr, SABnzbd)
- .env                     - runtime variables (PUID, PGID, paths, ports) — create from .env.example
- create_dirs.sh           - create host config/downloads dirs and chown to PUID/PGID
- backup_configs.sh        - quick tar backup of service config directories

Quick setup (on Docker host / Proxmox VM where Docker runs)
1. Copy .env.example -> .env and edit values (PUID, PGID, paths, ports)
   cp .env.example .env
   # edit .env with your editor

2. Create host directories and set ownership (uses values from .env):
   chmod +x create_dirs.sh
   sudo ./create_dirs.sh

3. Start the stack:
   docker compose --env-file .env up -d --build

4. Check logs:
   docker compose --env-file .env logs -f

Stopping and removing:
   docker compose --env-file .env down

Backups
- Run the backup script to create a timestamped tarball of config dirs:
  chmod +x backup_configs.sh
  ./backup_configs.sh
- Extend the script to push backups to NAS or cloud (rsync/restic/etc).

## SABnzbd Integration
- SABnzbd is included in this stack for managing Usenet downloads.
- Ensure the following variables are set in `.env`:
  - `SABNZBD_CONFIG=/srv/sabnzbd/config`
  - `SABNZBD_DOWNLOADS=/srv/downloads`
  - `SABNZBD_PORT=8080`
- Access SABnzbd at `http://<server-ip>:8080` after starting the stack.

## Proxmox-Specific Setup
- Ensure Docker is installed on your Proxmox VM.
- Mount NAS shares using CIFS/SMB with appropriate `uid` and `gid` options.
- Verify that `/srv` directories are accessible and writable by Docker containers.

Security notes
- Do NOT commit .env or other files containing secrets to git. Add .env to .gitignore.
- For production secrets consider a secrets manager or Docker secrets.

Troubleshooting hints
- If a container cannot write to a mounted host directory: ensure the host directory exists and is chowned to the numeric PUID:PGID used by the container (see create_dirs.sh).
- If NAS shares are mounted via CIFS/SMB, use mount options (uid=...,gid=...) so ownership behaves as expected.

Optional improvements
- Add a reverse proxy (Traefik or nginx-proxy) with SSL for remote access.
- Add Watchtower or a GitHub Actions pipeline to build/publish versioned images for production.
- Add healthchecks in docker-compose for better orchestration/resilience.