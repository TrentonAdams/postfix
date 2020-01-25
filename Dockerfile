#Dockerfile for a Postfix email relay service
FROM alpine:3.10 AS prep

LABEL MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN apk add --no-cache --upgrade supervisor \
  postfix \
  rsyslog \
  moreutils \
  groff less python py-pip
RUN pip install awscli
RUN apk --purge -v del py-pip

RUN postconf -e "inet_interfaces=all"
# alpine postfix doesn't have utf8 support
RUN postconf -e "smtputf8_enable=no"
COPY etc/ /etc/
RUN mkdir /var/log/supervisor

RUN newaliases
# Check every 1 minutes, if 5 retries occur (5- minute total outage), then fail.
HEALTHCHECK --interval=60s --timeout=60s --retries=5 CMD [ "/health.sh" ]
RUN ls /etc/postfix
RUN echo 'export $(strings /proc/1/environ | grep AWS_CONTAINER_CREDENTIALS_RELATIVE_URI)' >> /root/.profile

VOLUME /etc/postfix

ADD init.sh /
ADD health.sh /

EXPOSE 25
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
