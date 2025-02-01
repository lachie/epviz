import { error } from '@sveltejs/kit';
import { getBookmarked, getEpvizData, getShow, setBookmarked, setFavourited, setLastViewed } from '$lib/db';
import type { PageServerLoad, Actions } from './$types';

export const actions = {
  bookmark: async (event) => {
    await setBookmarked(event.params.iid, true)
  },
  unbookmark: async (event) => {
    await setBookmarked(event.params.iid, false)
  },
  fave: async (event) => {
    await setFavourited(event.params.iid, true)
  },
  unfave: async (event) => {
    await setFavourited(event.params.iid, false)
  }
} satisfies Actions;

const load: PageServerLoad = async ({ params }) => {

  try {
    const values = await Promise.all([getShow(params.iid), getEpvizData(params.iid), getBookmarked(params.iid)] as const)
    const [show, epviz, [bookmarked, favourited]] = values

    return { epviz, show, iid: params.iid, bookmarked, favourited };
  } catch (e) {
    console.error(e);
    error(404, 'Not found');
  }
}

export { load }
