# epviz

IMDB TV episode ratings visualiser in elm.

Please note that I only write elm on my weekends, and my expertise isn't really in making pretty UIs.
So its not necessarily the best ever code or interface.

## data

IMDB used to publish its dataset as gzipped tsv's. That's where this data's from.
This seems to have stopped very recently (as of June 2020).

If you can track down `titles.basics.tsv.gz`, `titles.episodes.tsv.gz` and `titles.ratings.tsv.gz`, there are some ruby scripts in `data_imdb` to extract the data into elm records.
