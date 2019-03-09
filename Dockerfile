#
# Maintainer: Hadi Rasouli. 
#

FROM ubuntu-server
RUN apt-get install -y git zip

RUN apt-get install -y apache2 apache2-utils
RUN systemctl enable apache2
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils 
RUN apt-get purge php-pear -y
RUN apt-get install -f php-pear php7.2-dev -y
RUN apt-get install -y php7.2 libapache2-mod-php7.2 php7.2-mysql php-common php7.2-cli php7.2-common php7.2-json php7.2-opcache php7.2-readline -y
RUN apt-get install php7.2-mbstring
RUN a2enmod php7.2 
RUN a2dismod php7.2

RUN apt-get install nano

RUN curl -sS https://getcomposer.org/installer | php 
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
######################### install mcrypt #########################
RUN apt-get update -y && \
    apt-get install -y libmcrypt-dev && \
    pecl install mcrypt-1.0.1

ENV PHP_INI_DIR /etc/php/7.2/cli
RUN rm $PHP_INI_DIR/php.ini
COPY php.ini $PHP_INI_DIR/
RUN cat $PHP_INI_DIR/php.ini
##################################################################
ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR

RUN echo 'ServerName localhost' > /etc/apache2/conf-available/server-name.conf
RUN a2enconf server-name 
RUN  a2enmod php7.2
CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
