import { error } from '@sveltejs/kit';
import { getBookmarked, getEpvizData, getShow, setBookmarked, setFavourited } from '$lib/db';
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
    const show = await getShow(params.iid);
    const epviz = await getEpvizData(params.iid);
    const [bookmarked, favourited] = await getBookmarked(params.iid);

    return { epviz, show, iid: params.iid, bookmarked, favourited };
  } catch (e) {
    console.error(e);
    throw error(404, 'Not found');
  }
 
  //throw error(404, 'Not found');
}

export { load }
