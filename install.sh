#!/bin/bash

# Constants
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Check if script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run as root${RESET}"
        exit 1
    fi
}

# Error handling function
handle_error() {
    echo -e "${RED}Error: $1${RESET}"
    exit 1
}

# Backup function
backup_pterodactyl() {
    echo -e "${BLUE}Creating backup of existing installation...${RESET}"
    cd /var/www/ || handle_error "Could not access /var/www/"
    tar -czf "pterodactyl_backup_$(date +%Y%m%d_%H%M%S).tar.gz" pterodactyl || handle_error "Backup failed"
    echo -e "${GREEN}Backup created successfully${RESET}"
}

# Main installation function
install_theme() {
    clear
    print_banner "THEME INSTALLATION"
    
    # Install dependencies
    echo -e "${BLUE}Installing dependencies...${RESET}"
    apt-get update > /dev/null 2>&1 || handle_error "Failed to update package list"
    apt-get install -y sudo git curl > /dev/null 2>&1 || handle_error "Failed to install dependencies"

    # Backup existing installation
    backup_pterodactyl

    # Clone and setup theme
    cd /var/www/pterodactyl || handle_error "Could not access pterodactyl directory"
    echo -e "${BLUE}Downloading theme...${RESET}"
    rm -rf xCBTheme
    git clone https://github.com/conbert11/xCBTheme.git || handle_error "Failed to clone theme repository"
    
    # Remove old theme files
    echo -e "${BLUE}Cleaning old theme files...${RESET}"
    rm -f resources/scripts/xCBTheme.css resources/scripts/index.tsx

    # Install Node.js and dependencies
    echo -e "${BLUE}Setting up Node.js environment...${RESET}"
    export NVM_DIR="$HOME/.nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 16 || handle_error "Failed to install Node.js"
    nvm use 16

    # Install yarn and build
    echo -e "${BLUE}Installing Yarn and building theme...${RESET}"
    npm install -g yarn || handle_error "Failed to install Yarn"
    yarn install || handle_error "Failed to install dependencies"
    yarn build:production || handle_error "Failed to build theme"

    # Move theme files
    cd xCBTheme || handle_error "Could not access theme directory"
    mv index.tsx ../resources/scripts/
    mv xCBTheme.css ../resources/scripts/

    # Clear Laravel cache
    php artisan optimize:clear || handle_error "Failed to clear Laravel cache"

    echo -e "${GREEN}Theme installation completed successfully!${RESET}"
    print_banner "INSTALLATION COMPLETE"
}

# Banner printing function
print_banner() {
    local text="$1"
    echo ""
    echo "======================================"
    echo "   $text"
    echo "======================================"
    echo ""
}

# Uninstall function
uninstall_theme() {
    clear
    print_banner "THEME UNINSTALLATION"
    
    cd /var/www/pterodactyl || handle_error "Could not access pterodactyl directory"
    
    # Restore from backup
    echo -e "${BLUE}Restoring from backup...${RESET}"
    local latest_backup=$(ls -t /var/www/pterodactyl_backup_*.tar.gz 2>/dev/null | head -n1)
    
    if [ -n "$latest_backup" ]; then
        tar -xzf "$latest_backup" -C /var/www/ || handle_error "Failed to restore backup"
        echo -e "${GREEN}Restored from backup: $latest_backup${RESET}"
    else
        echo -e "${YELLOW}No backup found. Performing clean uninstall...${RESET}"
        rm -f resources/scripts/xCBTheme.css resources/scripts/index.tsx
        yarn build:production || handle_error "Failed to rebuild default theme"
    fi
    
    echo -e "${GREEN}Theme uninstallation completed!${RESET}"
}

# Main menu
show_menu() {
    clear
    print_banner "xCBTheme Installer"
    echo "Copyright (C) 2024 conbert11"
    echo "The theme is free and can be modified"
    echo ""
    echo "1) Install xCBTheme"
    echo "2) Uninstall Theme"
    echo "3) Join Support Server (Discord)"
    echo "4) Exit"
    echo ""
}

# Main program
check_root

while true; do
    show_menu
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            read -p "Are you sure you want to install the theme? [y/N] " confirm
            [[ $confirm == [yY] ]] && install_theme
            ;;
        2)
            read -p "Are you sure you want to uninstall the theme? [y/N] " confirm
            [[ $confirm == [yY] ]] && uninstall_theme
            ;;
        3)
            echo "Support Server: https://dsc.gg/xcbtheme"
            read -p "Press Enter to continue..."
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option${RESET}"
            sleep 1
            ;;
    esac
done
