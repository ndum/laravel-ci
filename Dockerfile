FROM alpine:3.13

LABEL authors="Nicolas D. <nd@nidum.org> / Simon Baerlocher <s.baerlocher@sbaerlocher.ch>"

# Install packages
RUN apk --no-cache add \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-exif \
    php8-fileinfo \
    php8-fpm \
    php8-gd \
    php8-iconv \
    php8-intl \
    php8-ldap \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-pdo \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-pecl-imagick \
    php8-pecl-redis \
    php8-phar \
    php8-tokenizer \
    php8-pgsql \
    php8-session \
    php8-simplexml \
    php8-soap \
    php8-sqlite3 \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-zip \
    php8-zlib \
    curl mysql-client git sqlite unzip wget tzdata xvfb nodejs npm imagemagick

# Install packages from edge for Laravel Dusk
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    chromium \
    chromium-chromedriver \
    nss \
    php8-pecl-xdebug

# Symlink php
RUN ln -s /usr/bin/php8 /usr/bin/php

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
