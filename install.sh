#!/bin/bash

# Constants for colored output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Check if the script is run as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}This script must be run as root.${RESET}"
        exit 1
    fi
}

# Error handling function
handle_error() {
    echo -e "${RED}Error: $1${RESET}"
    exit 1
}

# Function to back up the Pterodactyl installation
backup_pterodactyl() {
    echo -e "${BLUE}Creating backup of existing installation...${RESET}"
    if [ -d /var/www/pterodactyl ]; then
        cd /var/www/ || handle_error "Could not access /var/www/"
        tar -czf "pterodactyl_backup_$(date +%Y%m%d_%H%M%S).tar.gz" pterodactyl || handle_error "Backup failed."
        echo -e "${GREEN}Backup created successfully.${RESET}"
    else
        echo -e "${YELLOW}No existing installation found. Skipping backup.${RESET}"
    fi
}

# Main function to install the theme
install_theme() {
    clear
    print_banner "THEME INSTALLATION"
    
    # Install necessary dependencies
    echo -e "${BLUE}Installing dependencies...${RESET}"
    apt-get update -qq || handle_error "Failed to update package list."
    apt-get install -y sudo git curl || handle_error "Failed to install dependencies."

    # Backup existing installation
    backup_pterodactyl

    # Clone and set up the theme
    cd /var/www/pterodactyl || handle_error "Could not access the Pterodactyl directory."
    echo -e "${BLUE}Downloading theme...${RESET}"
    rm -rf xCBTheme
    git clone https://github.com/conbert11/xCBTheme.git || handle_error "Failed to clone the theme repository."
    
    # Remove old theme files if they exist
    echo -e "${BLUE}Cleaning old theme files...${RESET}"
    [ -f resources/scripts/xCBTheme.css ] && rm -f resources/scripts/xCBTheme.css
    [ -f resources/scripts/index.tsx ] && rm -f resources/scripts/index.tsx

    # Set up Node.js and Yarn
    echo -e "${BLUE}Setting up Node.js environment...${RESET}"
    export NVM_DIR="$HOME/.nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    source "$NVM_DIR/nvm.sh"
    nvm install 16 || handle_error "Failed to install Node.js."
    nvm use 16

    # Install Yarn and build the theme
    echo -e "${BLUE}Installing Yarn and building theme...${RESET}"
    npm install -g yarn || handle_error "Failed to install Yarn."
    yarn install || handle_error "Failed to install dependencies."
    yarn build:production || handle_error "Failed to build the theme."

    # Move theme files to the correct location
    cd xCBTheme || handle_error "Could not access theme directory."
    mv index.tsx ../resources/scripts/
    mv xCBTheme.css ../resources/scripts/

    # Clear Laravel cache
    echo -e "${BLUE}Clearing Laravel cache...${RESET}"
    php artisan optimize:clear || handle_error "Failed to clear Laravel cache."

    echo -e "${GREEN}Theme installation completed successfully!${RESET}"
    print_banner "INSTALLATION COMPLETE"
}

# Function to print a banner
print_banner() {
    local text="$1"
    echo ""
    echo "======================================"
    echo "   $text"
    echo "======================================"
    echo ""
}

# Function to uninstall the theme
uninstall_theme() {
    clear
    print_banner "THEME UNINSTALLATION"

    cd /var/www/pterodactyl || handle_error "Could not access Pterodactyl directory."

    # Restore from backup if available
    echo -e "${BLUE}Restoring from backup...${RESET}"
    local latest_backup
    latest_backup=$(ls -t /var/www/pterodactyl_backup_*.tar.gz 2>/dev/null | head -n1)
    if [ -n "$latest_backup" ]; then
        tar -xzf "$latest_backup" -C /var/www/ || handle_error "Failed to restore from backup."
        echo -e "${GREEN}Restored from backup: $latest_backup${RESET}"
    else
        echo -e "${YELLOW}No backup found. Removing theme files manually...${RESET}"
        [ -f resources/scripts/xCBTheme.css ] && rm -f resources/scripts/xCBTheme.css
        [ -f resources/scripts/index.tsx ] && rm -f resources/scripts/index.tsx
        yarn build:production || handle_error "Failed to rebuild the default theme."
    fi

    echo -e "${GREEN}Theme uninstallation completed successfully!${RESET}"
}

# Function to display the main menu
show_menu() {
    clear
    print_banner "xCBTheme Installer"
    echo "Copyright (C) 2024 conbert11"
    echo "The theme is free and can be modified."
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
    read -rp "Enter your choice (1-4): " choice
    
    case $choice in
        1)
            read -rp "Are you sure you want to install the theme? [y/N] " confirm
            [[ $confirm =~ ^[yY]$ ]] && install_theme
            ;;
        2)
            read -rp "Are you sure you want to uninstall the theme? [y/N] " confirm
            [[ $confirm =~ ^[yY]$ ]] && uninstall_theme
            ;;
        3)
            echo "Support Server: https://dsc.gg/xcbtheme"
            read -rp "Press Enter to continue..."
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option.${RESET}"
            sleep 1
            ;;
    esac
done
