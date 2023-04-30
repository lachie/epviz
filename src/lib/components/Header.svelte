<script lang="ts">
  import AutoComplete from '$lib/components/AutoComplete.svelte';
</script>

<div class="gap-4 bg-slate-600 p-4 navbar">
  <a href="/" class="btn btn-ghost normal-case text-xl">Epviz</a>
  <div class="flex-1 navbar-end">
    <AutoComplete />
  </div>
</div>
