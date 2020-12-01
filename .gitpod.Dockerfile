FROM node:current-buster

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& apt-get -y update \
	&& apt-get -y -t experimental install libcrypto++-dev

#RUN echo "toor::0:0:toor:/root:/bin/bash" >> /etc/passwd
#RUN echo "toor:x:0:" >> /etc/group
#RUN echo 'toor:gitpod' | /usr/sbin/chpasswd

RUN echo "doptig::33333:33333::/home/gitpod:/bin/bash" >> /etc/passwd
RUN apt-get -y install sudo && adduser doptig sudo
