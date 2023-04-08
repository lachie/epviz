<script lang="ts">
  import { onMount } from 'svelte';
  import type EpViz from '$lib/components/EpViz.svelte';
  import type { PageData } from './$types';

	export const prerender = false;
	export const ssr = false;

  export let data: PageData;

//$: console.dir(data, { depth: null })
  $: console.log(data)

  let epViz: EpViz;
  onMount(async () => {
    const module = await import('$lib/components/EpViz.svelte');
    epViz = module.default;
  });
</script>

<a href="/">Back</a>

Hey its {data.show.primaryTitle}!
  {data.show.tconst}

<div style:height='300' style:width='300'>
  <svelte:component this={epViz} show={data.show} epviz={data.epviz} />
</div>

<style>	
	:global(body) {
		margin: 0;
		padding: 0;
		min-height: 100vh;
		display: flex;
    flex-direction: column;
		background: #e5e5e5;
	}
</style>
