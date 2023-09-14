FROM alpine:3.18

LABEL authors="Nicolas D. <nd@nidum.org> / Simon Baerlocher <s.baerlocher@sbaerlocher.ch>"

ARG PHP_VERSION=82

# Install packages
RUN apk --no-cache add \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-openssl \
    php${PHP_VERSION}-pdo \ 
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-pdo_pgsql \
    php${PHP_VERSION}-pdo_sqlite \
    php${PHP_VERSION}-pecl-imagick \
    php${PHP_VERSION}-pecl-redis \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlreader \
    php${PHP_VERSION}-xmlwriter \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-zlib \
    curl mysql-client git sqlite unzip wget tzdata xvfb nodejs npm imagemagick

# Install packages from edge for Laravel Dusk
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    chromium \
    chromium-chromedriver \
    nss \
    php${PHP_VERSION}-pecl-xdebug

# Symlink php
RUN [ ! -e /usr/bin/php ] && ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php || true


# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Configure PHP
COPY roots /

# phpunit
RUN wget --progress=dot:giga https://phar.phpunit.de/phpunit.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

CMD ["php-fpm"]
