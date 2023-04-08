#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

npx kysely-codegen \
  --url $HERE/data/imdb.db \
  --out-file $HERE/src/lib/db-types.d.ts 
  #--include-pattern '(shows,eps,show_fts)'
