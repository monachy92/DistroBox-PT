# Cisco Packet Tracer on Fedora

A simple automated setup script for running **Cisco Packet Tracer 9.0** on Fedora using Distrobox and an Ubuntu 22.04 container.

## Why This Exists

Cisco Packet Tracer officially only supports Ubuntu/Debian systems. This script creates an isolated Ubuntu environment on Fedora using Distrobox, allowing you to run Packet Tracer seamlessly with full desktop integration.

## Prerequisites

- **Fedora** or any inux distro
- **Distrobox** and **Podman** (usually pre-installed on Fedora variants)
- **Cisco Packet Tracer .deb file** - Download from [Cisco NetAcad](https://www.netacad.com/portal/resources/packet-tracer) (free account required)

### Install Distrobox (if needed)

```bash
sudo dnf install distrobox
```

## Installation

### Option 1: Automated Installation (Recommended)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/monarchy92/packet-tracer-fedora.git
   cd packet-tracer-fedora
   ```

2. **Make the script executable:**
   ```bash
   chmod +x setup.sh
   ```

3. **Run the setup script:**
   ```bash
   ./setup.sh
   ```

4. **Follow the prompts:**
   - The script will create the container and install dependencies
   - When prompted, provide the path to your downloaded `.deb` file
   - The script will handle the rest automatically

### Option 2: Manual Installation

If you prefer to do it step-by-step:

1. **Run the setup script without the .deb:**
   ```bash
   ./setup.sh
   ```
   Choose 'n' when asked about the .deb file.

2. **Enter the container:**
   ```bash
   distrobox-enter -n PTBox
   ```

3. **Install the .deb file:**
   ```bash
   sudo apt install ./CiscoPacketTracer_900_Ubuntu_64bit.deb
   ```

4. **Extract the AppImage:**
   ```bash
   mkdir -p ~/.pt_app
   /opt/pt/packettracer.AppImage --appimage-extract
   mv squashfs-root/* ~/.pt_app/
   ```

5. **Exit the container:**
   ```bash
   exit
   ```

## Usage

After installation, you can launch Packet Tracer in two ways:

1. **From your application menu** - Look for "Cisco Packet Tracer" in Education or Network categories
2. **From the command line:**
   ```bash
   ~/launch_pt.sh
   ```

## What Does This Script Do?

1. Creates an Ubuntu 22.04 Distrobox container named `PTBox`
2. Installs all necessary dependencies (X11, graphics, audio libraries)
3. Creates browser symlinks for Packet Tracer's web integration
4. Generates a launcher script with proper X11 forwarding
5. Creates a desktop entry for application menu integration
6. Optionally installs and extracts Packet Tracer automatically

## Troubleshooting

### Packet Tracer won't launch
- Make sure you completed the AppImage extraction step
- Try running from terminal to see error messages: `~/launch_pt.sh`

### Graphics issues
- Ensure your graphics drivers are up to date
- Try running: `xhost +local:docker` before launching

### Container issues
```bash
# Remove and recreate the container
distrobox rm PTBox
./setup.sh
```

### Desktop icon not appearing
```bash
update-desktop-database ~/.local/share/applications
```

## Uninstallation

To completely remove Packet Tracer and the container:

```bash
# Remove the container
distrobox rm PTBox

# Remove application files
rm -rf ~/.pt_app
rm ~/launch_pt.sh
rm ~/.local/share/applications/packettracer.desktop

# Update desktop database
update-desktop-database ~/.local/share/applications
```
---
## Disclaimer
This project is an independent community effort and is not affiliated with, sponsored by, or endorsed by Cisco Systems, Inc. Cisco Packet Tracer is a proprietary software owned by Cisco. This script does not distribute the Packet Tracer binaries; it only provides a method for users to install their own legally obtained copies on Fedora-based systems.



