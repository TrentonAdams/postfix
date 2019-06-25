#Dockerfile for a Postfix email relay service
FROM dimovnike/alpine-supervisord

# borrowed from https://github.com/juanluisbaptiste/docker-postfix
# grab the supervisord files from
# https://github.com/juanluisbaptiste/docker-postfix

# alpine supervisord docker image base...
# https://github.com/dimovnike/alpine-supervisorda
# https://hub.docker.com/r/dimovnike/alpine-supervisord/
MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN apk add --no-cache postfix 
RUN postconf -e "inet_interfaces=all"

COPY run.sh /
RUN chmod +x /run.sh
RUN newaliases

EXPOSE 25
