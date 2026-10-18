#!/bin/sh
set -eu

: "${nginx_port:?[entrypoint.01-nginx] nginx_port no está definida}"

envsubst '${nginx_port}' \
  < /etc/nginx/conf.d/test.local.conf.template \
  > /etc/nginx/conf.d/test.local.conf

exec /docker-entrypoint.sh "$@"
