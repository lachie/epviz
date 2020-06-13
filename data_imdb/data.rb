require 'pathname'
require 'zlib'
require 'pp'
require 'set'
require 'json'


shows = {
  "breaking bad"=>"tt0903747",
  "the sopranos" =>"tt0141842",
  "the west wing" => "tt0200276", 
  "the expanse" => "tt3230854",
  "the wire" => "tt0306414",
  "st:tng" => "tt0092455",
  "st:voy" => "tt0112178",
  "st:ent" => "tt0244365",
  "st:ds9" => "tt0106145",
  "st:tos" => "tt0060028",
  "st:dis" => "tt5171438",
  "st:pic" => "tt8806524",
  "farscape" => "tt0187636",
  "treme" => "tt1279972",
  "the office" => "tt0386676",
  "community" => "tt1439629",
  "p n r" => "tt1266020",
  "buffy" => "tt0118276",
  "silicon valley" => "tt2575988",
  "got" => "tt0944947",
  "avatar" => "tt0417299",
  "korra" => "tt1695360",
  "rick n morty" => "tt2861424",
  "true detective" => "tt2356777",
  "fargo" => "tt2802850",
  "westworld" => "tt0475784",
  "bsg" => "tt0407362",
  "the shield" => "tt0286486",
  "deadwood" => "tt0348914",
  "justified" => "tt1489428",
  "line of duty" => "tt2303687",
  "mad men" => "tt0804503",
  "dexter" => "tt0773262",
  "newsroom" => "tt1870479",
  "adventure time" => "tt1305826",
  "mr robot" => "tt4158110",
  "luther" => "tt1474684",
  "venture bros" => "tt0417373",
  "steven universe" => "tt3061046",
  "slings and arrows" => "tt0387779",
  "billions" => "tt4270492",
  "black mirror" => "tt2085059",
  "person of interest" => "tt1839578",
  "brooklyn 99" => "tt2467372",
  "homeland" => "tt1796960",
  "better call saul" => "tt3032476",
  "bosch" => "tt3502248",
  "house" => "tt0412142",
  "the witcher" => "tt5180504",
  "gangs of london" => "tt7661390",
  "six feet under" => "tt0248654",
  "peaky blinders" => "tt2442560",
  "the walking dead" => "tt1520211",
  "killing eve" => "tt7016936",
  "legion" => "tt5114356",
  "the sinner" => "tt6048596",
  "stranger things" => "tt4574334",
  "the orville" => "tt5691552",
  "dark" => "tt5753856",
  "always sunny" => "tt0472954",
  "the americans" => "tt2149175",
  "rectify" => "tt2183404",
  "infinity train" => "tt8146754",
  "gravity falls" => "tt1865718",
  "the good fight" => "tt5853176",
  "the fall" => "tt2294189",
  "banshee" => "tt2017109",
}

def lines_for(kind, &blk)
  here = Pathname.new(__dir__)
  file = here+"title.#{kind}.tsv.gz"

  # lines = %x{zcat #{file} | wc -l}.to_i

  i = 0
  Zlib::GzipReader.open(file.to_s) do |ff|
    ff.each_line do |l|
      yield l

      # i+=1
      # if i % 1000 == 0
        # puts "#{kind} #{i}/#{lines} #{((i / lines.to_f) * 100).round}%"
      # end
    end
  end
end


import = ->(show_ids) {
  shows = Hash.new {|h,k| h[k] = {seasons: 0}}
  titles = Hash.new {|h,k| h[k] = Hash.new {|hh,kk| hh[kk] = {}}}
  ep_to_title = {}

  re = %r!^(\w+)\t(#{show_ids * '|'})\t!

  lines_for("episode") do |line|
    if re =~ line
      id = $1
      show_id = $2
      ep_to_title[id] = show_id
      cols = line.chomp.split("\t")
      titles[show_id][id][:season] = cols[2].to_i
      titles[show_id][id][:episode] = cols[3].to_i

      shows[show_id][:seasons] = [ shows[show_id][:seasons], cols[2].to_i ].max
    end
  end

  # tconst	titleType	primaryTitle	originalTitle	isAdult	startYear	endYear	runtimeMinutes	genres
  lines_for("basics") do |line|
    cols = line.chomp.split("\t")
    id = cols[0]

    t = if show_ids.include?(id)
          shows[id]
        elsif show_id = ep_to_title[id]
          titles[show_id][id]
        end

    if t
      t[:id] = id
      t[:title] = cols[2]
      t[:from] = cols[5].to_i
      t[:to] = cols[6].to_i
      t[:runtime] = cols[7].to_i
      t[:genres] = cols[8]
    end
  end

  lines_for("ratings") do |line|
    cols = line.chomp.split("\t")
    id = cols[0]
    t = if show_ids.include?(id)
          shows[id]
        elsif show_id = ep_to_title[id]
          titles[show_id][id]
        end

    if t
      t[:rating] = cols[1].to_f
      t[:votes] = cols[2].to_i
    end
  end

  [shows, titles]
}

shows,episodes_by_show = import.(shows.values)

here = Pathname.new(__dir__)
(here+"shows.json").open('w') { |f| f.puts JSON.dump(shows) }
(here+"episodes.json").open('w') { |f| f.puts JSON.dump(episodes_by_show) }
