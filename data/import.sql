.mode ascii
.separator "\t" "\n"
.import title.basics.tsv titles
.import title.episode.tsv episodes
.import title.ratings.tsv ratings

create index idx_titles_tconst on titles(tconst);
create index idx_ratings_tconst on ratings(tconst);
create index idx_episodes_tconst on episodes(tconst);

