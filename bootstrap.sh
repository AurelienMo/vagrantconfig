#!/usr/bin/env bash

# VARIABLES
DBPASSWD=root
DBNAME=applicationname
# Execute build machine virtual
main() {
    update_go
    apache_go
    php_go
    mysql_go
    tools_go
    nodenpm_go
    configure_go
    maildev_go
}

update_go() {
    sudo apt-add-repository ppa:ondrej/php
    sudo apt-get update
}

apache_go() {
    apt-get -y install apache2
    a2enmod rewrite
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    sed -i s/\${APACHE_RUN_USER}/vagrant/g /etc/apache2/apache2.conf
    sed -i s/\${APACHE_RUN_GROUP}/vagrant/g /etc/apache2/apache2.conf
    sed -i "s#DocumentRoot /var/www/html#DocumentRoot /var/www/html/web#g" /etc/apache2/sites-available/000-default.conf
}

mysql_go() {
    debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
    debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

    sudo apt-get -y install mysql-server
    sudo apt-get -y install mysql-client
    sudo apt-get -y install phpmyadmin

    mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS $DBNAME CHARACTER SET utf8 COLLATE utf8_general_ci;"
}

php_go() {
    sudo apt-get -y install php7.2
    sudo apt-get -y install libapache2-mod-php7.2
    sudo apt-get -y install php7.2-curl
    sudo apt-get -y install php7.2-gd
    sudo apt-get -y install php7.2-mysql
    sudo apt-get -y install php7.2-sqlite
    sudo apt-get -y install php7.2-mbstring
    sudo apt-get install -y php7.2-intl
    sudo apt-get install -y php7.2-xsl
    sudo apt-get install -y php7.2-xdebug
    sudo apt-get -y install php7.2-zip
    sudo apt-get -y install php7.2-opcache
    sudo apt-get -y install php-imagick
    sudo apt-get -y install jpegoptim
    sudo apt-get -y install ruby-sass
}

nodenpm_go() {
    sudo apt-get -y install nodejs build-essential
    sudo apt-get -y install npm
}

tools_go() {
    sudo apt-get -y install curl php7.2-cli acl unzip
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
}

configure_go() {
    if ! grep "cd /var/www/html" /home/vagrant/.bashrc ; then
        echo "cd /var/www/html" >> /home/vagrant/.bashrc
    fi
    cd /var/www/html
    sudo -u vagrant composer install
    sudo npm install
}

maildev_go() {
    sudo apt install -y nodejs-legacy
    npm install -g maildev
    maildev
}

main
exit 0
