FROM php:7.0.10-fpm-alpine

ENV BOOKSTACK_VERSION=0.11.1 \
    BOOKSTACK=BookStack \
    BOOKSTACK_HOME="/var/www/${BOOKSTACK}"

RUN apk add --no-cache wget ca-certificates 

RUN mkdir -p ${BOOKSTACK_HOME} \
   && cd /var/www && curl -sS https://getcomposer.org/installer | php \
   && mv /var/www/composer.phar /usr/local/bin/composer \
   && wget https://github.com/ssddanbrown/BookStack/archive/v${BOOKSTACK_VERSION}.tar.gz -O ${BOOKSTACK}.tar.gz \
   && tar -xf ${BOOKSTACK}.tar.gz && mv ${BOOKSTACK}-${BOOKSTACK_VERSION}/* ${BOOKSTACK_HOME} && rm ${BOOKSTACK}.tar.gz  \
   && cd ${BOOKSTACK_HOME} && composer install \
   && chown -R www-data:www-data ${BOOKSTACK_HOME} \
#   && apt-get -y autoremove \
#   && apt-get clean \
#   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/apache2/sites-enabled/000-*.conf

#COPY bookstack.conf /etc/apache2/sites-enabled/bookstack.conf
#RUN a2enmod rewrite

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
