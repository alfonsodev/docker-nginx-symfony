FROM ubuntu
RUN apt-get update --fix-missing
RUN apt-get install -y openjdk-7-jre
RUN apt-get install -y ghostscript
RUN apt-get -y install git nginx nginx-extras php5-dev php5-fpm libpcre3-dev gcc make php5-mysql php5-curl php-apc
RUN mkdir /var/www
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php

RUN git clone https://github.com/mongodb/mongo-php-driver.git

RUN cd mongo-php-driver && phpize
RUN cd mongo-php-driver && ./configure
RUN cd mongo-php-driver && make
RUN cd mongo-php-driver && make install

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN echo 'extension=mongo.so' > /etc/php5/cli/conf.d/50-mongo.ini
RUN echo 'extension=mongo.so' > /etc/php5/fpm/conf.d/50-mongo.ini

ADD nginx.conf /etc/nginx/nginx.conf
ADD default /etc/nginx/sites-available/default
ADD default-ssl /etc/nginx/sites-enabled/default-ssl

ADD server.crt /etc/nginx/ssl/
ADD server.key /etc/nginx/ssl/

VOLUME ["/var/log/nginx"]

EXPOSE 80

CMD service php5-fpm start && nginx

