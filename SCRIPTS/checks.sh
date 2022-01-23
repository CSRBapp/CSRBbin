#!/usr/bin/env bash

if [ ! -v BINDIR ]
then
	echo "BINDIR not set"
	exit -1
fi

while [ ! -d "${STORAGE_PATH}" ]
do
	echo "STORAGE_PATH [$STORAGE_PATH] does not exist"
	read -s -p "Press ENTER to create it, or CTRL-C to abort..."
	mkdir -p "$STORAGE_PATH"
done

