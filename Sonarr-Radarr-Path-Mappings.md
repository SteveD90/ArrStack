# Sonarr and Radarr Path Mappings Guide

## Root Folder Configuration
1. **Sonarr**:
   - Navigate to **Settings > Media Management > Root Folders**.
   - Add a root folder pointing to `/media/tv` (mapped to `/mnt/tank/media/tv` on your host).

2. **Radarr**:
   - Navigate to **Settings > Media Management > Root Folders**.
   - Add a root folder pointing to `/media/movies` (mapped to `/mnt/tank/media/movies` on your host).

## Completed Download Handling
1. **Sonarr**:
   - Navigate to **Settings > Download Clients**.
   - Ensure "Completed Download Handling" is enabled.
   - This allows Sonarr to import files from `/downloads/tv` after SABnzbd finishes downloading.

2. **Radarr**:
   - Navigate to **Settings > Download Clients**.
   - Ensure "Completed Download Handling" is enabled.
   - This allows Radarr to import files from `/downloads/movies` after SABnzbd finishes downloading.

## Path Mappings
- **Download Folder**:
  - SABnzbd downloads files to `/downloads`.
  - Sonarr maps `/downloads/tv` for TV shows.
  - Radarr maps `/downloads/movies` for movies.

- **Media Folder**:
  - Sonarr imports TV shows to `/media/tv`.
  - Radarr imports movies to `/media/movies`.

## Additional Configurations
1. **Sonarr**:
   - Enable "Rename Episodes" in **Settings > Media Management** for consistent naming.
   - Configure "Import Extra Files" if you want subtitles or other extras.

2. **Radarr**:
   - Enable "Rename Movies" in **Settings > Media Management** for consistent naming.
   - Configure "Minimum Free Space" in **Settings > General** to avoid disk space issues.

## Testing
- Add a test download in SABnzbd and verify that Sonarr and Radarr correctly import the files.
- Check logs in Sonarr and Radarr for any errors related to path mappings or permissions.

Let me know if you need further assistance!