#!/usr/bin/env bash
# Create host config and download directories and set ownership to PUID:PGID from .env
set -euo pipefail

ENV_FILE=".env"
if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC1091
  source "$ENV_FILE"
else
  echo "No ${ENV_FILE} found. Copy .env.example -> .env and edit values first."
  exit 1
fi

# Directories to create (match your compose)
dirs=(
  "${RADARR_CONFIG%/}"
  "${SONARR_CONFIG%/}"
  "${PROWLARR_CONFIG%/}"
  "${PROFILARR_CONFIG%/}"
  "${BAZARR_CONFIG%/}"
  "${SABNZBD_CONFIG%/}"
  "${SAB_STREAM_PROXY_CONFIG%/}"
  "${RADARR_DOWNLOADS%/}"
  "${SONARR_DOWNLOADS%/}"
  "${SABNZBD_DOWNLOADS%/}"
  "${MEDIA_PATH%/}"
)

echo "Creating directories and applying ownership ${PUID}:${PGID}..."
for d in "${dirs[@]}"; do
  if [ -z "$d" ]; then
    continue
  fi
  sudo mkdir -p "$d"
  sudo chown -R "${PUID}:${PGID}" "$d"
  sudo chmod -R 750 "$d" || true
  echo "  - $d"
done

echo "Done. Verify with: ls -ln ${dirs[*]}"