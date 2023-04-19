<script lang="ts">
import { type EpvizData, type Show, type Ep, epvizGrid } from "$lib/epviz";
import { VizGradient } from "$lib/viz_gradient";
import { createEventDispatcher } from "svelte";

type Dim = {
	width: number
	height: number
}
type Range = {
  min: number
  max: number
}

type Events = {
  hover: Ep,
  click: Ep 
}
const dispatch = createEventDispatcher<Events>()

//export let show: Show;
export let epviz: EpvizData

console.log("epviz", epviz)

const grid = epvizGrid(epviz)
const palette = VizGradient.viridis(epviz.ratings)

const selectEp = (ep: Ep) => {
  console.log("click", ep)
  dispatch("click", ep)
}

</script>

<div class="grid"
  style:grid-template-columns={`repeat(${epviz.seasons.length}, 1fr)`} 
  >
  {#each grid as row, row_index}
      {#each row as ep, col_index}
        {#if ep}
          <div
            class="aspect-square cursor-pointer group relative inline-block"
            style:background-color={palette.ratingToCss(ep.rating)} 
            on:click={() => selectEp(ep)}
            on:keydown={() => selectEp(ep)}
          >
            <div class="absolute w-full h-full">&nbsp;</div>
            <div class="absolute w-56 opacity-0 group-hover:opacity-100 transition-opacity bg-inherit pointer-events-none" style:bottom="105%">
              <span class="mix-blend-difference">
                {ep.rating}
                &middot;
                {ep.title}
              </span>
            </div>
          </div>
        {:else}
          <div class="aspect-square">
            &nbsp;
          </div>
        {/if}
      {/each}
  {/each}
</div>
