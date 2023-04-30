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

export interface Show {
  iid: string;
  title: string;
  votes: number;
  rating: number;
  start_year: number;
  end_year: number;
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

export interface DB {
  ep: Ep;
  show: Show;
  show_fts: ShowFts;
  show_fts_config: ShowFtsConfig;
  show_fts_data: ShowFtsData;
  show_fts_docsize: ShowFtsDocsize;
  show_fts_idx: ShowFtsIdx;
}
