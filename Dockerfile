FROM php:7.3-apache

MAINTAINER Vitor Costa <developer.vitorcosta5566@gmail.com>

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libfreetype6-dev \
	libicu-dev \
  	libssl-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \
	apt-utils \
	mariadb-client \
	git \
	nano \
	wget \
	curl \
	unzip \
	tar \
	cron \
	bash-completion \
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
	&& echo "extension=oauth.so" > /usr/local/etc/php/conf.d/docker-php-ext-oauth.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Install Mhsendmail

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install golang-go \
   && mkdir /opt/go \
   && export GOPATH=/opt/go \
   && go get github.com/mailhog/mhsendmail

#ADD .docker/config/php.ini /usr/local/etc/php/php.ini
COPY .docker/config/php.ini /usr/local/etc/php/php.ini
COPY .docker/config/000-default.conf /etc/apache2/sites-available/000-default.conf
#ADD .docker/config/web.conf /etc/apache2/sites-available/web.conf

RUN chmod 777 -Rf /var/www /var/www/.* \
	&& chown -Rf www-data:www-data /var/www /var/www/.* \
	&& usermod -u 1000 www-data \
	&& chsh -s /bin/bash www-data\
	&& a2enmod rewrite \
	&& a2enmod headers

VOLUME /var/www/html
WORKDIR /var/www/html
