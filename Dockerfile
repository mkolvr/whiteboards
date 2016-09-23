# We're using php5 since Alpine Linux's php7 is (as of this commit) on edge/testing.
FROM php:5-alpine

# The /run/apache2 directory is missing in the current apache2 package;
# this is a bug workaround. See:
# http://forum.alpinelinux.org/forum/general-discussion/cant-foreground-apache
RUN mkdir -p /opt/hello-php /run/apache2 

COPY assets /opt/hello-php/htdocs

RUN \
    # Upgrade old packages.
    apk --update upgrade && \
    # Ensure we have ca-certs installed.
    apk add --no-cache ca-certificates && \
    # Apache and PHP packages
    apk add apache2 php5-apache2

COPY httpd.conf /opt/hello-php/
COPY local.ini /etc/php5/conf.d/

# Run Apache in the foreground to work well with Docker and log collection.
CMD /usr/sbin/httpd -f /opt/hello-php/httpd.conf -D FOREGROUND

# You can test this Docker image locally by running:
#
#    $ docker build -t hello-php .
#    $ docker run --rm -it --expose 8081 -p 8081:8081 -e PORT=8081 hello-php
#
# and then visiting http://localhost:8081/ in your browser.
