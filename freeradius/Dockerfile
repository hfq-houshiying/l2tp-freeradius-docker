FROM ubuntu:trusty

ARG DEBIAN_FRONTED=noninteractive

RUN sed -i 's@archive.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list \ 
    && sed -i 's@security.ubuntu.com@mirrors.aliyun.com@g' /etc/apt/sources.list \ 
    && apt-get update \
    && apt-get -y --no-install-recommends install \
           freeradius freeradius-mysql freeradius-utils \
           gettext-base mariadb-client-core-5.5 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoclean \
    && apt-get -y autoremove

ADD  templates/clients.conf.template  clients.conf.template
ADD  templates/radiusd.conf.template  radiusd.conf.template
ADD  templates/users.template  users.template
ADD  templates/radiusd.conf.template  radiusd.conf.template
ADD  templates/sql.conf.template  sql.conf.template
ADD  templates/inner-tunnel.template inner-tunnel.template
ADD  templates/default.template  default.template
ADD  entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD /usr/sbin/freeradius -X
