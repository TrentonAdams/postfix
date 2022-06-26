help:                                   ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: tag
tag:  ## tag a release in git
	./tag

.PHONY: build
build: ## build the docker image
	docker build -t trentonadams/postfix-docker:$$(cat .version) .
	docker tag trentonadams/postfix-docker:$$(cat .version) trentonadams/postfix-docker:latest

.PHONY: run
run: build ## run the docker image - depends on build
	docker run --rm --name mail -p 25:25 -v postfix-vol:/etc/postfix/ trentonadams/postfix-docker:latest

.PHONY: run-edit
run-edit: build  ## runs the docker image with bash so you can play - depends on build
	docker run --rm --name mail -it -p 25:25 -v postfix-vol:/etc/postfix/ trentonadams/postfix-docker:latest bash

.PHONY: shell
shell: ## shell into existing container
	docker exec -it mail sh -c 'yum update && yum install -y procps'
	docker exec -it mail bash

.PHONY: stop
stop:	## kills the container
	docker kill mail

.PHONY: scan
scan:  ## runs docker snyk scan.
	docker scan trentonadams/postfix-docker:$$(cat .version)

.PHONY: push
push:  ## pushes the tagged docker image
	docker push trentonadams/postfix-docker:$$(cat .version)
	docker push trentonadams/postfix-docker:latest

.PHONY: release
release: | tag build scan push ## fully releases a new version - depends on tag build scan push
