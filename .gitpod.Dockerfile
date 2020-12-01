FROM gitpod/workspace-full

RUN \
	sudo bash -c 'echo "deb http://deb.debian.org/debian experimental main contrib non-free" > /etc/apt/sources.list.d/experimental.list' \
	&& sudo apt -y update \
	&& sudo apt -y -t experimental install libcrypto++8

