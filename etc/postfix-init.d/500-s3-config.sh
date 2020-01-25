#!/bin/sh

if [ ! -z "$s3_bucket" ]; then
    echo starting s3-config sync from bucket: $s3_bucket | logger
    aws s3 cp s3://$s3_bucket/postfix-conf.tar.gz /tmp/ 2>&1 || \
        { echo s3 copy failed | logger; exit 1; }
    tar -xvzf /tmp/postfix-conf.tar.gz -C / 2>&1 || \
        { echo tar extract of configuration files failed | logger; exit 2; }
    postfix reload
fi
