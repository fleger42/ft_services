FROM alpine


RUN apk update
RUN apk add grafana --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community --allow-untrusted
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ && mkdir -p /etc/telegraf

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/etc/grafana/provisioning/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

RUN mkdir -p "$GF_PATHS_HOME" \
    && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
        "$GF_PATHS_PROVISIONING/dashboards" \
        "$GF_PATHS_PROVISIONING/notifiers" \
        "$GF_PATHS_LOGS" \
        "$GF_PATHS_PLUGINS" \
        "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME" "$GF_PATHS_LOGS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"


COPY srcs/init_container.sh .

COPY srcs/grafana.db /var/lib/grafana/grafana.db

COPY srcs/telegraf.conf /etc/telegraf/

RUN mv /usr/sbin/grafana-server /usr/share/grafana/

EXPOSE 3000

CMD sh init_container.sh
