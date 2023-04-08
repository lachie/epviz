<script lang="ts">
  import { onMount } from 'svelte';
// import { debounce } from 'lodash-es';

  let searchInput = '';
  let titles: string[] = [];

  const fetchResults = async (query: string) => {
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

  onMount(() => {
    fetchResults('');
  });
</script>

<input
  type="text"
  bind:value="{searchInput}"
  on:input={debounce}
  placeholder="Search..."
/>

{#if searchInput}
  <ul>
    {#each titles as [id,title]}
      <li>
        <a href="/show/{id}">
        {title}
        </a>
      </li>
    {/each}
  </ul>
{/if}
