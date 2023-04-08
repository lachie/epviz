export interface Episodes {
  tconst: string | null;
  parentTconst: string | null;
  seasonNumber: string | null;
  episodeNumber: string | null;
}

export interface Eps {
  iid: string | null;
  title: string | null;
  votes: string | null;
  rating: number | null;
  year: string | null;
  season: string | null;
  episode: string | null;
}

export interface Ratings {
  tconst: string | null;
  averageRating: string | null;
  numVotes: string | null;
}

export interface ShowBookmark {
  iid: string | null;
  note: string | null;
}

export interface Shows {
  iid: string | null;
  title: string | null;
  votes: string | null;
  rating: number | null;
}

export interface ShowsFts {
  iid: string | null;
  title: string | null;
  votes: string | null;
}

export interface ShowsFtsConfig {
  k: string;
  v: string | null;
}

export interface ShowsFtsData {
  id: number | null;
  block: Buffer | null;
}

export interface ShowsFtsDocsize {
  id: number | null;
  sz: Buffer | null;
}

export interface ShowsFtsIdx {
  segid: string;
  term: string;
  pgno: string | null;
}

export interface Titles {
  tconst: string | null;
  titleType: string | null;
  primaryTitle: string | null;
  originalTitle: string | null;
  isAdult: string | null;
  startYear: string | null;
  endYear: string | null;
  runtimeMinutes: string | null;
  genres: string | null;
}

export interface DB {
  episodes: Episodes;
  eps: Eps;
  ratings: Ratings;
  show_bookmark: ShowBookmark;
  shows: Shows;
  shows_fts: ShowsFts;
  shows_fts_config: ShowsFtsConfig;
  shows_fts_data: ShowsFtsData;
  shows_fts_docsize: ShowsFtsDocsize;
  shows_fts_idx: ShowsFtsIdx;
  titles: Titles;
}
