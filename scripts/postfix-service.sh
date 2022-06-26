#!/bin/bash

if ! /usr/sbin/postfix -v -c /etc/postfix status; then
  /usr/sbin/postfix -v -c /etc/postfix start
fi

sleep 1
while pidof master > /dev/null; do
  sleep 0.5
  echo -n '.'
done
exit 1 # let supervisord handle restarts