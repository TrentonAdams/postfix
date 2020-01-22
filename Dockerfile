#Dockerfile for a Postfix email relay service
FROM alpine:3.10 AS prep

LABEL MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN apk add --no-cache --upgrade supervisor \
  postfix \
  rsyslog \
  groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip

RUN postconf -e "inet_interfaces=all"
# alpine postfix doesn't have utf8 support
RUN postconf -e "smtputf8_enable=no"
COPY etc/ /etc/
RUN mkdir /var/log/supervisor

RUN newaliases

RUN ls /etc/postfix
VOLUME /etc/postfix

EXPOSE 25
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
