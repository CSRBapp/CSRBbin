FROM node:current-buster

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& bash -c "echo \"deb http://deb.debian.org/debian unstable main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& apt-get -y update \
	&& apt-get -y -t experimental install libcrypto++8 \
	&& apt-get -y -t unstable install libleveldb1d

#RUN echo "toor::0:666:toor:/root:/bin/bash" >> /etc/passwd
#RUN echo "toor:x:666:" >> /etc/group
#RUN echo 'toor:gitpod' | /usr/sbin/chpasswd

