#!/usr/bin/env bash

read -p "> " PASSWORD
PASSWORDHASH=`echo -n ${PASSWORD} | sha512sum | awk '{ print $1 }'`

echo "PASSWORD: ${PASSWORD}"
echo "ENCRYPTION PASSWORD: ${PASSWORDHASH}"

for lib in *.so
do
	echo "Encrypting ${lib}"
	gzip -9 -c $lib | openssl enc \
		-aes-256-cbc -md sha512 -pbkdf2 \
		-pass pass:${PASSWORDHASH} \
		-out $lib.enc
done
