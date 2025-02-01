<script lang="ts">
	import { run } from 'svelte/legacy';

	import { onMount, createEventDispatcher } from 'svelte'
	import Konva from 'konva'

type Dim = {
	width: number
	height: number
}

const dispatch = createEventDispatcher<{resized: Dim}>();

	let width = 0
	let height = 0
	
	interface Props {
		stage: Konva.Stage;
	}

	let { stage = $bindable() }: Props = $props();
	let container: HTMLDivElement = $state()


	
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
	run(() => {
		if(stage) {
			handleSize()
		}
	});
</script>

<svelte:window onresize={handleSize} />

<div 
	bind:this={container}
	style:border="1px solid black"
	style:background="#eee"></div>

<style>
	div {
		width: 100%;
	}
</style>

