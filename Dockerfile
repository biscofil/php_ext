# Set the base image for subsequent instructions
FROM php:7.3-apache

# Update packages
RUN apt-get update

RUN apt-get install -y --no-install-recommends apt-utils

# Install PHP and composer dependencies
RUN apt-get install --fix-missing -qq git curl libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev zip unzip
# sendmail

#for php 7.3+
RUN apt-get install -qq libzip-dev

RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

#for php 7.3
RUN docker-php-ext-configure gd \
  --with-gd \
  --with-jpeg-dir \
  --with-png-dir \
  --with-zlib-dir
RUN docker-php-ext-install gd

#for php 7.4
#RUN docker-php-ext-configure gd \
#    --with-jpeg=/usr/include/

#RUN docker-php-ext-install gd

# for phpunit timeout
RUN docker-php-ext-install pcntl

# Clear out the local repository of retrieved package files
RUN apt-get clean

#for php 7.2
#RUN pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt

#for php 7.3
RUN pecl install mcrypt-1.0.2 && docker-php-ext-enable mcrypt

#for php 7.4
#RUN pecl install mcrypt-1.0.3 && docker-php-ext-enable mcrypt

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install pdo_mysql zip

# Install xdebug 3.1.6 for php 7.3
RUN pecl install xdebug-3.1.6 && docker-php-ext-enable xdebug

RUN pecl install pcov && docker-php-ext-enable pcov

RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite
RUN a2enmod ssl

# Set the working directory
WORKDIR /var/www/html
