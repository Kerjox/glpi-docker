FROM php:8.1.14-apache-bullseye
ENV GLPI_VERSION 10.0.5

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

RUN \
  apt update \
  && apt install wget \
  && wget https://github.com/glpi-project/glpi/releases/download/$GLPI_VERSION/glpi-$GLPI_VERSION.tgz \
  && tar xvf glpi-$GLPI_VERSION.tgz -C /var/www/html/ \
  && rm glpi-$GLPI_VERSION.tgz

# Config GLPI

RUN \
  mkdir -p /data/log \
  && mkdir -p /data/plugins \
  && mkdir -p /data/marketplace \
  && rm -r /var/www/html/glpi/plugins \
  && ln -s /data/plugins /var/www/html/glpi/plugins \
  && rm -r /var/www/html/glpi/marketplace \
  && ln -s /data/marketplace /var/www/html/glpi/marketplace \
  && mv /var/www/html/glpi/config /data \
  && mv /var/www/html/glpi/files /data \
  && echo "<?php\n\t  define('GLPI_VAR_DIR', '/data/files');\n\t  define('GLPI_LOG_DIR', '/data/log');" > /data/config/local_define.php \
  && echo "<?php\n\tdefine('GLPI_CONFIG_DIR', '/data/config/');\n\tif (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {\n\t   require_once GLPI_CONFIG_DIR . '/local_define.php';\n\t}" > /var/www/html/glpi/inc/downstream.php \
  && echo "php_value session.cookie_httponly 1\n\tphp_value session.cookie_secure 1" >> /var/www/html/glpi/.htaccess \
  && chown -R www-data. /var/www/html/glpi \
  && chown -R www-data. /data

# Config apache2

COPY ./etc /etc
RUN \
  mkdir -p /data/log/apache \
  && chmod 600 /etc/apache2/ssl/ssl-cert-glpi.crt \
  && chmod 644 /etc/apache2/ssl/ssl-cert-glpi.key \
  && a2dissite 000-default.conf \
  && a2ensite glpi.conf \
  && a2enmod ssl proxy_http

COPY ./opt /opt
RUN chmod +x /opt/glpi_start.sh

VOLUME /data
EXPOSE 80
EXPOSE 443

CMD /opt/glpi_start.sh