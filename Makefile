NAMESPACE = adenda

REPO = redis-rb-cluster-docker

VERSION = 0.2.0

.PHONY: all build tag_latest release

all: build

build:
	docker build -t $(NAMESPACE)/$(REPO):$(VERSION) .

tag_latest: build
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag by creating an official GitHub release."
