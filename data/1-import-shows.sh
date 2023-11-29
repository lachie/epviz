#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

# take the base data and massage it into the shows database

rm -rf shows.sqlite
echo massaging data
time sqlite3 -bail shows.sqlite < 1-import-shows.sql 

#echo creating our tables
#time sqlite3 -bail imdb.db < post-custome.sql 
