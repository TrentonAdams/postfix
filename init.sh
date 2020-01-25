#!/bin/bash

# shell order is alpha numeric order.  Therefore if you would like to control the order of initialization then simply prefix a number such as 000 to your init script filename.
/s3-config.sh

for initscript in /etc/postfix-init.d/*; do 
    $initscript || { echo $initscript failed | logger; exit 1;}
done;

chown -R root:root /etc/postfix/
chmod -R go-rwx /etc/postfix/

supervisord --nodaemon --configuration /etc/supervisord.conf
