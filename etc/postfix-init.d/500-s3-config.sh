#!/bin/sh

if [ ! -z "$s3_bucket" ]; then
    echo starting s3-confog sync from bucket: $s3_bucket | logger
    aws s3 cp s3://$s3_bucket/postfix-conf.zip /tmp/ || \
        { echo s3 copy failed | logger; exit 1; }
    unzip /tmp/postfix-conf.zip -o -d / || \
        { echo unzip of configuration files failed | logger; exit 2; }
    postfix reload || \
        { echo postfix reload failed | logger; exit 3; }
fi