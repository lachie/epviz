<script lang="ts">
  import EpViz from '$lib/components/EpVizHtml.svelte';
  import type { PageData, RouteParams } from './$types';
  import { enhance } from '$app/forms';
  import { Icon, Bookmark, BookmarkSlash } from "svelte-hero-icons";
  import settingsStore from '$lib/settings';
    import SeasonSummary from '$lib/components/SeasonSummary.svelte';

  type Zoom = keyof typeof zooms;

  const zooms = {'100%': "w-full", '50%': "w-1/2", '25%': "w-1/4"} as const;
  const zoomForLabel = (label: string): string => zooms[label as Zoom] || zooms['100%'];

  const zoom = settingsStore('zoom', '100%')
  let currentZoom = zoomForLabel($zoom)


  $: currentZoom = zoomForLabel($zoom); 
  const setZoom = (newZoom: string) => $zoom = newZoom

  $: console.log("zoom", $zoom)
  $: console.log("currentZoom", currentZoom)

  export let data: PageData;
</script>

<div class="flex flex-col">
  <div class="flex-initial">
    <div class="flex flex-row gap-x-4">
      <div>
        <b>{data.show.title}</b>
      </div>
      <div>
        <b>{data.show.start_year}</b>
      </div>
      <div>
        <b>{data.show.rating}</b>
      </div>
      <div>
        <a target="_blank" href="https://www.imdb.com/title/{data.iid}">IMDB</a>
      </div>
      <div>
        {#if data.bookmarked}
        <form method="POST" class="" action="?/unbookmark" use:enhance>
          <button class="btn btn-primary btn-sm" type="submit">
            <Icon src={BookmarkSlash} mini />
          </button>
        </form>
        {:else}
        <form method="POST" action="?/bookmark" use:enhance>
          <button class="btn btn-primary btn-sm" type="submit">
            <Icon src={Bookmark} mini />
          </button>
        </form>
        {/if}
      </div>
      <div>
        {#each Object.keys(zooms) as zoomLabel}
          <button class:underline={zoomLabel===$zoom} on:click={() => setZoom(zoomLabel)}>{zoomLabel}</button>
        {/each}
      </div>
    </div>
  </div>

  <div>
    <!--<SeasonSummary epviz={data.epviz} />-->
  </div>

  <div class="shrink max-h-40 {currentZoom}">
    <EpViz epviz={data.epviz} />
  </div>
</div>
