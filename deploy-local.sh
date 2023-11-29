#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

npm run build
dist=$HERE/build

cd $dist

npm ci --omit dev

export DB_PATH=$HERE/data/epviz.sqlite
export SHOW_DB_PATH=$HERE/data/shows.sqlite
export PORT=5050
export ORIGIN=http://10.28.10.28:5050

node .
