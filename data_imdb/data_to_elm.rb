require 'pathname'
require 'json'
require 'pp'

here = Pathname.new(__dir__)

shows = JSON.parse (here+'shows.json').read
all_episodes = JSON.parse (here+'episodes.json').read

shows.each do |id, show|
  episodes = all_episodes[id]
  pp id
  pp show

  season_count = show["seasons"]
  show["seasons"] = []

  season_count.times do |i|
    s = i + 1
    show["seasons"][i] = episodes.values.select {|ep|
      ep["season"] == s
    }

    show["seasons"][i].sort_by! {|ep| ep["episode"]}

    puts "season #{s}"
    pp show["seasons"][i].size
  end
end

def to_elm_record(h)
  out = []

  h.each do |k,v|
    out << "#{k} = #{v}"
  end

  "{ #{ out * ',' } }"
end

def q(s)
  %Q!"#{ s }"!
end

show_data = here+"../src/ShowData.elm"
show_data.open('w') do |out|
  out.puts "module ShowData exposing (..)"
  out.puts "import Types exposing (Show, Season, Episode)"


  shows.each do |show_id, show|
    seasons = []
    out.puts "-- #{show["title"]}"

    show["seasons"].each_with_index do |season,i|
      episodes = season.map do |episode|
        rtng = episode["rating"]

        if rtng.nil? || rtng == 0
          rating = "Nothing"
        else
          rtng = rtng.to_f / 10.0
          rating = "(Just #{rtng})"
        end

        h = {
          imdbID: q(episode['id']),
          title: q(episode['title']),
          rating: rating,
          votes: episode.fetch('votes', 0),
          year: episode['from'],
          runtimeMinutes: episode['runtime'],
        }

        to_elm_record(h)
      end


      season_s = %Q!Season "#{i+1}" [!
      season_s << episodes * ','
      season_s << %Q!]!

      seasons << season_s
      # pp episode
    end


    out.puts "#{show_id}Seasons = ["
    out.puts seasons * ','
    out.puts "]"

    genres = show.fetch("genres","").split(',').map {|g| q g}

    show_h = {
      imdbID: q(show_id),
      seasons: "#{show_id}Seasons",
      title: q(show["title"]),
      fromYear: show["from"],
      toYear: show["to"],
      genres: "[#{ genres * ',' }]",
    }

    out.puts %Q!#{show_id} = #{to_elm_record show_h}!
  end

  out.puts %Q!shows = [!
  out.puts shows.keys * ','
  out.puts "]"
end

system "elm-format --yes #{show_data}"
