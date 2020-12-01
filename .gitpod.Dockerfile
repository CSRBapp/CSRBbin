FROM node:current-buster

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian testing main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& apt-get -y update \
	&& apt-get -y -t testing install libleveldb-dev \
	&& apt-get -y -t experimental install libcrypto++-dev

