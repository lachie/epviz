<script lang="ts">
  import * as Pancake from '@sveltejs/pancake';
  import type { EpvizData } from "$lib/epviz";

  interface Props {
    epviz: EpvizData;
  }

  let { epviz }: Props = $props();

</script>

<div class="chart">
  <Pancake.Chart>
  <Pancake.Svg>
    <Pancake.SvgScatterplot data={points} x="{d => d.date}" y="{d => d.avg}" >
				{#snippet children({ d })}
                <path class="avg scatter" {d}/>
  			              {/snippet}
            </Pancake.SvgScatterplot>
  </Pancake.Svg>
  </Pancake.Chart>
</div>
