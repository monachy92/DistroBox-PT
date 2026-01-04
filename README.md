# Cisco Packet Tracer on Fedora (Podman/Distrobox)

This repo automates the setup of Packet Tracer 9.0 on Fedora using an Ubuntu 22.04 container.

## Installation
1. Run `./setup.sh`
2. Enter the box: `distrobox-enter PTBox`
3. Install your .deb file: `sudo apt install ./CiscoPacketTracer_900_Ubuntu_64bit.deb`
4. Extract the AppImage: 
   ```bash
   mkdir -p ~/.pt_app
   /opt/pt/packettracer.AppImage --appimage-extract
   mv squashfs-root/* ~/.pt_app/

---

### 3. Push to GitHub
Now, initialize your git repo and push it.

```bash
git init
git add .
git commit -m "Initial commit: Packet Tracer Fedora setup scripts"
# Create a repo on GitHub.com first, then:
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
