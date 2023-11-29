#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

CLEAN=1 ./0-download-data.sh
./0-import-data.sh
./1-import-shows.sh
