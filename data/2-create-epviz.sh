#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

# Create the app-specific database
# This shouldn't be done more than once.

if [[ -f $HERE/epviz.sqlite ]]; then
  echo "epviz.sqlite already exists, skipping"
  exit 0
fi

time sqlite3 -bail epviz.sqlite < 2-create-epviz.sql 
