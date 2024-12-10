FROM php:8.2-apache

USER root

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  zlib1g-dev \
  libzip-dev \
  libc-client2007e-dev \
  libc-client-dev \
  libkrb5-dev \
  libxml2-dev \
  libpng-dev \
  libldap-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  cron \
  git \
  sudo \
  wget \
  zip

RUN rm -r /var/lib/apt/lists/

### apache2 config
RUN sed -i 's/^ServerTokens OS/ServerTokens Prod/; s/^ServerSignature On/ServerSignature Off/' /etc/apache2/conf-enabled/security.conf
RUN sed -i '/DocumentRoot/a\\n        <Directory /var/www/html/www>\n          Options Indexes FollowSymLinks\n          AllowOverride All\n          Require all granted\n        </Directory>' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/www|' /etc/apache2/sites-available/000-default.conf

### change apache2 user and group
RUN sed -i 's|APACHE_RUN_USER:=www-data|APACHE_RUN_USER:=nobody|' /etc/apache2/envvars
RUN sed -i 's|APACHE_RUN_GROUP:=www-data|APACHE_RUN_GROUP:=nogroup|' /etc/apache2/envvars

# not working with bind mount
#RUN chown -R www-data:www-data /var/www/html

### PHP config
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap
RUN docker-php-ext-configure zip --with-zip && docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install soap
RUN docker-php-ext-install intl
RUN docker-php-ext-install ldap

RUN pecl install apcu-5.1.24
RUN docker-php-ext-enable apcu
RUN docker-php-ext-enable opcache

RUN cp -av /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
COPY conf/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Cronjob
#COPY conf/apache2/cron.txt /etc/cron.d/openxe
RUN echo '* * * * * sudo -u nobody /usr/local/bin/php -d memory_limit=512M /var/www/html/cronjobs/starter2.php > /proc/1/fd/1 2>/proc/1/fd/2' > /etc/cron.d/openxe
RUN chmod 0644 /etc/cron.d/openxe
RUN crontab /etc/cron.d/openxe
RUN ln -s /dev/stdout /var/log/cron

# Start cron and apache2 service
RUN sed -i 's/^exec /service cron start\n\nexec /' /usr/local/bin/apache2-foreground