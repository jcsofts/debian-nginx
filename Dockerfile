FROM debian:stretch-slim

RUN echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list && \
	apt-get update && \
	apt-get -y install nginx openssl && \
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
    rm -rf /etc/nginx/sites-enabled/default && \
    rm -rf /etc/nginx/sites-available/default

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/site/ /etc/nginx/sites-available/
COPY script/start.sh /usr/local/bin/start.sh

RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf && \
	ln -s /etc/nginx/sites-available/default-ssl.conf /etc/nginx/sites-enabled/default-ssl.conf && \
	chmod 755 /usr/local/bin/start.sh

EXPOSE 443 80

STOPSIGNAL SIGTERM

CMD ["/usr/local/bin/start.sh"]