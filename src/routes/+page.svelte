<script lang="ts">
  import type { PageData } from "./$types";
  interface Props {
    data: PageData;
  }

  let { data }: Props = $props();
</script>

<div>
  <ul class="divide-y divide-slate-700">
    {#each data.bookmarks as show}
      <li
        class="divide-y divide-slate-200 p-4 hover:bg-slate-500 hover:rounded-2xl group"
      >
        <a href="/show/{show.iid}">
          <div
            class="text-lg font-semibold text-slate-200 group-hover:text-slate-100"
          >
            {show.favourite ? "⭐" : ""}
            {show.title}
            <div class="text-sm text-slate-500 group-hover:text-slate-300">
              {show.start_year} &mdash; {show.end_year || ""}
            </div>
          </div></a
        >
      </li>
    {/each}
  </ul>
</div>
