# Cisco Packet Tracer on Fedora

A simple automated setup script for running **Cisco Packet Tracer 9.0** on Fedora (and other immutable Linux distributions) using Distrobox and an Ubuntu 22.04 container.

## Why This Exists

Cisco Packet Tracer officially only supports Ubuntu/Debian systems. This script creates an isolated Ubuntu environment on Fedora using Distrobox, allowing you to run Packet Tracer seamlessly with full desktop integration.

## Prerequisites

- **Fedora** (tested on Fedora 39+) or any immutable Linux distro (Silverblue, Kinoite, Bazzite, etc.)
- **Distrobox** and **Podman** (usually pre-installed on immutable Fedora variants)
- **Cisco Packet Tracer .deb file** - Download from [Cisco NetAcad](https://www.netacad.com/portal/resources/packet-tracer) (free account required)

### Install Distrobox (if needed)

```bash
sudo dnf install distrobox
```

## Installation

### Option 1: Automated Installation (Recommended)

1. **Clone this repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/packet-tracer-fedora.git
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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

- Cisco for Packet Tracer
- The Distrobox team for making containerized applications seamless

## License

MIT License - Feel free to use and modify as needed.

## Disclaimer

This is an unofficial installation method. Cisco Packet Tracer is proprietary software owned by Cisco Systems. You must obtain it legally from Cisco NetAcad with a valid account.


# ============================================
# FILE: LICENSE
# ============================================
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


# ============================================
# FILE: .gitignore
# ============================================
# Cisco Packet Tracer .deb files
*.deb

# AppImage files
*.AppImage

# Temporary files
*~
*.swp
*.swo

# System files
.DS_Store
Thumbs.db


# ============================================
# INSTRUCTIONS: How to push to GitHub
# ============================================

# 1. Create these files in your project directory:
#    - setup.sh (copy the first section above)
#    - README.md (copy the second section above)
#    - LICENSE (copy the third section above)
#    - .gitignore (copy the fourth section above)

# 2. Initialize git repository:
git init

# 3. Add all files:
git add .

# 4. Commit:
git commit -m "Initial commit: Packet Tracer Fedora setup scripts"

# 5. Create a new repository on GitHub.com
#    - Go to https://github.com/new
#    - Name it something like "packet-tracer-fedora"
#    - Don't initialize with README (we already have one)

# 6. Add remote and push:
git remote add origin https://github.com/YOUR_USERNAME/packet-tracer-fedora.git
git branch -M main
git push -u origin main
