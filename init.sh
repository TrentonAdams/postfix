#!/bin/sh

for initscript in /etc/postfix-init.d/*; do 
    $initscript || { echo $initscript failed; exit 1;}
done;
