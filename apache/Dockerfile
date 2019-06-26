FROM debian:9-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN apt-get update; \
    apt-get full-upgrade -y; \
    apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-fcgid \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY i-doit.conf /etc/apache2/sites-available/

COPY entrypoint.sh /usr/local/bin/

VOLUME /var/www/html/

RUN a2dissite 000-default; \
    a2ensite i-doit; \
    a2enmod rewrite; \
    a2enmod alias; \
    a2dismod mpm_prefork; \
    a2enmod mpm_event; \
    a2enmod proxy; \
    a2enmod proxy_fcgi; \
    a2enmod setenvif

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
