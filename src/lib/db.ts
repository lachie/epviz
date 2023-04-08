import Database from 'better-sqlite3';
import * as url from 'url';
import { parseEpisodes, type EpvizData } from './epviz';
import { Kysely, SqliteDialect, sql } from 'kysely';
import type { DB } from './db-types';

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

  const results = await db.selectFrom('shows_fts')
    .select(['iid', 'title'])
    .where('title', 'match', query)
    .orderBy('votes', 'desc')
    .limit(20)
    .execute() as {title:string, iid:string}[]

  return results
    .map(({ title, iid }) => ([iid, title]));
}


export async function getShow(iid: string) {
  return await db.selectFrom('shows').where('iid', '=', iid).executeTakeFirstOrThrow()
}

export async function getEpisodes(iid: string) {
  return await db.selectFrom('eps')
    .select(['season', 'episode', 'title', 'rating'])
    .where('iid', '=', iid)
    .execute()
}

export async function getEpvizData(iid: string): Promise<EpvizData> {
  const episodes = await getEpisodes(iid);
  return parseEpisodes(episodes);
}
