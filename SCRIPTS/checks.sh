#!/usr/bin/env bash

if [ ! -v BINDIR ]
then
	echo "BINDIR is not set"
	exit -1
fi

if [ ! -d "$STORAGE_PATH" ]
then
	echo "STORAGE_PATH [$STORAGE_PATH] does not exist"
	exit -1
fi

