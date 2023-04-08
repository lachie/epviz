
export type Episode = {
  id: string,
  ord: number,
  title: string,
  rating: number,
}

export type Season = {
  ord: number,
  ratings: { max: number, min: number },
  episodes: Episode[]
}

export type EpvizData = {
  ratings: { max: number, min: number },
  seasonExtents: { max: number, min: number },
  seasons: Season[]
}

export function parseEpisodes(dbEpisodes: Episode[]): EpvizData {
  const data: EpvizData = {
    ratings: {
      max: 0,
      min: 10,
    },
    seasonExtents: {
      max: 0,
      min: Number.MAX_VALUE,
    },
    seasons: [],
  }

  dbEpisodes.forEach((epRecord) => {
    let { season: seasonOrd, episode: episodeOrd } = epRecord;
    if(isNaN(seasonOrd) || isNaN(episodeOrd)) {
      return
    }
    const sIndex = seasonOrd - 1
    const eIndex = episodeOrd - 1
    let season = data.seasons[sIndex]
    if (!season) {
      data.seasons[sIndex] = season = {
        ord: season,
        ratings: {
          max: 0,
          min: 10,
        },
        episodes: [],
      };
    }
    season.episodes[eIndex] = { ...epRecord, ord: episodeOrd }

    const { rating } = epRecord

    season.ratings.max = Math.max(season.ratings.max, rating)
    season.ratings.min = Math.min(season.ratings.min, rating)

    data.ratings.max = Math.max(data.ratings.max, rating)
    data.ratings.min = Math.min(data.ratings.min, rating)
  })

  const seasonLengths = data.seasons.map(({ episodes }) => episodes.length)
  data.seasonExtents.max = Math.max(...seasonLengths)
  data.seasonExtents.min = Math.min(...seasonLengths)

  return data
}
