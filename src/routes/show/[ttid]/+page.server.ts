import { error } from '@sveltejs/kit';
import { getEpvizData, getShow } from '$lib/db';
import type { PageServerLoad } from './$types';
 
const load: PageServerLoad = async ({ params }) => {

  try {
    const show = await getShow(params.ttid);
    const epviz = await getEpvizData(params.ttid);

    return { epviz, show };
  } catch (e) {
    console.error(e);
    throw error(404, 'Not found');
  }
 
  //throw error(404, 'Not found');
}

export { load }
