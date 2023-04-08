<script lang="ts">
  import AutoComplete from '$lib/components/AutoComplete.svelte';
  import type { PageData } from './$types';

  export let data: PageData;

  console.log("bookmarked", data.bookmarks)

  const go = (iid) => {
    console.log("go", iid)
    window.location.href = `/show/${iid}`
  }

</script>

<div>
  <AutoComplete />
</div>
<div>
  <input 
    on:keyup|preventDefault={(e) => { if(e.key === 'Enter') go(e.currentTarget.value)}} 
    placeholder="tt<imdb id>"
  />
</div>

<div>
  <ul>
    {#each data.bookmarks as show}
      <li>
        <a href="/show/{show.iid}">{show.title} - {show.start_year}</a>
      </li>
    {/each}
  </ul>
</div>
