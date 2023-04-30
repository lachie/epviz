#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

rm -rf shows.sqlite
echo massaging data
time sqlite3 -bail shows.sqlite < 1-init.sql 

#echo creating our tables
#time sqlite3 -bail imdb.db < post-custome.sql 
