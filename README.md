
```bash
# setup the initial volume with a proper relay configuration
docker run --rm -v postfix-vol:/etc/postfix/ --entrypoint postconf \
  trentonadams/postfix:latest -e relayhost=192.168.2.190


docker run --rm -v postfix-vol:/etc/postfix/ trentonadams/postfix:latest
```
