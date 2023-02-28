#!/usr/bin/env bash

set -x
set -e

echo '
set bg=dark
set mouse=
' | sudo tee /etc/vim/vimrc.local >/dev/null

sudo apt update

sudo apt -y install net-tools tcpdump tmux netcat strace ncdu xattr iozone3 expect

sudo apt -y install debootstrap

sudo apt -y install fuse3
sudo sed -i "s/^#user_allow_other/user_allow_other/" /etc/fuse.conf

sudo apt -y install zfs-fuse
sudo service zfs-fuse --full-restart || true

