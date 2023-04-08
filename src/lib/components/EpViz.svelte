<script lang="ts">
  import Konva from "konva";
import KonvaCanvas from "./KonvaCanvas.svelte";
import type { Show } from "$lib/db";
import type { EpvizData, Episode } from "$lib/epviz";
import { VizGradient } from "$lib/viz_gradient";

type Dim = {
	width: number
	height: number
}

let stage: Konva.Stage;
let layer: Konva.Layer;
export let show: Show;
export let epviz: EpvizData

$: {
  if(stage) {
    layer = new Konva.Layer();
    stage.add(layer);
    draw()
  }
}

const episodeHoverMap = new Map<Episode, Konva.Group>()
const addEpisode = (cellsGroup: Konva.Group, episode: Episode, cellD: number, [i,j]: [number,number], palette: VizGradient) => {
  const episodeRect = new Konva.Rect({
    x: i * cellD,
    y: j * cellD,
    width: cellD,
    height: cellD,
    fill: palette.ratingToCss(episode.rating),
  });

  episodeRect.on("pointerclick", () => {
    console.log("clicked", episode);
  });
  episodeRect.on("pointerenter", () => {
    console.log("enter", episode);
    let group = episodeHoverMap.get(episode)
    stage.container().style.cursor = 'pointer';
    if(group === undefined) {
      group = new Konva.Group({
        x: i * cellD,
        y: j * cellD,
        listening: false,
      })
      episodeHoverMap.set(episode, group)
      cellsGroup.add(group)
    }
    group.add(new Konva.Rect({
      x: 0,
      y: 0,
      width: cellD,
      height: cellD,
      stroke: "white",
      strokeWidth: 1,
      listening: false,
    }))

    const textColour = 'hsl(0,0%,50%)'
    const popoverPadding = 5
    const ratingText = new Konva.Text({
      x: popoverPadding,
      y: cellD+popoverPadding,
      text: ''+episode.rating,
      fontSize: 12,
      fontFamily: "sans-serif",
      fill: textColour,
      align: "left",
      verticalAlign: "top",
      listening: false,
    })
    const descText = new Konva.Text({
      text: episode.title,
      x: popoverPadding,
      y: cellD+12+popoverPadding,
      fontSize: 12,
      fontFamily: "sans-serif",
      fill: textColour,
      align: "left",
      verticalAlign: "top",
      listening: false,
    })

    const popoverWidth = Math.max(ratingText.width(), descText.width())
    const popoverHeight = ratingText.height() + descText.height()

    group.add(new Konva.Rect({
      x: 0,
      y: cellD,
      width: popoverWidth + popoverPadding*2,
      height: popoverHeight + popoverPadding*2,
      fill: 'hsl(0,50%,100%)',
      opacity: 0.75,
      listening: false,
    }))

    group.add(ratingText)
    group.add(descText)
  })
  episodeRect.on("pointerleave", () => {
    console.log("leave", episode);
    let group = episodeHoverMap.get(episode)
    if(group !== undefined) {
      group.destroy()
      episodeHoverMap.delete(episode)
      stage.container().style.cursor = 'default';
    }
  })
  cellsGroup.add(episodeRect);
}

const draw = () => {
  if(stage === undefined) return
  if(layer === undefined) return

  const titleSize = 20

  const cellAreaWidth = stage.width() - titleSize
  const cellAreaHeight = stage.height() - titleSize

  layer.destroyChildren();
  layer.absolutePosition({x: titleSize, y: titleSize})

  console.log(stage.width(), stage.height());
  console.log(epviz)

  const seasonCount = epviz.seasons.length;
  const episodeCount = epviz.seasonExtents.max

  const cellWidth = cellAreaWidth / seasonCount;
  const cellHeight = cellAreaHeight / episodeCount;

  const cellD = Math.min(cellWidth, cellHeight)
  const cellR = cellD / 2

  const seasonsTitleGroup = new Konva.Group({ y: -titleSize })
  const episodesTitleGroup = new Konva.Group()
  const cellsGroup = new Konva.Group()

  console.log("palette", VizGradient.viridis(epviz.ratings))
  const palette = VizGradient.viridis(epviz.ratings)

  layer.add(seasonsTitleGroup);
  layer.add(episodesTitleGroup);
  layer.add(cellsGroup);

  for(let i = 0; i < seasonCount; i++) {
    const season = epviz.seasons[i];
    const seasonTitle = new Konva.Text({
      x: i * cellD + cellR,
      y: titleSize-12,
      text: ''+season.ord,
      fontSize: 12,
      fontFamily: "sans-serif",
      fill: "black",
      align: "center",
      verticalAlign: "middle",
    });
    seasonsTitleGroup.add(seasonTitle);

    for(let j = 0; j < season.episodes.length; j++) {
      const episode = season.episodes[j];
      if(episode === undefined) continue
      addEpisode(cellsGroup, episode, cellD, [i, j], palette)
    }
  }

  for(let i = 0; i < epviz.seasonExtents.max; i++) {
    const episodeTitle = new Konva.Text({
      x: -titleSize,
      y: i * cellD + cellR,
      text: ''+(i+1),
      fontSize: 12,
      fontFamily: "sans-serif",
      fill: "black",
      align: "right",
      verticalAlign: "middle",
    });
    episodesTitleGroup.add(episodeTitle);
  }

};

const onResize = (e: CustomEvent<Dim>) => {
  console.log("canvas resized", e.detail);
  draw()
}
</script>

<KonvaCanvas bind:stage on:resized={onResize} />
