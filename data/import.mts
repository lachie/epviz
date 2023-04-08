import Database from 'better-sqlite3';
import * as fs from 'fs';
import * as path from 'path';
import * as readline from 'node:readline/promises';
import * as url from 'url';

const __dirname = url.fileURLToPath(new URL('.', import.meta.url));

const dbPath = path.join(__dirname, 'imdb2.db');

fs.unlinkSync(dbPath);

const db = new Database(dbPath);

const ddl = `
CREATE TABLE IF NOT EXISTS "titles"(
  "id" INTEGER, "type" TEXT, "title" TEXT, "original_title" TEXT,
  "isAdult" TEXT, "startYear" INTEGER, "endYear" INTEGER, "runtimeMinutes" INTEGER,
  "genres" TEXT
);
CREATE TABLE IF NOT EXISTS "episodes"(
  "id" INTEGER, "parentId" INTEGER, "season" INTEGER, "episode" INTEGER
);
CREATE TABLE IF NOT EXISTS "ratings"(
  "id" INTEGER, "averageRating" REAL, "numVotes" INTEGER
);
`

db.exec(ddl);

const titlesTsv = path.join(__dirname, 'title.basics.tsv');
const episodesTsv = path.join(__dirname, 'title.episode.tsv');

const open = (file: string) => {
  // read the tsv file line by line
  const input = fs.createReadStream(file)
  return readline.createInterface({ input });
}

const titles = open(titlesTsv);
const episodes = open(episodesTsv);

const types = new Set

const insertEpisode = db.prepare(`INSERT INTO episodes VALUES (?, ?, ?, ?)`)
const insertTitle = db.prepare(`INSERT INTO titles VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`)

let first = true
for await(const line of episodes) {
  if(first) {
    first = false
    continue;
  }
  const row = line.split('\t');
  row[0] = row[0].slice(2);
  row[1] = row[1].slice(2);
  const rowNotNull = row.map((r) => r !== '\\N' ? r : null);
  insertEpisode.run(...rowNotNull)
}

//for await (const line of titles) {
  ////console.log(line);
  //const row = line.split('\t');
  //let [id, titleType, title, original_title, isAdult, startYear, endYear, runtimeMinutes, genres] = row;

  //const rowNotNull = row.map((r) => r !== '\\N' ? r : null);

  //if(titleType === 'tvSeries' || titleType == 'tvMiniSeries') {
    //insertTitle.run(...rowNotNull);
  //}

  //types.add(titleType);
//}

//console.log(types);
