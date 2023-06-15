telegraf --config /etc/telegraf/telegraf.conf &
mkdir -p /run/nginx /etc/ssl/certs /etc/ssl/private
nginx -c /etc/nginx/nginx.conf