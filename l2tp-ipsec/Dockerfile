FROM hwdsl2/ipsec-vpn-server:latest

ARG DEBIAN_FRONTED=noninteractive

ENV BUILD_DEPS libnss3-dev libnspr4-dev pkg-config libpam0g-dev \
                 libcap-ng-dev libcap-ng-utils libselinux1-dev \
                 libcurl4-nss-dev flex bison gcc make \
                 perl-modules perl

RUN sed -i 's@security.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list \ 
    && sed -i 's@deb.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list \ 
    && apt-get update \
    && apt-get -y --no-install-recommends install  ${BUILD_DEPS} gettext-base \
    && wget -c ftp://ftp.freeradius.org/pub/freeradius/freeradius-client-1.1.7.tar.gz \
    && tar -zxvf freeradius-client-1.1.7.tar.gz \
    && cd freeradius-client-1.1.7 \
    && ./configure \
    && make && make install \
    && cd .. \
    && rm -rf freeradius-client-1.1.7 \
    && rm -rf freeradius-client-1.1.7.tar.gz \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoclean \
    && apt-get -y autoremove


WORKDIR /

ADD entrypoint.sh entrypoint.sh
ADD run.sh run.sh
ADD templates/radiusclient.conf.template radiusclient.conf.template
ADD templates/dictionary.template dictionary.template
ADD templates/servers.template servers.template
ADD templates/dictionary.microsoft.template dictionary.microsoft.template

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/run.sh"]
