#!/bin/bash

set -euo pipefail
[[ ${DEBUG:-} ]] && set -x

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd $HERE

#CREATE TABLE IF NOT EXISTS "titles"(
  #"tconst" TEXT,
  #"titleType" TEXT,
  #"primaryTitle" TEXT,
  #"originalTitle" TEXT,
  #"isAdult" TEXT,
  #"startYear" TEXT,
  #"endYear" TEXT,
  #"runtimeMinutes" TEXT,
  #"genres" TEXT
#);
#CREATE TABLE IF NOT EXISTS "episodes"(
  #"tconst" TEXT,
  #"parentTconst" TEXT,
  #"seasonNumber" TEXT,
  #"episodeNumber" TEXT
#);
#CREATE TABLE IF NOT EXISTS "ratings"(
  #"tconst" TEXT,
  #"averageRating" TEXT,
  #"numVotes" TEXT
#);

#sqlite3 imdb.db -batch <<EOSQL
#DROP TABLE shows;

#CREATE TABLE shows AS
  #SELECT t.tconst iid,
    #t.primaryTitle as title,
    #cast(r.numVotes as INTEGER) as votes,
    #cast(r.averageRating as REAL) as rating
      #FROM titles t
      #JOIN ratings r ON t.tconst = r.tconst
      #WHERE t.titleType = 'tvSeries' OR t.titleType = 'tvMiniSeries';

#DROP TABLE show_fts;
#CREATE VIRTUAL TABLE show_fts USING fts5(content="shows", iid, title, votes);

#INSERT INTO show_fts(rowid, iid, title, votes)
  #SELECT rowid, iid, title, votes FROM shows;

#DROP TABLE IF EXISTS eps;

#CREATE TABLE eps AS
  #SELECT t.tconst iid,
    #t.primaryTitle as title,
    #cast(r.numVotes as INTEGER) as votes,
    #cast(r.averageRating as REAL) as rating,
    #cast(t.startYear as INTEGER) as year,
    #cast(e.seasonNumber as INTEGER) as season,
    #cast(e.episodeNumber as INTEGER) as episode
      #FROM titles t
      #JOIN ratings r ON t.tconst = r.tconst
      #JOIN episodes e ON t.tconst = e.tconst
      #WHERE t.titleType = 'tvEpisode'
      #AND t.isAdult = '0';

#EOSQL

sqlite3 imdb.db -batch <<EOSQL
DROP TABLE IF EXISTS show_bookmark;
CREATE TABLE show_bookmark (
  iid TEXT PRIMARY KEY,
  note TEXT
);

EOSQL
