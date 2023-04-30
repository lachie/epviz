<script>
		import Header from "$lib/components/Header.svelte";
import "../app.css";
</script>

<nav>
  <Header />
</nav>

<div class="container mx-auto mt-6">
  <slot></slot>
</div>

<style>	
</style>
