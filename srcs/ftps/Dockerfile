FROM alpine

WORKDIR /home

ARG minikube_ip

RUN apk update && apk add vsftpd openssl

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ && mkdir -p /etc/telegraf

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/certs/ftps-selfsigned.key \
	-out /etc/ssl/private/ftps-selfsigned.crt \
	-subj '/C=FR/ST=FRANCE/L=Paris/O=42/CN=42.fr'

RUN echo -e "user42\nuser42" | adduser user42

COPY srcs/init_container.sh /home/

COPY srcs/telegraf.conf /etc/telegraf/

COPY srcs/vsftpd.conf /etc/vsftpd/

RUN sed -i -e "s/setminikubeip/$minikube_ip/g" /etc/vsftpd/vsftpd.conf

EXPOSE 21 30000

CMD ["sh", "init_container.sh"]