#!/usr/bin/env bash

read -p "> " PASSWORD
PASSWORDHASH=`echo -n ${PASSWORD} | sha512sum | awk '{ print $1 }'`

echo "PASSWORD: ${PASSWORD}"
echo "DECRYPTION PASSWORD: ${PASSWORDHASH}"

for libenc in *.so.enc
do
	lib=${libenc%.enc}
	echo "Decrypting ${lib}"
	openssl enc -d \
		-aes-256-cbc -md sha512 -pbkdf2 \
		-pass pass:${PASSWORDHASH} \
		-in $libenc | \
		gunzip -c > $lib
done
