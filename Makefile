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
########################################################################
# Default variables
########################################################################
-include .env
export
########################################################################

build:
	$(SUDO) $(DOCKER) build -t kubectl:latest .

.PHONY: copy
copy:
	$(SUDO) $(DOCKER) run -d kubectl:latest && \
	$(SUDO) $(DOCKER) cp $$($(SUDO) $(DOCKER) ps -q -f ancestor=kubectl:latest|head -1):/go/src/github.com/kubernetes/kubernetes/_output/local/go/bin/kubectl ./ && \
	$(SUDO) $(DOCKER) kill $$($(SUDO) $(DOCKER) ps -q -f ancestor=kubectl:latest|head -1)
