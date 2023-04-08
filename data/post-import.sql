
DROP TABLE IF EXISTS shows;

-- CREATE TABLE shows (
  -- iid TEXT PRIMARY KEY,
  -- title TEXT NOT NULL,
  -- votes INTEGER NOT NULL,
  -- rating REAL NOT NULL
-- );

CREATE TABLE shows AS
  SELECT t.tconst iid,
    t.primaryTitle as title,
    cast(r.numVotes as INTEGER) as votes,
    cast(r.averageRating as REAL) as rating
      FROM titles t
      JOIN ratings r ON t.tconst = r.tconst
      WHERE t.titleType = 'tvSeries' OR t.titleType = 'tvMiniSeries';

DROP TABLE IF EXISTS shows_fts;
CREATE VIRTUAL TABLE shows_fts USING fts5(content="shows", iid, title, votes);

CREATE INDEX idx_show_iid on shows(iid);

INSERT INTO shows_fts(rowid, iid, title, votes)
  SELECT rowid, iid, title, votes FROM shows;

DROP TABLE IF EXISTS eps;

CREATE TABLE eps AS
  SELECT t.tconst iid,
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
      AND t.isAdult = '0';

CREATE INDEX idx_episode_parent_iid on eps(iid);

DROP TABLE IF EXISTS show_bookmark;
CREATE TABLE show_bookmark (
  iid TEXT PRIMARY KEY,
  note TEXT
);
