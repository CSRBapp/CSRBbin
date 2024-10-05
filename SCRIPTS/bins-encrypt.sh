#!/usr/bin/env bash

read -p "> " PASSWORD

if [ -z ${PASSWORD} ]
then
	echo PASSWORD IS EMPTY
	exit -1
fi

PASSWORDHASH=`echo -n ${PASSWORD} | sha512sum | awk '{ print $1 }'`

echo "PASSWORD: ${PASSWORD}"
echo "ENCRYPTION PASSWORD: ${PASSWORDHASH}"

LIBS=$(find . -maxdepth 1 -type f -name "*.so")
BINS="CSRBnode CSRBvfsFUSE"

for f in ${LIBS} ${BINS}
do
	echo "Encrypting ${f}"
	gzip -9 -c $f | openssl enc \
		-aes-256-cbc -md sha512 -pbkdf2 \
		-pass pass:${PASSWORDHASH} \
		-out $f.enc
done
