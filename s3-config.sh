#!/usr/bin/bash

echo "s3_bucket: $s3_bucket";
if [[ ! -z "$s3_bucket" ]]; then
    echo "attempting to download s3://$s3_bucket/postfix-conf.tar.gz" | logger
    aws s3 cp "s3://$s3_bucket/postfix-conf.tar.gz" /tmp/ 2>&1 || \
        { echo s3 copy failed | logger; exit 1; }
    tar -xvzf /tmp/postfix-conf.tar.gz -C / 2>&1 || \
        { echo tar extract of configuration files failed | logger; exit 2; }
fi
