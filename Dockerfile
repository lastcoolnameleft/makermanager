FROM php:7-apache
MAINTAINER infrastructure@dallasmakerspace.org

ARG FWATCHDOG_VERSION=0.7.1

EXPOSE 80

#HEALTHCHECK --interval=5s CMD 'curl -sSlk http://localhost/'


RUN apt-get update

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        libonig-dev \
        g++ \
        git \
        unzip \
        libldap2-dev

RUN a2enmod rewrite

RUN pecl install mcrypt

RUN curl -sL https://github.com/openfaas/faas/releases/download/${FWATCHDOG_VERSION}/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog

# https://stackoverflow.com/questions/40136304/laradock-how-to-enable-install-php7-ldap-support-extension
RUN docker-php-ext-configure intl \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install -j$(nproc) iconv intl pdo pdo_mysql \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap

WORKDIR /var/www/html

COPY . /var/www/html/

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '8a6138e2a05a8c28539c9f0fb361159823655d7ad2deecb371b04a83966c61223adc522b0189079e3e9e277cd72b8897') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php ./composer-setup.php \
    && php -r "unlink('composer-setup.php');"

RUN php composer.phar install

RUN chown -R 33:33 /var/www/html/
