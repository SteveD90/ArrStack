#!/usr/bin/env bash
# Simple tar backup of service config folders
set -euo pipefail

ENV_FILE=".env"
if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC1091
  source "$ENV_FILE"
else
  echo "No ${ENV_FILE} found. Create it from .env.example first."
  exit 1
fi

BACKUP_DIR="${BACKUP_DIR:-/srv/backups}"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
OUTFILE="${BACKUP_DIR}/media-config-backup-${TIMESTAMP}.tar.gz"

sudo mkdir -p "$BACKUP_DIR"
sudo chown "$(id -u):$(id -g)" "$BACKUP_DIR"

echo "Creating backup ${OUTFILE}..."
tar -czf "$OUTFILE" \
  -C / "${RADARR_CONFIG#/}" \
  -C / "${SONARR_CONFIG#/}" \
  -C / "${PROWLARR_CONFIG#/}" \
  -C / "${PROFILARR_CONFIG#/}" \
  || { echo "tar failed"; exit 1; }

echo "Backup complete: $OUTFILE"
# Optional: rsync to NAS (uncomment & set DEST)
# DEST=your-nas:/path/backups/
# rsync -avh --progress "$OUTFILE" "$DEST"