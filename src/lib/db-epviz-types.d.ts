export interface ShowBookmark {
  iid: string | null;
  note: string | null;
}

export interface DB {
  show_bookmark: ShowBookmark;
}
