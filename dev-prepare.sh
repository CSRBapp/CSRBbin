#!/bin/bash

set -e

sudo apt update
sudo apt install git-restore-mtime
git restore-mtime || /usr/lib/git-core/git-restore-mtime
