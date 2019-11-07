# vim: set noet ci pi sts=0 sw=4 ts=4 :
# http://www.gnu.org/software/make/manual/make.html
# http://linuxlib.ru/prog/make_379_manual.html
########################################################################
SHELL := $(shell which bash)
DEBUG ?= 0

CURRENT_DIR ?= $(shell readlink -m $(CURDIR))

SUDO ?= sudo
DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose

## versions
## VERSION=GO_VERSION
## 1.15.5=1.12

VERSION ?= 1.15.5
GO_VERSION ?= 1.12
########################################################################
# Default variables
########################################################################
-include .env
export
########################################################################

build:
	$(SUDO) $(DOCKER) build \
		--build-arg VERSION=$(VERSION) \
		--build-arg GO_VERSION=$(GO_VERSION) \
		-f Dockerfile.kubernetes -t kubectl:$(VERSION) .

.PHONY: copy
copy:
	$(SUDO) $(DOCKER) run -d kubectl:$(VERSION) && \
	$(SUDO) $(DOCKER) cp $$($(SUDO) $(DOCKER) ps -q -f ancestor=kubectl:$(VERSION)|head -1):/go/src/github.com/kubernetes/kubernetes/_output/local/go/bin/kubectl ./ && \
	$(SUDO) $(DOCKER) kill $$($(SUDO) $(DOCKER) ps -q -f ancestor=kubectl:$(VERSION)|head -1)
