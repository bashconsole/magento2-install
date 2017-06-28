#!/bin/bash

#php-fpm

apt-get install \
    php-fpm \
    php-mysql \
    php-mcrypt \
    php-curl \
    php-cli \
    php-gd \
    php7.0-xsl \
    php-json \
    php-intl \
    php-pear \
    php-dev \
    php-common \
    php-soap \
    php-mbstring \
    php-zip \
    --yes

service php7.0-fpm restart


# nginx

apt-get install \
    nginx \
    --yes

service nginx restart

# composer

curl -sS https://getcomposer.org/installer | php;
mv composer.phar /usr/bin/composer


#basics

apt-get install \
    git \
    curl \
    unzip \
    --yes

