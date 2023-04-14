<script lang="ts">
  import { onMount } from 'svelte';
  import type EpViz from '$lib/components/EpViz.svelte';
  import type { PageData, RouteParams } from './$types';
  import { enhance } from '$app/forms';

// export const prerender = false;
// export const ssr = false;

  export let data: PageData;

// $: console.log("page data", data)

  let epViz: EpViz;
  onMount(async () => {
    const module = await import('$lib/components/EpViz.svelte');
    epViz = module.default;
  });
</script>

<p>
  <b>{data.show.title}</b>
  &middot;
  <b>{data.show.start_year}</b>
  &middot;
  <b>{data.show.rating}</b>
  &middot;
  <a target="_blank" href="https://www.imdb.com/title/{data.iid}">IMDB</a>
  &middot;
{#if data.bookmarked}
<form method="POST" action="?/unbookmark" use:enhance>
  <button type="submit">Remove Bookmark</button>
</form>
{:else}
<form method="POST" action="?/bookmark" use:enhance>
  <button type="submit">Bookmark</button>
</form>
{/if}
</p>

<div style:height='300' style:width='300'>
  <svelte:component this={epViz} show={data.show} epviz={data.epviz} />
</div>

