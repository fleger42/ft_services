FROM alpine:latest

WORKDIR /home

RUN apk update && apk add influxdb \
	&& mkdir -p /var/lib/influxdb

RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ && mkdir -p /etc/telegraf

RUN chown -R influxdb:influxdb /var/lib/influxdb

COPY srcs/init_container.sh /home/

COPY srcs/telegraf.conf /etc/telegraf/

VOLUME ["/var/lib/influxdb"]

EXPOSE 8086

CMD ["sh", "init_container.sh"]
