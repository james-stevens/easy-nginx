# (c) Copyright 2019-2022, JRCS Ltd ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.18

COPY apk/repositories apk/repositories.new /etc/apk/
COPY apk/github@jrcs.net-6630b66f.rsa.pub /etc/apk/keys/

RUN apk update
RUN apk upgrade

RUN apk add nginx
RUN apk add x-local-certs x-local-certs-update

RUN rm -r /run
RUN ln -s /dev/shm /run
RUN rmdir /tmp /var/lib/nginx/tmp /var/log/nginx
RUN ln -s /dev/shm /tmp
RUN ln -s /dev/shm /var/lib/nginx/tmp
RUN ln -s /dev/shm /var/log/nginx
RUN ln -s /dev/shm /run/nginx
RUN ln -s /run/nginx/ca /etc/nginx/ca
RUN ln -s /run/nginx/proxy.conf /etc/nginx/proxy.conf

COPY nginx /etc/nginx/

COPY root_crontab /etc/crontabs/root

COPY bin /usr/local/bin/
RUN ln -s /usr/local/bin/update_pems /etc/periodic/daily
COPY inittab /etc/inittab

RUN mkdir /opt/htdocs /opt/cgi-bin

RUN mv /etc/apk/repositories.new /etc/apk/repositories
RUN apk update

CMD [ "/sbin/init" ]
