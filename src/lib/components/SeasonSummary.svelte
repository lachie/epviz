<script lang="ts">
  import * as Pancake from '@sveltejs/pancake';
  import type { EpvizData } from "$lib/epviz";

export let epviz: EpvizData

</script>

<div class="chart">
  <Pancake.Chart>
  <Pancake.Svg>
    <Pancake.SvgScatterplot data={points} x="{d => d.date}" y="{d => d.avg}" let:d>
				<path class="avg scatter" {d}/>
			</Pancake.SvgScatterplot>
  </Pancake.Svg>
  </Pancake.Chart>
</div>
