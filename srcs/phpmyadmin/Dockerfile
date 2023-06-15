FROM alpine:latest

WORKDIR /var/www

RUN apk upgrade && apk add wget tar nginx php php7-fpm \
	php7-common php7-iconv php7-json php7-gd php7-curl php7-xml \
	php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql \
	php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext \
	php7-ldap php7-ctype php7-dom php7-session php7-mbstring 

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ && mkdir -p /etc/telegraf

RUN mkdir -p /run/nginx

RUN echo -e "passwd\npasswd" | adduser admin

RUN wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& tar -xzvf phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& rm phpMyAdmin-5.0.4-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.4-all-languages phpmyadmin \
    && mkdir -p /var/www/phpmyadmin/tmp/ \
	&& chmod 777 /var/www/phpmyadmin/tmp/

RUN mv phpmyadmin /var/www/

COPY srcs/telegraf.conf /etc/telegraf/

COPY srcs/config.inc.php /var/www/phpmyadmin/

COPY srcs/nginx.conf /etc/nginx/

COPY srcs/init_container.sh /var/www

EXPOSE 5000

CMD ["sh", "init_container.sh"]
