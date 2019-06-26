# Getting started
There are plenty of postfix docker images out there, but none of them
stayed true to postfix itself.  They all had some sort of
startup script that was doing things in a way that was **special**, such as
env vars for setting up the container, or things of that nature.  If they
didn't do what you need, then you'd have to change their image.  Having
done a bit of postfix administration it was clear from the start this was
not the ideal way to go, as postfix itself has configuration mechanisms for
this purpose.

The quickest way to get going is to configure postfix the way you already
know and love (use **postconf**)...

```bash
# create a "postfix-vol" if one does not already exist
# see "docker volume ls" for a list of volumes
# If you do not wish to persist the configuration, remove the '-v' and it's
# parameter
docker run --rm --name mail -v postfix-vol:/etc/postfix/ trentonadams/postfix:latest
# for a simple relay...
docker exec -it mail postconf -e relayhost=192.168.1.1
# docker network allowed...
docker exec -it mail postconf -e mynetworks=172.10.1.0/16
docker exec -it mail postfix reload
```

# Cloud
Obviously some people are going to configure things in a **cloud**
ephemeral kind of way.  That may be aws ssm, kubernetes config maps, etc.  

My plan is to add an extension directory that accepts startup scripts that
do configuration on startup, which is the typical way you would implement
that.  But, for good form, make sure those scripts use **postconf** to do
the actual configuration bits.

# Thanks
Thanks to the following people for doing some of the work on getting me
started on supervisord, as well as running postfix in a container...

- I obtained some of the supervisord files from
  [juanluisbaptiste/docker-postfix](https://github.com/juanluisbaptiste/docker-postfix)
- I obtained the main supervisord file froma
  [dimovnike/alpine-supervisord](https://github.com/dimovnike/alpine-supervisord/blob/master/supervisord.conf)
  as it was simpler than the former, but adjusted it to work with the former supervisord files.

