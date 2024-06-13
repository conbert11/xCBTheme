#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    RESET='\033[0m'

    NODE_VERSION=$(node -v)
    REQUIRED_VERSION="v16.20.2"
    if [ "$NODE_VERSION" != "$REQUIRED_VERSION" ]; then
        echo -e "${GREEN}Node.js version is not ${YELLOW}${REQUIRED_VERSION}${GREEN}. Version: ${YELLOW}${NODE_VERSION}${RESET}"
        echo -e "${GREEN}Set version to ${YELLOW}v16.20.2${GREEN}... ${RESET}"
        sudo npm install -g n > /dev/null 2>&1
        sudo n 16 > /dev/null 2>&1
        node -v > /dev/null 2>&1
        npm -v > /dev/null  2>&1
        echo -e "${GREEN}Now the default version is ${YELLOW}${REQUIRED_VERSION}"
    else
        echo -e "${GREEN}Node.js Version is compatible: ${YELLOW}${NODE_VERSION} ${RESET}"
    fi
    echo -e "${GREEN}Installing ${YELLOW}sudo${GREEN} if not installed${RESET}"
    apt install sudo -y > /dev/null 2>&1
    cd /var/www/ > /dev/null 2>&1
    echo -e "${GREEN}Unpack the themebackup...${RESET}"
    tar -cvf xCBTheme_Themebackup.tar.gz pterodactyl > /dev/null 2>&1
    echo -e "${GREEN}Installing theme... ${RESET}"
    cd /var/www/pterodactyl > /dev/null 2>&1
    echo -e "${GREEN}Removing old theme if exist${RESET}"
    rm -r xCBTheme > /dev/null 2>&1
    echo -e "${GREEN}Download the Theme${RESET}"
    git clone https://github.com/conbert11/xCBTheme.git > /dev/null 2>&1
    cd xCBTheme > /dev/null 2>&1
    echo -e "${GREEN}Removing old theme resources if exist${RESET}"
    rm /var/www/pterodactyl/resources/scripts/xCBTheme.css > /dev/null 2>&1
    rm /var/www/pterodactyl/resources/scripts/index.tsx > /dev/null 2>&1
    echo -e "${GREEN}Moving the new theme files to directory${RESET}"
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx > /dev/null 2>&1
    mv xCBTheme.css /var/www/pterodactyl/resources/scripts/xCBTheme.css > /dev/null 2>&1
    cd /var/www/pterodactyl > /dev/null 2>&1
    echo -e "${GREEN}DOWNLOADING DONE!${RESET}"

    echo -e "${GREEN}Installing Node.js${RESET}"
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - > /dev/null 2>&1
    apt update > /dev/null 2>&1
    apt install -y nodejs > /dev/null 2>&1

    npm i -g yarn > /dev/null 2>&1
    yarn > /dev/null 2>&1

    cd /var/www/pterodactyl > /dev/null 2>&1
    echo -e "${GREEN}Rebuilding the Panel...${RESET}"
    yarn build:production > /dev/null 2>&1
    echo -e "${GREEN}Optimizing the Panel...${RESET}"
    sudo php artisan optimize:clear > /dev/null 2>&1


}

installThemeQuestion(){
    while true; do
        read -p "Are you sure that you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer (y) or (n)";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/conbert11/xCBTheme/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf xCBTheme_Themebackup.tar.gz
    rm xCBTheme_Themebackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "Copyright (C) 2024 Angelillo15 and NoPro200 and conbert11"
echo "This theme is free and can be modified"
echo ""
echo ""
echo "[1] Install xCBTheme"
echo "[2] Restore Backup"
echo "[3] Uninstall Theme"
echo "[exit] Exit theme Setup"

read -p "Please enter a number: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "exit" ]
    then
    exit
fi
