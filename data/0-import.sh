#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

rm -f base.sqlite
echo importing base data
time sqlite3 -bail base.sqlite < 0-import.sql
