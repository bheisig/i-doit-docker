# i-doit Docker images

Dockerized [i-doit CMDB](https://i-doit.com/)

## Not production-ready!

**The provided Docker images aren't production-ready. Please do not rely on them. They come "as is" with absolutely no warranty. They are not an official product by synetics GmbH. Therefore, we can't provide you any support.**

At the moment, we use these images for quality tests of i-doit and its add-ons. Maybe in the near-future we hope to provide you official i-doit Docker images which are well-tested and production-ready. In the meantime don't hesitate to test these images yourself. [We love to get your feedback!](https://github.com/bheisig/i-doit-docker/issues)

## Supported tags and respective `Dockerfile` links

-   `1.12.1-open-php7.0-apache` ([`Dockerfile`](1.12.1/open/php7.0/apache))
-   `1.12.1-open-php7.0-fpm` ([`Dockerfile`](1.12.1/open/php7.0/fpm))
-   `1.12.1-open-php7.1-apache` ([`Dockerfile`](1.12.1/open/php7.1/apache))
-   `1.12.1-open-php7.1-fpm` ([`Dockerfile`](1.12.1/open/php7.1/fpm))
-   `1.12.1-open-php7.2-apache` ([`Dockerfile`](1.12.1/open/php7.2/apache))
-   `1.12.1-open-php7.2-fpm` ([`Dockerfile`](1.12.1/open/php7.2/fpm))
-   `1.12.1-pro-php7.0-apache` ([`Dockerfile`](1.12.1/pro/php7.0/apache))
-   `1.12.1-pro-php7.0-fpm` ([`Dockerfile`](1.12.1/pro/php7.0/fpm))
-   `1.12.1-pro-php7.1-apache` ([`Dockerfile`](1.12.1/pro/php7.1/apache))
-   `1.12.1-pro-php7.1-fpm` ([`Dockerfile`](1.12.1/pro/php7.1/fpm))
-   `1.12.1-pro-php7.2-apache` ([`Dockerfile`](1.12.1/pro/php7.2/apache))
-   `1.12.1-pro-php7.2-fpm` ([`Dockerfile`](1.12.1/pro/php7.2/fpm))
-   `1.12.4-open-php7.0-apache` ([`Dockerfile`](1.12.4/open/php7.0/apache))
-   `1.12.4-open-php7.0-fpm` ([`Dockerfile`](1.12.4/open/php7.0/fpm))
-   `1.12.4-open-php7.1-apache` ([`Dockerfile`](1.12.4/open/php7.1/apache))
-   `1.12.4-open-php7.1-fpm` ([`Dockerfile`](1.12.4/open/php7.1/fpm))
-   `1.12.4-open-php7.2-apache` ([`Dockerfile`](1.12.4/open/php7.2/apache))
-   `1.12.4-open-php7.2-fpm` ([`Dockerfile`](1.12.4/open/php7.2/fpm))
-   `1.12.4-pro-php7.0-apache` ([`Dockerfile`](1.12.4/pro/php7.0/apache))
-   `1.12.4-pro-php7.0-fpm` ([`Dockerfile`](1.12.4/pro/php7.0/fpm))
-   `1.12.4-pro-php7.1-apache` ([`Dockerfile`](1.12.4/pro/php7.1/apache))
-   `1.12.4-pro-php7.1-fpm` ([`Dockerfile`](1.12.4/pro/php7.1/fpm))
-   `1.12.4-pro-php7.2-apache` ([`Dockerfile`](1.12.4/pro/php7.2/apache))
-   `1.12.4-pro-php7.2-fpm` ([`Dockerfile`](1.12.4/pro/php7.2/fpm))
-   `1.13-pro-php7.0-apache` ([`Dockerfile`](1.13/pro/php7.0/apache))
-   `1.13-pro-php7.0-fpm` ([`Dockerfile`](1.13/pro/php7.0/fpm))
-   `1.13-pro-php7.1-apache` ([`Dockerfile`](1.13/pro/php7.1/apache))
-   `1.13-pro-php7.1-fpm` ([`Dockerfile`](1.13/pro/php7.1/fpm))
-   `1.13-pro-php7.2-apache` ([`Dockerfile`](1.13/pro/php7.2/apache))
-   `1.13-pro-php7.2-fpm` ([`Dockerfile`](1.13/pro/php7.2/fpm))
-   `1.13-pro-php7.3-apache` ([`Dockerfile`](1.13/pro/php7.3/apache))
-   `1.13-pro-php7.3-fpm` ([`Dockerfile`](1.13/pro/php7.3/fpm))

## Quick reference

-   **Where to get help**:  
    [https://github.com/bheisig/i-doit-docker/issues](https://github.com/bheisig/i-doit-docker/issues)
-   **Where to file issues**:  
    [https://github.com/bheisig/i-doit-docker/issues](https://github.com/bheisig/i-doit-docker/issues)
-   **Maintained by**:  
    [Benjamin Heisig](https://benjamin.heisig.name/)
-   **Supported architectures**: x86_64
-   **Source of this description**:  
    [`README.md`](https://github.com/bheisig/i-doit-docker/blob/master/README.md)
-   **Supported Docker versions**:  
    [the latest release](https://github.com/docker/docker-ce/releases/latest) (down to 1.6 on a best-effort basis)

## What is i-doit?

i-doit is a configuration management database (CMDB), IT asset management (ITAM) and IT documentation tool

## How to use this image

Each image is build on the official PHP Docker image. We've got heavily inspired by the well-documented [Nextcloud docker image](https://github.com/nextcloud/docker).

### Run i-doit with Apache HTTPD

Run the latest version of i-doit pro with PHP 7.3 and Apache HTTPD 2.4:

~~~ {.bash}
docker run i-doit-apache -p 80:80 bheisig/idoit:1.13-pro-php7.3-apache
~~~

### Run i-doit with PHP-FPM

Run the latest version of i-doit pro with PHP 7.3 and FPM:

~~~ {.bash}
docker run i-doit-fpm -p 9000:9000 bheisig/idoit:1.13-pro-php7.3-fpm
~~~

### Run i-doit with Docker Compose

i-doit requires either MariaDB or MySQL as the database backend. Additionally, memcached is highly recommend. There are some examples:

-   [Run with Apache HTTPD](docker-compose-apache.yml)
-   [Run with PHP-FPM](docker-compose-fpm.yml)

### TLS/HTTPS

It is _strongly_ recommended to access i-doit in a productive environment only via TLS/HTTPS. The provided images do not terminate TLS/HTTPS connections. Therefore, you need an additional load balancer or similar.

## Image variants

`<version>-<edition>-<php>-<service>`

-   `<version>`: Which version of i-doit do you like to run? Omit to run the latest version.
-   `<edition>`: Which edition of i-doit do you like to run? Select `open` for community edition (Free Software) and `pro` for professional edition (proprietary). Omit to go `pro`.
-   `<php>`: Which version of [PHP](https://php.net/) do you like to run? Omit to run the latest stable version.
-   `<service>`: Decide to run i-doit either with [Apache HTTPD](https://httpd.apache.org/), [Nginx](https://nginx.org/) or [PHP-FPM](https://php-fpm.org/)

## Copyright & license

Copyright (C) 2019 [synetics GmbH](https://i-doit.com/)

Licensed under the [GNU Affero GPL version 3 or later (AGPLv3+)](https://gnu.org/licenses/agpl.html). This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.
