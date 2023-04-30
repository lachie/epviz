import Database from 'better-sqlite3';
import { env } from '$env/dynamic/private';
import { Kysely, SqliteDialect, type Compilable, sql } from 'kysely';

import { parseEpisodes, type EpvizData } from './epviz';
import type { DB as DetachedShowDB, Show } from './db-types';
import type { DB as EpvizDB } from './db-epviz-types';

// the show db is attached via sqlite ATTACH DATABASE
// how do I remap the keys to be prefixed with 'show.' ?
type Remapper<T, Prefix extends string> = {
  [K in keyof T as `${Prefix}${Extract<K, string>}`]: T[K];
};
type ShowDB = Remapper<DetachedShowDB, 'shows.'>;
type DB = ShowDB & EpvizDB;

//const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
//const dbFile = `${__dirname}/../../data/imdb.db`;

console.log("DB_PATH", env.DB_PATH)
console.log("SHOW_DB_PATH", env.SHOW_DB_PATH)
const database = new Database(env.DB_PATH);

database.exec(`ATTACH DATABASE '${env.SHOW_DB_PATH}' AS shows`)

const db = new Kysely<DB>({
  dialect: new SqliteDialect({database}),
})

export async function getAutocompleteResults(query: string): Promise<[string, string][]> {
  if (query.length < 3) {
    return [];
  }

  const results = await db.selectFrom('shows.show_fts')
    .select(['iid', 'title'])
    .where('title', 'match', query)
    .orderBy('votes', 'desc')
    .limit(20)
    .execute() as {title:string, iid:string}[]

  return results
    .map(({ title, iid }) => ([iid, title]));
}

function log<T extends Compilable>(qb: T): T {
  console.log(qb.compile())
  return qb
}

export async function getBookmarkedShows(): Promise<Show[]> {
  return await db.selectFrom('shows.show')
    .selectAll()
    .innerJoin('show_bookmark', 'shows.show.iid', 'show_bookmark.iid')
    .orderBy('title', 'asc')
    .execute()
}

export async function getBookmarked(iid: string): Promise<boolean> {
  const bookmark = await db
    .selectFrom('show_bookmark')
    .select(['iid'])
    .where('iid', '=', iid)
    .executeTakeFirst()

    return !!bookmark
}

export async function setBookmarked(iid: string, bookmarked: boolean) {
  if (bookmarked) {
    await db.insertInto('show_bookmark').values({ iid }).execute()
  } else {
    await db.deleteFrom('show_bookmark').where('iid', '=', iid).execute()
  }
}

export async function getShow(iid: string) {
  return await db.selectFrom('shows.show')
    .select(['title', 'rating', 'votes', 'start_year'])
    .where('iid', '=', iid).executeTakeFirstOrThrow()
}

export async function getEpisodes(show_iid: string) {
  return await db.selectFrom('shows.ep')
    .selectAll()
    .where('show_iid', '=', show_iid)
    .execute()
}

export async function getEpvizData(iid: string): Promise<EpvizData> {
  const episodes = await getEpisodes(iid);
  return parseEpisodes(episodes);
}
