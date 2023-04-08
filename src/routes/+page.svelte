<script lang="ts">
  import AutoComplete from '$lib/components/AutoComplete.svelte';
  import type { PageData } from './$types';

  export let data: PageData;
</script>

<div>
  <AutoComplete />
</div>

<div>
  <ul>
{#each data.bookmarks as show}
  <li>
  <a href="/show/{show.iid}">{show.title}</a>
  </li>
{/each}
  </ul>
</div>
