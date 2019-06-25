#Dockerfile for a Postfix email relay service
FROM alpine:3.10

# borrowed from https://github.com/juanluisbaptiste/docker-postfix
# grab the supervisord files from
# https://github.com/juanluisbaptiste/docker-postfix

# alpine supervisord docker image base...
# https://github.com/dimovnike/alpine-supervisorda
# https://hub.docker.com/r/dimovnike/alpine-supervisord/
MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN apk add --no-cache --upgrade supervisor postfix rsyslog && \
  rm  -rf /tmp/* /var/cache/apk/*
RUN postconf -e "inet_interfaces=all"
# alpine postfix doesn't have utf8 support
RUN postconf -e "smtputf8_enable=no"
COPY etc/ /etc/
RUN mkdir /var/log/supervisor

RUN newaliases

RUN ls /etc/postfix
VOLUME /etc/postfix

EXPOSE 25
ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
