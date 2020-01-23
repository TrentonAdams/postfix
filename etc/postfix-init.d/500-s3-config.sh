#!/bin/sh

if [ ! -z "$s3_bucket" ]; then
    echo starting s3-config sync from bucket: $s3_bucket | logger
    aws s3 cp s3://$s3_bucket/postfix-conf.tar.gz /tmp/ || \
        { echo s3 copy failed | logger; exit 1; }
    tar -xvzf /tmp/postfix-conf.tar.gz -C / || \
        { echo tar extract of configuration files failed | logger; exit 2; }
fi
