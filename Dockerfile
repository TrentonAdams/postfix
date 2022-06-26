#Dockerfile for a Postfix email relay service
FROM amazonlinux:2 AS prep

LABEL MAINTAINER Trenton D. Adams trenton daut d daut adams at gmail.com

RUN yum update -y \
  && yum -y install \
  python3-pip \
  postfix \
  rsyslog \
  awscli \
  tar \
  sysvinit-tools \
  && yum clean all \
  && rm -rf /var/cache/yum
RUN pip3.7 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U \
  && pip3.7 install supervisor 

RUN postconf -e "inet_interfaces=all"
# alpine postfix doesn't have utf8 support
#RUN postconf -# "smtputf8_enable=no"
RUN mkdir /var/log/supervisor

RUN newaliases
# Check every 1 minutes, if 5 retries occur (5- minute total outage), then fail.
HEALTHCHECK --interval=60s --timeout=60s --retries=5 CMD [ "/health.sh" ]
RUN ls /etc/postfix
RUN echo 'export $(strings /proc/1/environ | grep AWS_CONTAINER_CREDENTIALS_RELATIVE_URI)' >> /root/.profile

VOLUME /etc/postfix

COPY etc/ /etc/
ADD init.sh /
ADD health.sh /
ADD s3-config.sh /
ADD scripts/postfix-service.sh /

EXPOSE 25
CMD ["/init.sh"]
