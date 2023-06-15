FROM alpine:latest

WORKDIR /var/www

RUN apk update && apk add nginx tar openssl telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
	&& mkdir -p /run/nginx && mkdir -p /etc/telegraf

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/certs/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj '/C=FR/ST=FRANCE/L=Paris/O=42/CN=42.fr'

RUN echo -e "passwd\npasswd" | adduser admin

COPY srcs/nginx.conf /etc/nginx

COPY srcs/telegraf.conf  /etc/telegraf/

COPY srcs/html_page/index.html /var/www/localhost

COPY srcs/html_page/image.jpg /var/www/localhost

COPY srcs/init_container.sh /var/www/

EXPOSE 80 443

CMD ["sh", "init_container.sh"]