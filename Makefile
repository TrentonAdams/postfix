
.PHONY: tag
tag:
	./tag

.PHONY: build
build:
	docker build -t trentonadams/postfix-docker:$$(cat .version) .
	docker tag trentonadams/postfix-docker:$$(cat .version) trentonadams/postfix-docker:latest

scan:
	docker scan trentonadams/postfix-docker:$$(cat .version)

push:

.PHONY: release
release: | tag build scan push
