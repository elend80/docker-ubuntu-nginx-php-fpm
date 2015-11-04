FROM ubuntu:trusty
MAINTAINER "Youngho Byun (echoes)" <elend80@gmail.com>

ENV TERM xterm

RUN echo Asia/Seoul | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update
#RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y nano wget dialog net-tools curl git supervisor

# NGINX Install

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" > /etc/apt/sources.list.d/nginx.list
RUN apt-get update && \
    apt-get install -y nginx

RUN apt-get install -y php5-fpm

ADD www.conf /etc/php5/fpm/pool.d/www.conf

ADD default /etc/nginx/sites-available/default

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chown root:root /etc/supervisor/conf.d/supervisord.conf

RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]
