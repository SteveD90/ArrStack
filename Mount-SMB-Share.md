# Mounting SMB Share on Proxmox Server

This guide explains how to mount an SMB share from your NAS as a network drive on your Proxmox server running Linux.

## Steps to Mount SMB Share

### 1. Install Required Packages
Ensure the `cifs-utils` package is installed on your Proxmox server:
```bash
sudo apt update
sudo apt install cifs-utils
```

### 2. Create a Mount Point
Create a directory where the SMB share will be mounted:
```bash
sudo mkdir -p /mnt/tank
```

### 3. Mount the SMB Share
Use the `mount.cifs` command to mount the SMB share:
```bash
sudo mount -t cifs //NAS_IP/ShareName /mnt/tank -o username=your_username,password=your_password,uid=1000,gid=1000
```
Replace:
- `NAS_IP` with the IP address of your NAS.
- `ShareName` with the name of the shared folder.
- `/mnt/tank` with the desired mount point on your Proxmox server.
- `your_username` and `your_password` with your NAS credentials.
- `uid=1000,gid=1000` to match the user and group IDs used by your Docker containers.

### 4. Verify the Mount
Check if the share is mounted successfully:
```bash
df -h
```
You should see the SMB share listed.

## Persistent Mount (Optional)
To ensure the SMB share is mounted automatically after a reboot, add it to your `/etc/fstab` file:

### 1. Edit `/etc/fstab`
Open the file in a text editor:
```bash
sudo nano /etc/fstab
```

### 2. Add the SMB Share
Add the following line:
```fstab
//NAS_IP/ShareName /mnt/tank cifs username=your_username,password=your_password,uid=1000,gid=1000 0 0
```

### 3. Test the Configuration
Test the `/etc/fstab` entry by unmounting and remounting:
```bash
sudo umount /mnt/tank
sudo mount -a
```

## Key Considerations

### Permissions
Ensure the mounted share has the correct `uid` and `gid` to match your Docker containers' `PUID` and `PGID`.

### Network Connectivity
Verify that your Proxmox server can reach the NAS over the network.

### Performance
SMB is suitable for your setup, but if you experience performance issues, consider switching to NFS (if supported by your NAS).

Let me know if you need further assistance!