# SABnzbd Configuration Guide

## Accessing SABnzbd
1. Open your browser and navigate to:
   ```
   http://<server-ip>:8080
   ```
   Replace `<server-ip>` with the IP address of your Proxmox server.

## Initial Setup
1. **Language Selection**:
   - Choose your preferred language and click "Next."

2. **Usenet Server Configuration**:
   - Enter the details of your Usenet provider:
     - **Server Address**: Provided by your Usenet provider (e.g., `news.example.com`).
     - **Port**: Typically `119` for unencrypted or `563` for SSL.
     - **Username/Password**: Your Usenet account credentials.
     - **Connections**: Set the number of simultaneous connections (check your provider's limit).

3. **Download Folder**:
   - Set the download folder to `/downloads` (mapped to `/srv/downloads` on your host).

4. **Complete Setup**:
   - Click "Next" to finish the setup.

## Advanced Configuration
1. **Categories**:
   - Go to **Settings > Categories**.
   - Add categories for `movies` and `tv`:
     - **Movies**: Set the folder to `/downloads/movies`.
     - **TV**: Set the folder to `/downloads/tv`.

2. **API Key**:
   - Go to **Settings > General**.
   - Copy the API key for integration with Sonarr and Radarr.

3. **Scheduler**:
   - Configure schedules for throttling or pausing downloads during specific times.

4. **Post-Processing**:
   - Enable post-processing scripts if needed (e.g., for renaming or moving files).

## Integration with Sonarr and Radarr
1. **Sonarr**:
   - Go to **Settings > Download Clients** in Sonarr.
   - Add SABnzbd as a client:
     - **Host**: `<server-ip>`
     - **Port**: `8080`
     - **API Key**: Paste the API key from SABnzbd.
     - **Category**: `tv`

2. **Radarr**:
   - Go to **Settings > Download Clients** in Radarr.
   - Add SABnzbd as a client:
     - **Host**: `<server-ip>`
     - **Port**: `8080`
     - **API Key**: Paste the API key from SABnzbd.
     - **Category**: `movies`

## Testing
- Add a test download in SABnzbd to ensure everything is working.
- Verify that Sonarr and Radarr can send jobs to SABnzbd.