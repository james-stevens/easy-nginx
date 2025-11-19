# (c) Copyright 2019-2022, JRCS Ltd ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.22
RUN apk update
RUN apk upgrade

RUN apk add nginx

RUN rm -r /run
RUN ln -s /dev/shm /run
RUN rmdir /tmp /var/lib/nginx/tmp /var/log/nginx
RUN ln -s /dev/shm /tmp
RUN ln -s /dev/shm /var/lib/nginx/tmp
RUN ln -s /dev/shm /var/log/nginx
RUN ln -s /dev/shm /run/nginx
RUN ln -s /run/nginx/ca /etc/nginx/ca
RUN ln -s /run/nginx/proxy.conf /etc/nginx/proxy.conf

COPY nginx /usr/local/nginx
COPY root_crontab /etc/crontabs/root
COPY bin /usr/local/bin/
COPY inittab /etc/inittab

RUN mkdir /opt/htdocs /opt/cgi-bin

COPY build.txt /usr/local/etc/build.txt
CMD [ "/sbin/init" ]
