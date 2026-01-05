# ============================================
# FILE: setup.sh
# ============================================
#!/bin/bash
set -e

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Cisco Packet Tracer Setup for Fedora${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 1. Create the Distrobox
echo -e "${GREEN}[1/6] Creating the Ubuntu container...${NC}"
distrobox-create --name PTBox --image ubuntu:22.04 --yes

# 2. Run setup commands inside the box
echo -e "${GREEN}[2/6] Installing dependencies inside the container...${NC}"
distrobox-enter -n PTBox -- sh -c '
sudo apt update && sudo apt install -y libgl1-mesa-glx libpulse0 libnss3 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-shape0 libxcb-util1 libxcb-xkb1 libxkbcommon-x11-0 libdbus-1-3 libxcb-randr0 libxcb-xtest0 libglib2.0-0 xdg-utils libfuse2 libopengl0 dbus-x11
sudo ln -s /usr/bin/xdg-open /usr/bin/google-chrome
sudo ln -s /usr/bin/xdg-open /usr/bin/firefox
'

# 3. Create the launcher script on the host
echo -e "${GREEN}[3/6] Creating the launcher script...${NC}"
cat <<EOF > ~/launch_pt.sh
#!/bin/bash
xhost +local:docker > /dev/null
distrobox-enter -n PTBox -- sh -c "cd ~/.pt_app && ./AppRun --no-sandbox"
EOF
chmod +x ~/launch_pt.sh

# 4. Create the Desktop Entry
echo -e "${GREEN}[4/6] Creating the desktop menu icon...${NC}"
mkdir -p ~/.local/share/applications
cat <<EOF > ~/.local/share/applications/packettracer.desktop
[Desktop Entry]
Name=Cisco Packet Tracer
Exec=/home/$USER/launch_pt.sh
Icon=/home/$USER/.pt_app/usr/share/icons/hicolor/scalable/apps/pt7.svg
Terminal=false
Type=Application
Categories=Education;Network;
EOF
update-desktop-database ~/.local/share/applications

echo -e "${GREEN}[5/6] Container setup complete!${NC}"
echo ""

# 5. Prompt for .deb file installation
echo -e "${YELLOW}Now we need to install the Packet Tracer .deb file.${NC}"
echo -e "${YELLOW}Please make sure you have downloaded it from Cisco NetAcad.${NC}"
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
        
        echo ""
        echo -e "${GREEN}========================================${NC}"
        echo -e "${GREEN}Installation Complete!${NC}"
        echo -e "${GREEN}========================================${NC}"
        echo ""
        echo -e "${BLUE}You can now launch Packet Tracer from:${NC}"
        echo -e "  • Your application menu"
        echo -e "  • Running: ~/launch_pt.sh"
        echo ""
    else
        echo -e "${RED}Error: File not found: $deb_path${NC}"
        echo -e "${YELLOW}Please run the manual steps below.${NC}"
        has_deb="n"
    fi
fi

if [[ ! $has_deb =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Manual Installation Steps${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo -e "${BLUE}1. Enter the container:${NC}"
    echo -e "   distrobox-enter -n PTBox"
    echo ""
    echo -e "${BLUE}2. Install the .deb file:${NC}"
    echo -e "   sudo apt install ./CiscoPacketTracer_900_Ubuntu_64bit.deb"
    echo ""
    echo -e "${BLUE}3. Extract the AppImage:${NC}"
    echo -e "   mkdir -p ~/.pt_app"
    echo -e "   /opt/pt/packettracer.AppImage --appimage-extract"
    echo -e "   mv squashfs-root/* ~/.pt_app/"
    echo ""
    echo -e "${BLUE}4. Launch Packet Tracer:${NC}"
    echo -e "   ~/launch_pt.sh"
    echo ""
fi
