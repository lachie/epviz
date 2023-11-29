#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

DATA=$HERE/data

export DB_PATH=$DATA/epviz.sqlite
export SHOW_DB_PATH=$DATA/shows.sqlite
export PORT=5050
#export ORIGIN=http://10.28.10.28:5050

npm run dev -- --host 0.0.0.0 --port $PORT
