#Dockerfile for a Postfix email relay service
FROM dimovnike/alpine-supervisord

# borrowed from https://github.com/juanluisbaptiste/docker-postfix
# grab the supervisord files from
# https://github.com/juanluisbaptiste/docker-postfix

# alpine supervisord docker image base...
# https://github.com/dimovnike/alpine-supervisorda
# https://hub.docker.com/r/dimovnike/alpine-supervisord/
MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN apk add --no-cache --upgrade postfix 
RUN postconf -e "inet_interfaces=all"
# alpine postfix doesn't have utf8 support
RUN postconf -e "smtputf8_enable=no"

RUN newaliases

EXPOSE 25
