FROM node:current-buster

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" > /etc/apt/sources.list.d/experimental.list" \
	&& apt-get -y update \
	&& apt-get -y -t experimental install libcrypto++8

