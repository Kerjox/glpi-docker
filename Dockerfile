FROM php:8.1.14-apache-bullseye
ENV GLPI_VERSION 10.0.5
ENV MARIADB_HOST mariadb
ENV MARIADB_PORT 3306
ENV MARIADB_USER glpi_user
ENV MARIADB_PASSWORD glpi
ENV MARIADB_DATABASE glpi

# Install PHP externsions for GLPI
RUN  --mount=type=bind,from=mlocati/php-extension-installer:1.5,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
      install-php-extensions \
        curl \
        fileinfo \
        gd \
        json \
        mbstring \
        mysqli \
        session \
        zlib \
        simplexml \
        xml \
        intl \
        ldap \
        openssl \
        xmlrpc \
        APCu \
        zip \
        bz2 \
        exif \
        opcache

# Install GLPI

COPY ./data /data
RUN \
  apt update \
  && apt install wget \
  && wget https://github.com/glpi-project/glpi/releases/download/$GLPI_VERSION/glpi-$GLPI_VERSION.tgz \
  && tar xvf glpi-$GLPI_VERSION.tgz -C /var/www/html/ \
  && rm glpi-$GLPI_VERSION.tgz \
  && chown -R www-data:www-data /var/www/html/ \
  && mkdir -p /data/log \
  && mkdir -p /data/glpi \
  && cp -r /var/www/html/glpi/config /data \
  && cp -r /var/www/html/glpi/files/* /data/glpi \
  && rm -r /var/www/html/glpi/files \
  && mv /data/config/config_db.php /data/config/config_db.php.bak \
  && echo "<?php\n\tdefine('GLPI_CONFIG_DIR', '/data/config/');\n\tif (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {\n\t   require_once GLPI_CONFIG_DIR . '/local_define.php';\n\t}" > /var/www/html/glpi/inc/downstream.php \
  && chown -R www-data:www-data /data \
  && echo "php_value session.cookie_httponly 1\n\tphp_value session.cookie_secure 1" >> /var/www/html/glpi/.htaccess

# Config apache2

COPY ./etc /etc
RUN \
  chmod 600 /etc/ssl/certs/ssl-cert-glpi.crt \
  && chmod 644 /etc/ssl/private/ssl-cert-glpi.key \
  && a2dissite 000-default.conf \
  && a2ensite glpi.conf \
  && a2enmod ssl

COPY ./opt /opt
RUN chmod +x /opt/glpi_start.sh

VOLUME /data
EXPOSE 80
EXPOSE 443

CMD /opt/glpi_start.sh