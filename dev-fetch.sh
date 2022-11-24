#!/bin/sh

wget --timestamp -nv -m -nH -np -e robots=off --reject="index.html" --cut-dirs=1 https://public.csrb.app:32480/CSRBbin/ 2>&1 | grep -v "index\.html\.tmp"

