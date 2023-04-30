#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE
dist=$HERE/build

npm run build

DEPLOY_HOST=lachie@10.28.10.28
DEPLOY_PATH=epviz

rsync -avz \
  --delete \
  --exclude node_modules \
  --exclude epviz.sqlite \
  data/shows.sqlite \
  run_server.sh \
  package.json \
  package-lock.json \
  $dist/ \
  $DEPLOY_HOST:$DEPLOY_PATH

ssh $DEPLOY_HOST "cd $DEPLOY_PATH && /home/lachie/.asdf/shims/npm ci --omit dev"
