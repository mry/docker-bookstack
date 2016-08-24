FROM alpine:3.4

ENV BOOKSTACK_VERSION=0.11.1 \
    BOOKSTACK=BookStack \
    BOOKSTACK_HOME="/var/www/${BOOKSTACK}" \
    BOOKSTACK_BUILD_DIR="/etc/docker-bookstack"

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "@testing https://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk -U add --no-cache \
      php7@testing \
      apache2@testing \
      php7-apache2@testing \
      supervisor \
      curl \
      openssl \
      ca-certificates \
      tar \
      gzip \
      bzip2 \
      bash \
      php7@testing \
      php7-pdo@testing \
      php7-pdo_mysql@testing \
      php7-mbstring@testing \
      php7-openssl@testing \
      php7-json@testing \
      php7-phar@testing \
      php7-gd@testing \
      php7-zip@testing \
      php7-curl@testing \
      php7-dom@testing  \
      php7-pcntl@testing \
      php7-session@testing

RUN mkdir -p ${BOOKSTACK_HOME} \
   && ln -s /usr/bin/php7 /usr/bin/php \
   && cd /var/www && curl -sS https://getcomposer.org/installer | php \
   && mv /var/www/composer.phar /usr/local/bin/composer \
   && curl -sSL https://github.com/ssddanbrown/BookStack/archive/v${BOOKSTACK_VERSION}.tar.gz -o "${BOOKSTACK}.tar.gz" \
   && tar -xvf ${BOOKSTACK}.tar.gz \
   && mv ${BOOKSTACK}-${BOOKSTACK_VERSION}/* ${BOOKSTACK_HOME} \
   && rm ${BOOKSTACK}.tar.gz  \
   && cd ${BOOKSTACK_HOME} && composer install

RUN echo ${BOOKSTACK_HOME} && chown -R apache:apache ${BOOKSTACK_HOME}

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["./docker-entrypoint.sh"]
