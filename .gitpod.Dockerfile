FROM debian:testing

RUN touch /DOCKERFILERUN \
	&& bash -c "echo \"deb http://deb.debian.org/debian experimental main contrib non-free\" >> /etc/apt/sources.list.d/gitpod.list" \
	&& apt-get -y update \
	&& apt-get -y -t testing install python3 strace gdb clang-10 golang \
	&& apt-get -y -t testing install tmux netcat-openbsd procps net-tools curl wget lynx links \
	&& apt-get -y -t testing install libleveldb-dev libconfig++-dev \
	&& apt-get -y -t experimental install libcrypto++-dev

#RUN echo "toor::0:666:toor:/root:/bin/bash" >> /etc/passwd
#RUN echo "toor:x:666:" >> /etc/group
#RUN echo 'toor:gitpod' | /usr/sbin/chpasswd

