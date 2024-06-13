#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    NODE_VERSION=$(node -v)
    REQUIRED_VERSION="v16.20.2"
    if [ "$NODE_VERSION" != "$REQUIRED_VERSION" ]; then
        echo "Node.js version is not $REQUIRED_VERSION. version: $NODE_VERSION"
        echo "Set version to v16.20.2..."
        sudo npm install -g n
        sudo n 16
        node -v
        npm -v
    else
        echo "Node.js Version is compatible: $NODE_VERSION"
    fi
    apt install sudo -y
    cd /var/www/
    tar -cvf xCBTheme.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r xCBTheme
    git clone https://github.com/conbert11/xCBTheme.git
    cd Pterodactyl_Nightcore_Theme
    rm /var/www/pterodactyl/resources/scripts/xCBTheme.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv Pterodactyl_Nightcore_Theme.css /var/www/pterodactyl/resources/scripts/xCBTheme.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


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
echo "This program is free software: you can redistribute it and/or modify"
echo ""
echo ""
echo "[1] Install theme"
echo "[2] Restore backup"
echo "[3] Repair panel (use if you have an error in the theme installation)"
echo "[4] Exit"

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
if [ $choice == "4" ]
    then
    exit
fi
