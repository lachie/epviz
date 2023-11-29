<script lang="ts">
  import { type EpvizData, type Show, type Ep, epvizGrid } from "$lib/epviz";
  import { VizGradient } from "$lib/viz_gradient";
  import { createEventDispatcher } from "svelte";

  type Dim = {
    width: number;
    height: number;
  };
  type Range = {
    min: number;
    max: number;
  };

  type Events = {
    selectEp: Ep;
  };
  const dispatch = createEventDispatcher<Events>();

  //export let show: Show;
  export let epviz: EpvizData;

  console.log("epviz", epviz);

  const seasons = epvizGrid(epviz);
  const palette = VizGradient.viridis(epviz.ratings);

  const selectEp = (kind: "key" | "click" | "dblclick", ep: Ep) => {
    console.log("selectEp", ep);

    const isTouchDevice =
      "ontouchstart" in window || navigator.maxTouchPoints > 0;
    if (isTouchDevice && kind === "click") {
      return;
    }

    dispatch("selectEp", ep);
  };

  const round = (n: number, places = 1) => {
    // const factor = Math.pow(10, places);
    // return Math.round(n * factor) / factor;
    return n.toFixed(places);
  };
</script>

<div
  class="grid"
  style:grid-template-columns={`repeat(${epviz.seasons.length}, 1fr)`}
>
  {#each epviz.seasons as season, row_index}
    <div
      class="aspect-square rounded-full flex text-xs"
      style:background-color={palette.ratingToCss(season.ratings.avg)}
      style:color={palette.ratingTextColour(season.ratings.avg)}
    >
      <div class="m-auto">
        {round(season.ratings.avg)}
      </div>
    </div>
  {/each}
  {#each seasons as row, row_index}
    {#each row as ep, col_index}
      {#if ep}
        <div
          class="aspect-square cursor-pointer group relative inline-block"
          style:background-color={palette.ratingToCss(ep.rating)}
          on:click={() => selectEp("click", ep)}
          on:dblclick={() => selectEp("dblclick", ep)}
          on:keydown={() => selectEp("key", ep)}
        >
          <div class="absolute w-full h-full">&nbsp;</div>
          <div
            class="absolute w-56 opacity-0 group-hover:opacity-100 transition-opacity bg-inherit pointer-events-none"
            style:bottom="105%"
          >
            <span style:color={palette.ratingTextColour(ep.rating)}>
              {ep.rating}
              &middot;
              {ep.title}
            </span>
          </div>
        </div>
      {:else}
        <div class="aspect-square">&nbsp;</div>
      {/if}
    {/each}
  {/each}
</div>
