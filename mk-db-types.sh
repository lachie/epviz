#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

kc="$HERE/node_modules/.bin/kysely-codegen"

$kc \
  --url $HERE/data/shows.sqlite \
  --out-file $HERE/src/lib/db-types.d.ts 
  #--include-pattern '(shows,eps,show_fts)'

$kc \
  --url $HERE/data/epviz.sqlite \
  --out-file $HERE/src/lib/db-epviz-types.d.ts 
