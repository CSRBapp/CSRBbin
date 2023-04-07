#!/usr/bin/env bash

source $(dirname $0)/env.sh

echo -n "$*" | tr -d '\n' | ${MD5SUM} | cut -d ' ' -f 1 | tr '[:lower:]' '[:upper:]'

