# Set the base image for subsequent instructions
FROM php:7.4-apache

# Update packages
RUN apt-get -y update

RUN apt-get install -y --no-install-recommends apt-utils

# Install PHP and composer dependencies
RUN apt-get install --fix-missing -qq git curl libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev zip unzip libzip-dev zlib1g-dev libicu-dev g++ libxml2-dev libgmp-dev re2c libmhash-dev file

RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

RUN docker-php-ext-configure gd \
   --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# for phpunit timeout
RUN docker-php-ext-install pcntl

RUN pecl install mcrypt-1.0.3 && docker-php-ext-enable mcrypt

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install pdo_mysql zip

RUN pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug

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

# Set the working directory
WORKDIR /var/www/html
