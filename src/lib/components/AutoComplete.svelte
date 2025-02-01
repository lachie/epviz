<script lang="ts">
  import { onMount } from 'svelte';
// import { debounce } from 'lodash-es';

  let searchInput = $state('');
  let focused = $state(false);
  let titles: string[] = $state([]);
  let imdbId: string | undefined = $state()
  let listRef: HTMLDivElement = $state();
  let showing = $derived(focused && searchInput.length > 0);

  const fetchResults = async (query: string) => {
    console.log("qeury", query, query.slice(0,2))
    if(query.slice(0,2) === "tt") {
      imdbId = query;
      return
    }
    imdbId = undefined;
    const response = await (await fetch(`/api/search?q=${query}`)).json();
    titles = response.titles;
  }

  let timer;
  const debounce = () => {
    clearTimeout(timer);
    timer = setTimeout(() => {
      fetchResults(searchInput);
    }, 750)
  };

  const handleBlur = (e: FocusEvent) => {
    if(e.relatedTarget && listRef?.contains(e.relatedTarget as Node)) return; //
    focused = false;
  }

  onMount(() => {
    fetchResults('');
  });
</script>

<div>
  <input
    type="text"
    bind:value="{searchInput}"
    oninput={debounce}
    onfocus={() => focused = true}
    onblur={handleBlur}
    placeholder="Search..."
    class="input input-bordered"
  />

  {#if showing}
    <div class="fixed bg-slate-300 w-1/2 z-50" bind:this={listRef}>
      {#if imdbId}
        <a target="_blank" class="btn btn-ghost" href="https://www.imdb.com/title/{imdbId}">IMDB</a>
      {:else if titles.length === 0}
        <div class="p-4">No results</div>
      {:else}
      <ul>
        {#each titles as [id,title]}
          <li>
            <a href="/show/{id}" class="btn btn-ghost" onclick={() => focused = false}>
            {title}
            </a>
          </li>
        {/each}
      </ul>
      {/if}
    </div>
  {/if}
</div>
