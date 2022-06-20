FROM alpine:3.16

LABEL authors="Nicolas D. <nd@nidum.org> / Simon Baerlocher <s.baerlocher@sbaerlocher.ch>"

# Install packages
RUN apk --no-cache add \
    php81-ctype \
    php81-curl \
    php81-dom \
    php81-exif \
    php81-fileinfo \
    php81-fpm \
    php81-gd \
    php81-iconv \
    php81-intl \
    php81-ldap \
    php81-mbstring \
    php81-mysqli \
    php81-opcache \
    php81-openssl \
    php81-pdo \
    php81-pdo_mysql \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pecl-imagick \
    php81-pecl-redis \
    php81-phar \
    php81-tokenizer \
    php81-pgsql \
    php81-session \
    php81-simplexml \
    php81-soap \
    php81-sqlite3 \
    php81-xml \
    php81-xmlreader \
    php81-xmlwriter \
    php81-zip \
    php81-zlib \
    curl mysql-client git sqlite unzip wget tzdata xvfb nodejs npm imagemagick

# Install packages from edge for Laravel Dusk
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    chromium \
    chromium-chromedriver \
    nss \
    php81-pecl-xdebug

# Symlink php
# RUN ln -s /usr/bin/php8 /usr/bin/php

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Configure PHP
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# phpunit
RUN wget --progress=dot:giga https://phar.phpunit.de/phpunit.phar
RUN chmod +x phpunit.phar
RUN mv phpunit.phar /usr/local/bin/phpunit

CMD ["php-fpm"]
