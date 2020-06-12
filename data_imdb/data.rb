require 'sqlite3'
require 'pathname'
require 'zlib'
require 'pp'

here = Pathname.new(__dir__)

db = SQLite3::Database.new("imdb.db")


basics_columns = {
  "imdb_id" => "text", # tconst
  "title_type" => "text", # titleType
  "title" => "text", # primaryTitle
  "original_title" =>  "text", # originalTitle
  "is_adult" =>  "text", # isAdult
  "start_year" =>  "int", # startYear
  "end_year" =>  "int", # endYear
  "runtime_minutes" =>  "int", # runtimeMinutes
  "genres" =>  "text" # genres
}

episodes_columns = {
  "imdb_id" => "text",
  "parent_id" => "text",
  "season_number" => "int",
  "episode_number" => "int",
}

ratings_columns = {
  "imdb_id" => "text",
  "rating" => "num",
  "votes" => "int",
}

import = ->(kind, table, columns) {
  db.execute %Q{
    create table IF NOT EXISTS #{table} ( #{ columns.map { |p| p * ' ' } * "," } );
  }

  file = here+"title.#{kind}.tsv.gz"

  lines = %x{zcat #{file} | wc -l}.to_i

  sql = "insert into #{table} (#{columns.keys * ','}) values (#{['?'] * columns.size * ','})"

  i = 0
  Zlib::GzipReader.open(file.to_s) do |ff|
    ff.each_line do |l|
      cols = l.split("\t")
      db.execute(sql, cols)
      i+=1

      if i % 1000 == 0
        puts "#{kind} #{i}/#{lines} #{((i / lines.to_f) * 100).round}%"
      end
    end
  end
}

import.("basics", "titles", basics_columns)
import.("episode", "episodes", episodes_columns)
import.("ratings", "ratings", ratings_columns)
