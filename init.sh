#!/bin/sh

# shell order is alpha numeric order.  Therefore if you would like to control the order of initialization then simply prefix a number such as 000 to your init script filename.
for initscript in /etc/postfix-init.d/*; do 
    $initscript || { echo $initscript failed | logger; exit 1;}
done;
