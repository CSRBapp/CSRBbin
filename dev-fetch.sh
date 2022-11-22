#!/bin/sh

wget -nv -m -nH -np -e robots=off --reject="index.html" --cut-dirs=1 https://public.csrb.app:32480/CSRBbin/

