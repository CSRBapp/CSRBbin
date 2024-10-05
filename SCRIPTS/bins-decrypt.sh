#!/usr/bin/env bash

if [ -z "$1" ]
then
	read -p "> " PASSWORD
else
	PASSWORD="$1"
fi

if [ -z ${PASSWORD} ]
then
	echo PASSWORD IS EMPTY
	exit -1
fi

PASSWORDHASH=`echo -n ${PASSWORD} | sha512sum | awk '{ print $1 }'`

echo "PASSWORD: ${PASSWORD}"
echo "DECRYPTION PASSWORD: ${PASSWORDHASH}"

FILES=$(find . -maxdepth 1 -type f -name "*.enc")
if [ -z "$FILES" ]; then exit 0; fi

for ef in ${FILES}
do
	f=${ef%.enc}
	echo "Decrypting ${ef} -> ${f}"
	openssl enc -d \
		-aes-256-cbc -md sha512 -pbkdf2 \
		-pass pass:${PASSWORDHASH} \
		-in $ef | \
		gunzip -c > $f && chmod u+x $f
done
