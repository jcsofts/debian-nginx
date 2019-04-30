#!/bin/bash

# Disable Strict Host checking for non interactive git clones

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
 sed -i "s#root   /var/www/html;#root   ${WEBROOT};#g" /etc/nginx/conf.d/default.conf
else
 webroot=/var/www/html
fi

#if [ ! -z "$DOMAIN" ]; then
# sed -i "s#server_name _;#server_name ${DOMAIN};#g" /etc/nginx/sites-available/default.conf
# sed -i "s#server_name _;#server_name ${DOMAIN};#g" /etc/nginx/sites-available/default-ssl.conf
#fi


# Prevent config files from being filled to infinity by force of stop and restart the container
#lastlinephpconf="$(grep "." /usr/local/etc/php-fpm.conf | tail -1)"
#if [[ $lastlinephpconf == *"php_flag[display_errors]"* ]]; then
# sed -i '$ d' /usr/local/etc/php-fpm.conf
#fi


# Do the same for SSL sites
if [ -f /etc/nginx/conf.d/default-ssl.conf ]; then
  if [ ! -z "$WEBROOT" ]; then
   sed -i "s#root   /var/www/html;#root   ${WEBROOT};#g" /etc/nginx/conf.d/default-ssl.conf
  fi
fi

if [ ! -z "$PUID" ]; then
  if [ -z "$PGID" ]; then
    PGID=${PUID}
  fi
  #deluser nginx
  addgroup -g ${PGID} nginx
  adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx -u ${PUID} nginx
else
  if [ -z "$SKIP_CHOWN" ]; then
    chown -Rf www-data:www-data /var/www/html
  fi
fi

# rm -rf /var/run/nginx.pid
# Start supervisord and services
exec nginx -g "daemon off;"

