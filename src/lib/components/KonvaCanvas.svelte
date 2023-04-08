<script lang="ts">
	import { onMount, createEventDispatcher } from 'svelte'
	import Konva from 'konva'

type Dim = {
	width: number
	height: number
}

const dispatch = createEventDispatcher<{resized: Dim}>();

	let width = 0
	let height = 0
	
  export let stage: Konva.Stage
	let container: HTMLDivElement


	$: {
		if(stage) {
			handleSize()
		}
	}
	
	onMount(async () => {
		stage = new Konva.Stage({
			container,
			height,
			width,
		});
	})

	const handleSize = () => {
		const heightRatio = 1.5;

		const width = container.offsetWidth
		const height = width * heightRatio;

		stage.width(width)
		stage.height(height)
		console.log("handleSize", width, height)

		dispatch('resized', { width, height })
	}
</script>

<svelte:window on:resize={handleSize} />

<div 
	bind:this={container}
	style:border="1px solid black"
	style:background="#eee"/>

<style>
	div {
		width: 100%;
	}
</style>

