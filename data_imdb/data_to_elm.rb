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

        %Q!Episode "#{episode["id"]}" "#{episode["title"]}" #{rating}!
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

    out.puts %Q!#{show_id} = Show "#{show_id}" "#{show["title"]}" #{show_id}Seasons!
  end

  out.puts %Q!shows = [!
  out.puts shows.keys * ','
  out.puts "]"
end

system "elm-format --yes #{show_data}"
