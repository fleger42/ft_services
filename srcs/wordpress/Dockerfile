FROM alpine:latest

WORKDIR /var/www

RUN apk upgrade && apk add wget tar nginx php php7-common \
	php7-iconv php7-json php7-gd php7-curl php7-xml php7-opcache \
	php7-mysqli php7-imap php7-cgi php7-pdo php7-pdo_mysql \
	php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext \
	php7-ldap php7-ctype php7-dom php7-fpm \
	telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

RUN mkdir -p /run/nginx 

RUN echo -e "passwd\npasswd" | adduser admin

RUN mkdir -p /etc/telegraf

RUN wget http://wordpress.org/latest.tar.gz \
	&& tar -xzvf latest.tar.gz \
	&& rm latest.tar.gz \
	&& mv wordpress ./localhost/

COPY srcs/nginx.conf /etc/nginx/

COPY srcs/run_wordpress.sh /var/www/

COPY srcs/telegraf.conf /etc/telegraf/

COPY srcs/wp-config.php /var/www/localhost/wordpress/

EXPOSE 5050

CMD ["sh", "run_wordpress.sh"]
