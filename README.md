# Postfix Docker

## Changelog

- **1.3.0** - switch to amazonlinux:2
- **1.2.4** - add env variable apparently needed in AWS
- **1.2.3** - direct stderr to stdout so we can see errors
- **1.2.2** - fixed some critical breakages in the startup scripts
- **1.2.1** - documentation on postfix-init.d functionality
- **1.2.0** - added postfix-init.d extension directory
- **1.1.0** - added s3 config bucket pull functionality
- **1.0.0** - basic postfix running in alpine container with postconf style configuration.

## Getting started

There are plenty of postfix docker images out there, but none of them
stayed true to postfix itself. They all had some sort of
startup script that was doing things in a way that was **special**, such as
env vars for setting up the container, or things of that nature. If they
didn't do what you need, then you'd have to change their image. Having
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

That's the basics of proper postfix configuration, but ultimately you don't want to do that to a running container. Ultimately, we want containers to be completely ephemeral, so let's get started with the cloud configuration.

## Cloud

Obviously most people are going to configure things in a **cloud**
ephemeral kind of way. That may be aws ssm, kubernetes config maps, s3, etc.

### S3 Configuration

To start, I have added S3 configuration pull support. All you need is an S3 bucket, a postfix-conf.tar.gz in that bucket, some AWS credentials, and an s3_bucket env var passed to the run command.

```bash
docker run --rm -it --name mail \
    -v "/home/your-user/.aws/:/root/.aws/" \
    -e AWS_PROFILE=your-profile \
    -e s3_bucket=bucket-name \
    trentonadams/postfix:latest
```

### Configuration Modification

Let's say you have a project with your postfix configuration files in `etc/postfix`. You can safely maintain this directory by having postconf modify your configuration files; it helps avoid some mistakes. Let's see how that works.

```bash
docker run --rm \
    --name mail \
    -it \
    -v "$(pwd)/etc/postfix/:/etc/postfix/" \
    trentonadams/postfix-docker:latest \
    postconf -e mynetworks=172.17.0.0/16
```

You can also have it spit out warnings...

```bash
docker run --rm \
    --name mail \
    -it \
    -v "$(pwd)/etc/postfix/:/etc/postfix/" \
    trentonadams/postfix-docker:latest \
    postfix check
```

The **caveat** of this approach is that the config files are then owned by root and you have to chown them back to a regular user before committing to your project repository.

## Extension

You can extend base functionality by adding scripts to `/etc/postfix-init.d/` without having to extend the docker image in a new Dockerfile.

If using AWS it is recommended that you pull down extensions from your S3 bucket. Your `postfix-conf.tar.gz` is extracted to `/`, so you can package into `/etc/supervisor.d` or `/etc/postfix-init.d/` as you wish.

If you'd like another mechanism to add your extensions without extending the container, such as Google's Object storage, **please contribute a pull request**.

## Thanks

Thanks to the following people for doing some of the work on getting me
started on supervisord, as well as running postfix in a container...

- I obtained some of the supervisord files from
  [juanluisbaptiste/docker-postfix](https://github.com/juanluisbaptiste/docker-postfix)
- I obtained the main supervisord file from
  [dimovnike/alpine-supervisord](https://github.com/dimovnike/alpine-supervisord/blob/master/supervisord.conf) as it was simpler than the former, but adjusted it to work with the former supervisord files.
