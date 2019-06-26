FROM php:7.4-rc-fpm-stretch

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN apt-get update; \
    apt-get full-upgrade -y; \
    apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        libevent-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmemcached-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libmagickwand-dev \
        libzip-dev \
        mariadb-client \
        unzip \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-configure ldap --with-libdir="lib/$("dpkg-architecture --query DEB_BUILD_MULTIARCH")"; \
    docker-php-ext-install \
        gd \
        ldap \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        sockets \
        zip \
    ; \
    pecl install APCu; \
    pecl install memcached; \
    pecl install imagick; \
    docker-php-ext-enable \
        apcu \
        imagick \
        memcached

COPY php.ini /usr/local/etc/php/conf.d/99-i-doit.ini

COPY php-fpm.ini /usr/local/etc/php-fpm.d/99-i-doit.conf

COPY entrypoint.sh is-installed.sh setup.sh /usr/local/bin/

COPY CHECKSUMS /var/www/html

VOLUME /var/www/html

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini; \
    mkdir -p /var/www/html

WORKDIR /var/www/html

ARG IDOIT_VERSION=1.13
ARG IDOIT_DOWNLOAD_URL=https://login.i-doit.com/downloads/idoit-open-${IDOIT_VERSION}.zip
ARG IDOIT_ZIP_FILE=idoit-${IDOIT_VERSION}.zip

RUN curl -fsSLO "${IDOIT_DOWNLOAD_URL}"; \
    sha256sum --strict --ignore-missing --check CHECKSUMS; \
    unzip -q "${IDOIT_ZIP_FILE}"; \
    rm "${IDOIT_ZIP_FILE}"; \
    rm CHECKSUMS; \
    chown www-data:www-data -R /var/www/html/; \
    find . -type d -name \* -exec chmod 775 {} \;; \
    find . -type f -exec chmod 664 {} \;; \
    chmod 774 ./*.sh setup/*.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
