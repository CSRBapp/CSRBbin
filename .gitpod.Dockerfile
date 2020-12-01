FROM node:current-buster

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& apt-get -y update \
	&& apt-get -y -t experimental install libcrypto++-dev

RUN echo 'root:gitpod' | /usr/sbin/chpasswd

RUN cp -a /bin/bash /toor && chmod ug+s /toor
