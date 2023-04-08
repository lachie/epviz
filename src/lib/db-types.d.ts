export interface Ep {
  iid: string;
  show_iid: string;
  title: string;
  votes: number;
  rating: number;
  year: number;
  season: number;
  episode: number;
}

export interface Episodes {
  tconst: string | null;
  parentTconst: string | null;
  seasonNumber: string | null;
  episodeNumber: string | null;
}

export interface Ratings {
  tconst: string | null;
  averageRating: string | null;
  numVotes: string | null;
}

export interface Show {
  iid: string;
  title: string;
  votes: number;
  rating: number;
}

export interface ShowBookmark {
  iid: string | null;
  note: string | null;
}

export interface ShowFts {
  iid: string | null;
  title: string | null;
  votes: string | null;
}

export interface ShowFtsConfig {
  k: string;
  v: string | null;
}

export interface ShowFtsData {
  id: number | null;
  block: Buffer | null;
}

export interface ShowFtsDocsize {
  id: number | null;
  sz: Buffer | null;
}

export interface ShowFtsIdx {
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
  ep: Ep;
  episodes: Episodes;
  ratings: Ratings;
  show: Show;
  show_bookmark: ShowBookmark;
  show_fts: ShowFts;
  show_fts_config: ShowFtsConfig;
  show_fts_data: ShowFtsData;
  show_fts_docsize: ShowFtsDocsize;
  show_fts_idx: ShowFtsIdx;
  titles: Titles;
}
