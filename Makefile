DOCKER_IMAGE=$(notdir $(CURDIR))
GROUP_ID=$(shell id -g)
USERNAME=$(shell whoami)
USER_ID=$(shell id -u)

DOCKER_RUN_OPTS = \
    -h $(notdir $(CURDIR)) \
    -u $(USER_ID):$(GROUP_ID) \
    -v $(CURDIR):$(CURDIR) \
    -v $(CURDIR)/.git \
    -w $(CURDIR) \
    --rm


.PHONY: image bash claude

image:
	docker build --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID) --build-arg USERNAME=$(USERNAME) -t $(DOCKER_IMAGE) .

bash:
	docker run $(DOCKER_RUN_OPTS) -ti $(DOCKER_IMAGE) bash

claude:
	docker run $(DOCKER_RUN_OPTS) \
		-v $(HOME)/.claude:$(HOME)/.claude \
		-v $(HOME)/.claude.json:$(HOME)/.claude.json \
		-it \
		$(DOCKER_IMAGE) \
		claude
