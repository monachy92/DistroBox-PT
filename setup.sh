#!/bin/bash
set -e

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Hardened Cisco Packet Tracer Setup${NC}"
echo -e "${BLUE}========================================${NC}"

# 1. Create a secure, isolated home for the container
echo -e "${GREEN}[1/6] Creating isolated home and container...${NC}"
mkdir -p ~/.pt_container_home
distrobox-create --name PTBox --image ubuntu:22.04 --home ~/.pt_container_home --yes

# 2. Run setup commands inside the box
echo -e "${GREEN}[2/6] Installing dependencies...${NC}"
distrobox-enter -n PTBox -- sh -c '
sudo apt update && sudo apt install -y libgl1-mesa-glx libpulse0 libnss3 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-shape0 libxcb-util1 libxcb-xkb1 libxkbcommon-x11-0 libdbus-1-3 libxcb-randr0 libxcb-xtest0 libglib2.0-0 xdg-utils libfuse2 libopengl0 dbus-x11
sudo ln -s /usr/bin/xdg-open /usr/bin/google-chrome
sudo ln -s /usr/bin/xdg-open /usr/bin/firefox
'

# 3. Create a SAFER launcher script with auto-cleanup
echo -e "${GREEN}[3/6] Creating hardened launcher script...${NC}"
cat <<EOF > ~/launch_pt.sh
#!/bin/bash
# Open graphics access
xhost +local:docker > /dev/null

# Run the app
distrobox-enter -n PTBox -- sh -c "cd ~/.pt_app && ./AppRun --no-sandbox"

# AUTOMATIC CLEANUP: Close graphics access when app exits
xhost -local:docker > /dev/null
EOF
chmod +x ~/launch_pt.sh

# 4. Create the Desktop Entry
echo -e "${GREEN}[4/6] Creating the desktop menu icon...${NC}"
mkdir -p ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/packettracer.desktop
[Desktop Entry]
Name=Cisco Packet Tracer (Secure)
Exec=/home/$USER/launch_pt.sh
Icon=network-workgroup
Terminal=false
Type=Application
Categories=Education;Network;
EOF
update-desktop-database ~/.local/share/applications

echo -e "${GREEN}[5/6] Container setup complete!${NC}"

# 5. Prompt for .deb file installation
echo ""
read -p "Do you have the .deb file ready? (y/n): " has_deb

if [[ $has_deb =~ ^[Yy]$ ]]; then
    read -p "Enter the full path to the .deb file: " deb_path
    
    if [ -f "$deb_path" ]; then
        echo -e "${GREEN}Installing Packet Tracer...${NC}"
        distrobox-enter -n PTBox -- sh -c "sudo apt install -y '$deb_path'"
        
        echo -e "${GREEN}[6/6] Extracting AppImage...${NC}"
        distrobox-enter -n PTBox -- sh -c '
        mkdir -p ~/.pt_app
        /opt/pt/packettracer.AppImage --appimage-extract
        mv squashfs-root/* ~/.pt_app/
        rm -rf squashfs-root
        '
        echo -e "${GREEN}Installation Complete!${NC}"
    else
        echo -e "${RED}Error: File not found: $deb_path${NC}"
    fi
fi
