/#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    clear

echo ""
echo "
████████╗██╗  ██╗███████╗███╗   ███╗███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗ 
╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝ 
   ██║   ███████║█████╗  ██╔████╔██║█████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗
   ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║
   ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝
   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                                                                                                                            "
echo ""
echo "Made by conbert11"
echo "THEME IS INSTALLING NOW! PLEASE WAIT A LITTLE BIT."
echo ""
echo ""
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    MAGENTA='\033[0;35m'
    CYAN='\033[0;36m'
    RESET='\033[0m'

    echo -e "${BLUE}Installing ${YELLOW}sudo${BLUE} if not installed${RESET}"
    apt install sudo -y > /dev/null 2>&1
    cd /var/www/ > /dev/null 2>&1
    echo -e "${BLUE}Unpacking xCBthemeBackup...${RESET}"
    tar -cvf xCBTheme_Themebackup.tar.gz pterodactyl > /dev/null 2>&1
    echo -e "${BLUE}Installing xCBtheme... ${RESET}"
    cd /var/www/pterodactyl > /dev/null 2>&1
    echo -e "${BLUE}Download the xCBtheme...${RESET}"
    git clone https://github.com/conbert11/xCBTheme.git > /dev/null 2>&1
    cd xCBTheme > /dev/null 2>&1
    echo -e "${BLUE}Removing old xCBTheme resources/themes if exist... ${RESET}"
    rm /var/www/pterodactyl/resources/scripts/xCBTheme.css > /dev/null 2>&1
    rm /var/www/pterodactyl/resources/scripts/index.tsx > /dev/null 2>&1
    rm -r xCBTheme > /dev/null 2>&1
    echo -e "${BLUE}Adjust xCBTheme panel...${RESET}"
    yarn build:production > /dev/null 2>&1
    sudo php artisan optimize:clear > /dev/null 2>&1
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx > /dev/null 2>&1
    mv xCBTheme.css /var/www/pterodactyl/resources/scripts/xCBTheme.css > /dev/null 2>&1
    cd /var/www/pterodactyl > /dev/null 2>&1

    echo -e "${BLUE}Install required Stuff...${RESET}"
    curl -fsSL https://fnm.vercel.app/install | bash - > /dev/null 2>&1
    source ~/.bashrc > /dev/null 2>&1
    fnm use --install-if-missing 22 > /dev/null 2>&1

    npm i -g yarn > /dev/null 2>&1
    yarn > /dev/null 2>&1

    cd /var/www/pterodactyl > /dev/null 2>&1

    echo "DONE!"

    clear
    downloaddone
    


}

downloaddone(){
    echo ""
    echo "
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗     ██████╗  ██████╗ ███╗   ██╗███████╗
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝     ██╔══██╗██╔═══██╗████╗  ██║██╔════╝
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗    ██║  ██║██║   ██║██╔██╗ ██║█████╗  
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║    ██║  ██║██║   ██║██║╚██╗██║██╔══╝  
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝    ██████╔╝╚██████╔╝██║ ╚████║███████╗
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝                                                                                                               
    "
echo "Made by conbert11"
echo "YOUR INSTALLING IS NOW DONE! HAVE FUN WITH YOUR NEW THEME."
echo ""
echo "[exit] Exit setup"
read -p "Please enter: " choice
if [ $choice == "exit" ]
    then
    clear
    exitt

fi
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

exitt(){
        while true; do
        read -p "Do you want to leave the setup? [y/n] " yn
        case $yn in
            [Yy]* ) clear; exit;;
            [Nn]* ) clear; bash <(curl https://raw.githubusercontent.com/conbert11/xCBTheme/main/install.sh);; 
            * ) echo "Please answer (y) or (n)";;
        esac
    done
}

supportserver(){
    echo "Support-Server: https://dsc.gg/xcbtheme"
}

echo ""
echo ""
echo "
 ██████╗██████╗    ████████╗██╗  ██╗███████╗███╗   ███╗███████╗███████╗
██╔════╝██╔══██╗   ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝██╔════╝
██║     ██████╔╝█████╗██║   ███████║█████╗  ██╔████╔██║█████╗  ███████╗
██║     ██╔══██╗╚════╝██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  ╚════██║
╚██████╗██████╔╝      ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗███████║
 ╚═════╝╚═════╝       ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚══════╝
                                                                    "
echo ""
echo "Copyright (C) 2024 conbert11"
echo "The theme is free and can be modified"
echo ""
echo ""
echo "[1] Install xCBTheme"
echo "[2] Uninstall Theme"
echo "[3] Support Server (DISCORD)"
echo "[exit] Exit setup"

read -p "Please enter: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    repair
fi
if [ $choice == "2" ]
    then
    supportserver
fi
if [ $choice == "exit" ]
    then
    exitt

fi
