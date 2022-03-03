FROM php:7.3-apache

MAINTAINER Vitor Costa <developer.vitorcosta5566@gmail.com>

# dependence 
RUN apt-get update -y \
	&& apt-get install git -yqq \
	&& apt-get install mariadb-client -yqq \
	&& apt-get install nano -yqq \
	&& apt-get install wget -yqq \
	&& apt-get install tar -yqq \
	&& apt-get install cron -yqq \
	&& apt-get install cron -yqq \
	&& apt-get install curl -yqq \
	&& apt-get install -yqq \
	libxml2-dev \
	libfreetype6-dev \
	libicu-dev \
  	libssl-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \
	libzip-dev \
	&& apt-get clean

# configure extensions
RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  	docker-php-ext-install \
  	opcache \
  	gd \
  	bcmath \
  	intl \
  	mbstring \
  	pdo_mysql \
  	soap \
  	xsl \
  	zip


RUN apt-get update \
  	&& apt-get install libpcre3 libpcre3 -yqq \
  	# php-pear \
  	&& pecl install oauth \

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install Mhsendmail

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

#ADD .docker/config/php.ini /usr/local/etc/php/php.ini
COPY .docker/config/php.ini /usr/local/etc/php/php.ini
ADD .docker/config/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html
