require 'pp'
require 'json'
require 'pathname'

here = Pathname.new(__dir__)


data = here + "data_cache"

pp data.entries

show_ids = data.entries.map {|p| p.basename.to_s[/^i=([^&]+)\.json$/,1]}.compact

show_data = here+"src/ShowData.elm"
show_data.open('w') do |out|
  out.puts "module ShowData exposing (..)"
  out.puts "import Types exposing (Show, Season, Episode)"

  show_ids.each do |show_id|
    show_json = data + "i=#{show_id}.json"

    show = JSON.parse(show_json.read)
    pp show

    season_count = show["totalSeasons"].to_i

    seasons = []

    season_count.times do |i|
      season_json = data + "i=#{show_id}&season=#{i+1}.json"
      season = JSON.parse(season_json.read)


      episodes = season["Episodes"].map do |episode|
        rating = episode["imdbRating"].to_f / 10.0

        %Q!Episode "#{episode["Title"]}" #{rating}!
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

    out.puts %Q!#{show_id} = Show "#{show["Title"]}" #{show_id}Seasons!
  end

  out.puts %Q!shows = [!
  out.puts show_ids * ','
  out.puts "]"
end

system "elm-format --yes #{show_data}"
