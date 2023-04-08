import Database from 'better-sqlite3';
import * as url from 'url';
import { parseEpisodes, type EpvizData } from './epviz';
import { Kysely, SqliteDialect, type Compilable } from 'kysely';
import type { DB, Show } from './db-types';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));
const dbFile = `${__dirname}/../../data/imdb.db`;
const database = new Database(dbFile);

const db = new Kysely<DB>({
  dialect: new SqliteDialect({database}),
})

export async function getAutocompleteResults(query: string): Promise<[string, string][]> {
  if (query.length < 3) {
    return [];
  }

  const results = await db.selectFrom('show_fts')
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
  return await db.selectFrom('show')
    .selectAll()
    .innerJoin('show_bookmark', 'show.iid', 'show_bookmark.iid')
    .orderBy('title', 'asc')
    .$call(log)
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
  return await db.selectFrom('show')
    .select(['title', 'rating', 'votes', 'start_year'])
    .where('iid', '=', iid).executeTakeFirstOrThrow()
}

export async function getEpisodes(show_iid: string) {
  return await db.selectFrom('ep')
    .selectAll()
    .where('show_iid', '=', show_iid)
    .execute()
}

export async function getEpvizData(iid: string): Promise<EpvizData> {
  const episodes = await getEpisodes(iid);
  return parseEpisodes(episodes);
}
