#!/bin/bash

HERE=$(dirname $0)

cd $HERE

#https://datasets.imdbws.com/

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
