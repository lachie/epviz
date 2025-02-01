<script lang="ts">
  import { run } from 'svelte/legacy';

  import EpViz from '$lib/components/EpVizHtml.svelte';
  import type { PageData, RouteParams } from './$types';
  import { enhance } from '$app/forms';
  import { Icon, Bookmark, BookmarkSlash } from "svelte-hero-icons";
  import settingsStore from '$lib/settings';
    import type { Ep } from '$lib/epviz';

  type Zoom = keyof typeof zooms;

  const zooms = {'100%': "w-full", '50%': "w-1/2", '25%': "w-1/4"} as const;
  const zoomForLabel = (label: string): string => zooms[label as Zoom] || zooms['100%'];

  const zoom = settingsStore('zoom', '100%')
  let currentZoom = $state(zoomForLabel($zoom))


  run(() => {
    currentZoom = zoomForLabel($zoom);
  }); 
  const setZoom = (newZoom: string) => $zoom = newZoom

  const onSelectEp = ({ detail: ep }: CustomEvent<Ep>) => {
    window.open(`https://www.imdb.com/title/${ep.iid}`, '_blank')
  }

  run(() => {
    console.log("zoom", $zoom)
  });
  run(() => {
    console.log("currentZoom", currentZoom)
  });

  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<div class="flex flex-col">
  <div class="flex-initial">
    <div class="flex flex-row gap-x-4">
      <div>
        <b>{data.show.title}</b>
      </div>
      <div>
        <b>{data.show.start_year}</b>
        &mdash;
        <b>{data.show.end_year}</b>
      </div>
      <div>
        <b>{data.show.rating}</b>
      </div>
      <div>
        <a target="_blank" href="https://www.imdb.com/title/{data.iid}">IMDB</a>
      </div>
      <div class="flex flex-row">
        <form method="POST" class="" action={`?/${data.bookmarked ? 'un' : ''}bookmark`} use:enhance>
          <button class="btn btn-primary btn-sm" type="submit">
            <Icon src={data.bookmarked ? BookmarkSlash : Bookmark} mini />
          </button>
        </form>
        <form method="POST" class="" action={`?/${data.favourited ? 'un' : ''}fave`} use:enhance>
          <button class="btn btn-primary btn-sm" type="submit">
            {data.favourited ? '🌟' : '⭐'}
          </button>
        </form>
      </div>
      <div>
        {#each Object.keys(zooms) as zoomLabel}
          <button class:underline={zoomLabel===$zoom} onclick={() => setZoom(zoomLabel)}>{zoomLabel}</button>
        {/each}
      </div>
    </div>
  </div>

  <div>
    <!--<SeasonSummary epviz={data.epviz} />-->
  </div>

  <div class="shrink max-h-40 {currentZoom}">
    <EpViz epviz={data.epviz} on:selectEp={onSelectEp} />
  </div>
</div>
