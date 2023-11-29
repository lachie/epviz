import type { ColumnType } from "kysely";

export type Generated<T> = T extends ColumnType<infer S, infer I, infer U>
  ? ColumnType<S, I | undefined, U>
  : ColumnType<T, T | undefined, T>;

export interface ShowBookmark {
  iid: string | null;
  favourite: Generated<number>;
  note: string | null;
}

export interface ShowBookmarkOld {
  iid: string | null;
  note: string | null;
  favourite: number | null;
}

export interface DB {
  show_bookmark: ShowBookmark;
  show_bookmark_old: ShowBookmarkOld;
}
