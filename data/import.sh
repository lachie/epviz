#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

#rm -f imdb.db
#echo importing base data
#time sqlite3 -bail imdb.db < import.sql

echo creating other tables
time sqlite3 -bail imdb.db < post-import.sql 
