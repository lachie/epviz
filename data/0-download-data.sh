#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

#https://datasets.imdbws.com/

echo "Downloading data files..."

title_basics=$HERE/data/title.basics.tsv
title_episodes=$HERE/data/title.episode.tsv
title_ratings=$HERE/data/title.ratings.tsv

: ${CLEAN:=}
if [[ $CLEAN ]]; then
  echo cleaning existing data files
  if [[ -f $title_basics ]]; then
    mv $title_basics $title_basics.$(date +%s)
  fi
  if [[ -f $title_episodes ]]; then
    mv $title_episodes $title_episodes.$(date +%s)
  fi
  if [[ -f $title_ratings ]]; then
    mv $title_ratings $title_ratings.$(date +%s)
  fi
fi

basics_url=https://datasets.imdbws.com/title.basics.tsv.gz
episodes_url=https://datasets.imdbws.com/title.episode.tsv.gz
ratings_url=https://datasets.imdbws.com/title.ratings.tsv.gz

for url in $basics_url $episodes_url $ratings_url; do
  basegz=$(basename $url)
  base=$(basename $url .gz)
  if [[ ! -f $base ]]; then
    curl -L $url -o $basegz
    gzip -d $basegz
  fi
done
