# vim: set noet ci pi sts=0 sw=4 ts=4 :
FROM golang:latest

RUN set -ex \
	&& mkdir -p $GOPATH/src/github.com/kubernetes && cd $_

RUN set -ex \
	&& cd $GOPATH/src/github.com/kubernetes \
	&& git clone https://github.com/kubernetes/kubernetes

RUN apt update && apt install -qqy rsync

RUN set -ex \
	&& cd $GOPATH/src/github.com/kubernetes/kubernetes \
	&& git checkout v1.9.9 \
	&& make kubectl

CMD ["tail", "-f", "/dev/null"]
