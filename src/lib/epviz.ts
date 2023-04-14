import type { Ep, Show } from "./db-types"

export { Ep, Show }

export type Season = {
  ord: number,
  ratings: { max: number, min: number },
  episodes: Ep[]
}

export type EpvizData = {
  ratings: { max: number, min: number },
  seasonExtents: { max: number, min: number },
  seasons: Season[]
}

export function parseEpisodes(dbEpisodes: Ep[]): EpvizData {
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
    season.episodes[eIndex] = epRecord

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

export function epvizGrid(epviz: EpvizData) {
  const { seasons, seasonExtents } = epviz
  const grid: Ep[][] = []
  for(let i = 0; i < seasonExtents.max; i++) {
    grid[i] ||= []
    for(let j = 0; j < seasons.length; j++) {
      const season = seasons[j]
      const ep = season.episodes[i]
      grid[i][j] = ep
    }
  }

  return grid
}
