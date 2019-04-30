FROM nginx:latest

RUN apt-get update && \
	apt-get -y install openssl && \
	openssl req \
	    -x509 \
	    -newkey rsa:2048 \
	    -keyout /etc/ssl/private/ssl-cert-snakeoil.key \
	    -out /etc/ssl/certs/ssl-cert-snakeoil.pem \
	    -days 1024 \
	    -nodes \
	    -subj /CN=localhost && \
	apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_* && \
    rm -rf /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/conf.d/default.conf && \
    mkdir /var/www && \
    mkdir /var/www/html && \
    chown -Rf www-data:www-data /var/www/html


COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/site/ /etc/nginx/conf.d/
COPY script/start.sh /usr/local/bin/start.sh

RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 443 80

STOPSIGNAL SIGTERM

CMD ["/usr/local/bin/start.sh"]