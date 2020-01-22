# Getting started
There are plenty of postfix docker images out there, but none of them
stayed true to postfix itself.  They all had some sort of
startup script that was doing things in a way that was **special**, such as
env vars for setting up the container, or things of that nature.  If they
didn't do what you need, then you'd have to change their image.  Having
done a bit of postfix administration it was clear from the start this was
not the ideal way to go, as postfix itself has configuration mechanisms for
this purpose.

The quickest way to get and understanding of how things work is to configure postfix the way you already know and love (use **postconf**)...

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

That's the basics of proper postfix configuration, but ultimately you don't want to do that to a running container.  Ultimately, we want containers to be completely ephemeral, so let's get started with the cloud configuration.

## Cloud

Obviously most people are going to configure things in a **cloud**
ephemeral kind of way.  That may be aws ssm, kubernetes config maps, s3, etc.  

### S3 Configuration

To start, I have added S3 configuration pull support.  All you need is an S3 bucket, a postfix-conf.zip in that bucket, some AWS credentials, and an s3_bucket env var passed to the run command.

```bash
docker run --rm -it --name mail \
    -v "/home/your-user/.aws/:/root/.aws/" \
    -e AWS_PROFILE=your-profile \
    -e s3_bucket=bucket-name \
    trentonadams/postfix:latest
```

### Future Extension

My plan is to add an extension directory that accepts startup scripts that do configuration on startup, which is the typical way you would implement that.  It'll be kind of a conf.sh.d style of directory where any shell script in the directory will be ran in shell expansion order; alphabetical essentially.  But, for good form, make sure those scripts use **postconf** to do the actual configuration bits. **Feel free to implement and create a pull request for this feature! :D**

## Thanks

Thanks to the following people for doing some of the work on getting me
started on supervisord, as well as running postfix in a container...

- I obtained some of the supervisord files from
  [juanluisbaptiste/docker-postfix](https://github.com/juanluisbaptiste/docker-postfix)
- I obtained the main supervisord file froma
  [dimovnike/alpine-supervisord](https://github.com/dimovnike/alpine-supervisord/blob/master/supervisord.conf)
  as it was simpler than the former, but adjusted it to work with the former supervisord files.

