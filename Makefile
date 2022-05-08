
.PHONY: tag
tag:
	./tag

.PHONY: build
build:
	docker build -t trentonadams/postfix-docker:$$(cat .version) .
	docker tag trentonadams/postfix-docker:$$(cat .version) trentonadams/postfix-docker:latest

.PHONY: scan
scan:
	docker scan trentonadams/postfix-docker:$$(cat .version)

.PHONY: push
push:
	docker push trentonadams/postfix-docker:$$(cat .version)
	docker push trentonadams/postfix-docker:latest

.PHONY: release
release: | tag build scan push
