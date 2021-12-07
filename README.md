# i-doit Docker images

Dockerized [i-doit CMDB](https://i-doit.com/)

[![Stars](https://img.shields.io/docker/stars/bheisig/idoit.svg)](https://hub.docker.com/r/bheisig/idoit/)
[![Pulls](https://img.shields.io/docker/pulls/bheisig/idoit.svg)](https://hub.docker.com/r/bheisig/idoit/)
[![Image size](https://img.shields.io/docker/image-size/bheisig/idoit?sort=date)](https://hub.docker.com/r/bheisig/idoit/)
![Build status](https://github.com/i-doit/docs/actions/workflows/main.yml/badge.svg?branch=main)

## Not production-ready!

**The provided Docker images aren't production-ready. Please do not rely on them. They come "as is" with no warranty of any kind. They are not an official product by synetics GmbH. Because of this, we can't provide you any support.**

At the moment, we use these images for quality tests of i-doit and its add-ons. In the near-future we hope to provide you official i-doit Docker images which are well-tested and production-ready. In the meantime don't hesitate to test these images yourself. [We love to get your feedback!](https://github.com/bheisig/i-doit-docker/issues)

## Supported tags and respective `Dockerfile` links

-   `1.17.2-open-php7.4-fpm` ([`Dockerfile`](1.17.2/open/php7.4/fpm))
-   `1.17.2-open-php7.4-apache` ([`Dockerfile`](1.17.2/open/php7.4/apache))
-   `1.17.2-pro-php7.4-fpm` ([`Dockerfile`](1.17.2/pro/php7.4/fpm))
-   `1.17.2-pro-php7.4-apache` ([`Dockerfile`](1.17.2/pro/php7.4/apache))
-   `1.17.1-open-php7.4-fpm` ([`Dockerfile`](1.17.1/open/php7.4/fpm))
-   `1.17.1-open-php7.4-apache` ([`Dockerfile`](1.17.1/open/php7.4/apache))
-   `1.17.1-pro-php7.4-fpm` ([`Dockerfile`](1.17.1/pro/php7.4/fpm))
-   `1.17.1-pro-php7.4-apache` ([`Dockerfile`](1.17.1/pro/php7.4/apache))
-   `1.17-open-php7.4-fpm` ([`Dockerfile`](1.17/open/php7.4/fpm))
-   `1.17-open-php7.4-apache` ([`Dockerfile`](1.17/open/php7.4/apache))
-   `1.17-pro-php7.4-fpm` ([`Dockerfile`](1.17/pro/php7.4/fpm))
-   `1.17-pro-php7.4-apache` ([`Dockerfile`](1.17/pro/php7.4/apache))
-   `1.16.3-open-php7.4-fpm` ([`Dockerfile`](1.16.3/open/php7.4/fpm))
-   `1.16.3-open-php7.4-apache` ([`Dockerfile`](1.16.3/open/php7.4/apache))
-   `1.16.3-pro-php7.4-fpm` ([`Dockerfile`](1.16.3/pro/php7.4/fpm))
-   `1.16.3-pro-php7.4-apache` ([`Dockerfile`](1.16.3/pro/php7.4/apache))
-   `1.16.2-open-php7.4-fpm` ([`Dockerfile`](1.16.2/open/php7.4/fpm))
-   `1.16.2-open-php7.4-apache` ([`Dockerfile`](1.16.2/open/php7.4/apache))
-   `1.16.2-pro-php7.4-fpm` ([`Dockerfile`](1.16.2/pro/php7.4/fpm))
-   `1.16.2-pro-php7.4-apache` ([`Dockerfile`](1.16.2/pro/php7.4/apache))
-   `1.16.1-open-php7.4-fpm` ([`Dockerfile`](1.16.1/open/php7.4/fpm))
-   `1.16.1-open-php7.4-apache` ([`Dockerfile`](1.16.1/open/php7.4/apache))
-   `1.16.1-pro-php7.4-fpm` ([`Dockerfile`](1.16.1/pro/php7.4/fpm))
-   `1.16.1-pro-php7.4-apache` ([`Dockerfile`](1.16.1/pro/php7.4/apache))
-   `1.16-open-php7.4-fpm` ([`Dockerfile`](1.16/open/php7.4/fpm))
-   `1.16-open-php7.4-apache` ([`Dockerfile`](1.16/open/php7.4/apache))
-   `1.16-pro-php7.4-fpm` ([`Dockerfile`](1.16/pro/php7.4/fpm))
-   `1.16-pro-php7.4-apache` ([`Dockerfile`](1.16/pro/php7.4/apache))

**Note:** Older branches are not supported anymore but can still be found in the repository.

## Quick reference

-   **Where to get help**:
    [`https://github.com/bheisig/i-doit-docker/issues`](https://github.com/bheisig/i-doit-docker/issues)
-   **Where to file issues**:
    [`https://github.com/bheisig/i-doit-docker/issues`](https://github.com/bheisig/i-doit-docker/issues)
-   **Maintained by**:
    [Benjamin Heisig](https://benjamin.heisig.name/)
-   **Supported architectures**: x86_64
-   **Source of this description**:
    [`README.md`](https://github.com/bheisig/i-doit-docker/blob/master/README.md)
-   **Supported Docker versions**:
    [the latest release](https://github.com/docker/docker-ce/releases/latest) (down to 1.6 on a best-effort basis)

## What is i-doit?

i-doit ("I document IT") is a fully-featured Web application for CMDB (Configuration Management Databases), IT asset management (ITAM) and IT documentation. i-doit is maintained by the company synetics GmbH, located in Düsseldorf/Germany.

## How to use this image

Each image is built on the official PHP Docker image. We've got heavily inspired by the well-documented [Nextcloud docker image](https://github.com/nextcloud/docker). Thank you!

### Run i-doit with PHP-FPM (recommended)

Run the latest version of i-doit open with PHP 7.4 and FPM:

~~~ {.bash}
docker run --name i-doit-fpm -p 9000:9000 bheisig/idoit:1.17.2-open-php7.4-fpm
~~~

### Run i-doit with Apache HTTPD (legacy)

Run the latest version of i-doit open with PHP 7.4 and Apache HTTPD 2.4:

~~~ {.bash}
docker run --name i-doit-apache -p 80:80 bheisig/idoit:1.17.2-open-php7.4-apache
~~~

### Available volumes

Each i-doit container has one default volume containing the complete installation directory: `/var/www/html`. This directory includes the source code, cache files, uploaded files, installed add-ons, custom translation files, etc.

### Run i-doit with Docker Compose

i-doit requires either MariaDB or MySQL as the database backend. For better performance Memcached is highly recommended. There are some examples:

-   [Run with PHP-FPM](docker-compose-fpm.yml) (preferred)
-   [Run with PHP-FPM over UNIX sockets](docker-compose-sockets.yml) (even faster)
-   [Run with Apache HTTPD](docker-compose-apache.yml) (legacy)

### Run i-doit CLI tool

i-doit has its own CLI tool named `console.php` for long-lasting, recurring tasks in background. You can call any CLI command in the running Docker container, for example:

~~~ {.bash}
docker exec -it --user www-data i-doit-fpm php console.php --help
~~~

### Update i-doit

_to be defined_

### Backup and restore

For a complete backup and restore process you need to consider at least 3 sources:

1.  i-doit installation directory (see section "Available volumes")
2.  System database (default: `idoit_system`)
3.  Each tenant database (default 1st one: `idoit_data`)

As you can see in the examples for `docker-compose` (see section "Run i-doit with Docker Compose") the simplest thing is to backup the named volumes. But for a running instance of MariaDB this is a bad solution because everything stored temporarily in memory won't be backed up. Run `mysqldump` (for backup) and `mysql` (for restore) to fetch every bit stored in the databases.

This is a basic example to backup everything in a running environment:

~~~ {.bash}
docker exec i-doit-fpm /bin/tar cvf - . | gzip -9 > backup.tar.gz
docker exec i-doit-fpm /usr/bin/mysqldump -uidoit -pidoit --all-databases | gzip -9 > backup.sql.gz
~~~

This is a basic example to restore those backups:

~~~ {.bash}
cat backup.tar.gz | docker exec --interactive --user www-data i-doit-fpm /bin/tar xzvf -
gunzip < backup.sql.gz | docker exec --interactive i-doit-fpm /usr/bin/mysql -uidoit -pidoit
~~~

Don't forget to alter the commands above to your needs.

### Add a subscription license

Copy the file to the running i-doit container and import the file with the i-doit CLI tool:

~~~ {.bash}
docker cp license.txt i-doit-fpm:/tmp/
docker exec --interactive --user www-data i-doit-fpm php \
    console.php license-add \
    --user admin --password admin --no-interaction --license /tmp/license.txt
~~~

### Move your CMDB data to a container

The next example assumes that i-doit is installed on the same host as the running i-doit container:

~~~ {.bash}
cd /var/www/html/
tar czvf - . | docker exec --interactive --user www-data i-doit-fpm /bin/tar xzvf -
mysqldump -uidoit -pidoit --all-databases | \
    docker exec --interactive i-doit-fpm /usr/bin/mysql -uidoit -pidoit
~~~

### TLS/HTTPS

We _strongly_ recommend to access i-doit in a productive environment via TLS/HTTPS. Consider to use a load balancer or reverse proxy because the provided images are unable to handle TLS/HTTPS connections themselves.

## Image variants

`<version>-<edition>-<php>-<service>`

-   `<version>`: Which version of i-doit do you like to run?
-   `<edition>`: Which edition of i-doit do you like to run? Select `open` for community edition (Free Software) and `pro` for professional edition (proprietary).
-   `<php>`: Which version of [PHP](https://php.net/) do you like to run?
-   `<service>`: Decide to run i-doit either with [Apache HTTPD](https://httpd.apache.org/) or [PHP-FPM](https://php-fpm.org/)

## Copyright & license

Copyright (C) 2019-2021 [synetics GmbH](https://i-doit.com/)

Licensed under the [GNU Affero GPL version 3 or later (`AGPLv3+`)](https://gnu.org/licenses/agpl.html)
