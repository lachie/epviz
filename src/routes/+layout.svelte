<script lang="ts">
		import Header from "$lib/components/Header.svelte";
import "../app.css";
  interface Props {
    children?: import('svelte').Snippet;
  }

  let { children }: Props = $props();
</script>

<nav>
  <Header />
</nav>

<div class="container mx-auto mt-6">
  {@render children?.()}
</div>

<style>	
</style>
