if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

repairPanel(){
    echo -e "${GREEN}Uninstalling xCBTheme...${RESET}"
cd /var/www/pterodactyl 2>&1

    php artisan down 2>&1

    rm -r /var/www/pterodactyl/resources 2>&1

    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache 2>&1

    composer install --no-dev --optimize-autoloader 2>&1

    php artisan view:clear 2>&1

    php artisan config:clear 2>&1

    php artisan migrate --seed --force 2>&1
 
    chown -R www-data:www-data /var/www/pterodactyl/* 2>&1

    php artisan queue:restart 2>&1

    php artisan up 2>&1

    echo "UNINSTALLING DONE!"

clear
bash <(curl https://raw.githubusercontent.com/conbert11/xCBTheme/main/install.sh)


}

while true; do
    read -p "Are you sure that you want to uninstall the theme [y/n]? " yn
    case $yn in
        [Yy]* ) repairPanel; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer (y) or (n)";;
    esac
done
