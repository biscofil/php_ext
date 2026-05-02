# Set the base image for subsequent instructions
FROM php:8.4-apache

# Update packages
RUN apt-get -y update

RUN apt-get install -y --no-install-recommends apt-utils

# Install PHP and composer dependencies
RUN apt-get install --fix-missing -qq git curl libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev zip unzip libzip-dev zlib1g-dev libicu-dev g++ libxml2-dev libgmp-dev re2c libmhash-dev file

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-configure gd \
   --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# for phpunit timeout
RUN docker-php-ext-install pcntl

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install pdo_mysql zip

RUN pecl install xdebug-3.4.5 && docker-php-ext-enable xdebug

RUN pecl install pcov && docker-php-ext-enable pcov

RUN docker-php-ext-install soap

# gmp
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp
RUN docker-php-ext-install gmp

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite
RUN a2enmod ssl

RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# Set the working directory
WORKDIR /var/www/html
