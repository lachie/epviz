
DROP TABLE IF EXISTS show;

CREATE TABLE show (
  iid TEXT PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  votes INTEGER NOT NULL,
  rating REAL NOT NULL,
  start_year INTEGER NOT NULL,
  end_year INTEGER NOT NULL
);

INSERT INTO show (iid, title, votes, rating, start_year, end_year)
  SELECT t.tconst iid,
    t.primaryTitle as title,
    cast(r.numVotes as INTEGER) as votes,
    cast(r.averageRating as REAL) as rating,
    cast(t.startYear as INTEGER) as start_year,
    cast(t.endYear as INTEGER) as end_year
      FROM titles t
      JOIN ratings r ON t.tconst = r.tconst
      WHERE t.titleType = 'tvSeries' OR t.titleType = 'tvMiniSeries'
      AND iid IS NOT NULL
      AND title IS NOT NULL
      AND votes IS NOT NULL
      AND rating IS NOT NULL
      AND start_year IS NOT NULL
      AND end_year IS NOT NULL
      ;

CREATE INDEX idx_show_iid on show(iid);

DROP TABLE IF EXISTS show_fts;
CREATE VIRTUAL TABLE show_fts USING fts5(content="show", iid, title, votes);


INSERT INTO show_fts(rowid, iid, title, votes)
  SELECT rowid, iid, title, votes FROM show;

DROP TABLE IF EXISTS ep;

CREATE TABLE ep (
  iid TEXT PRIMARY KEY NOT NULL,
  show_iid TEXT NOT NULL,
  title TEXT NOT NULL,
  votes INTEGER NOT NULL,
  rating REAL NOT NULL,
  year REAL NOT NULL,
  season REAL NOT NULL,
  episode REAL NOT NULL
);

INSERT INTO ep (iid, show_iid, title, votes, rating, year, season, episode)
  SELECT t.tconst iid,
    e.parentTconst show_iid,
    t.primaryTitle as title,
    cast(r.numVotes as INTEGER) as votes,
    cast(r.averageRating as REAL) as rating,
    cast(t.startYear as INTEGER) as year,
    cast(e.seasonNumber as INTEGER) as season,
    cast(e.episodeNumber as INTEGER) as episode
      FROM titles t
      JOIN ratings r ON t.tconst = r.tconst
      JOIN episodes e ON t.tconst = e.tconst
      WHERE t.titleType = 'tvEpisode'
        AND t.primaryTitle IS NOT NULL
      AND t.isAdult = '0'
      AND iid IS NOT NULL
      AND show_iid IS NOT NULL
      AND title IS NOT NULL
      AND votes IS NOT NULL
      AND rating IS NOT NULL
      AND year IS NOT NULL
      AND season IS NOT NULL
      AND episode IS NOT NULL
      ;

CREATE INDEX idx_episode_show_iid on ep(show_iid);
