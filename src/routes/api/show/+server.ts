import type { RequestHandler } from '@sveltejs/kit';
import { getShowWithEpisodesGrouped } from '$lib/db';
import { json } from '@sveltejs/kit';

export const GET: RequestHandler = async ({ url }) => {
  console.log('request', url);
  const ttid = url.searchParams.get('id') || '';
  const show = await getShowWithEpisodesGrouped(ttid);

  console.log('show', show);
  return json(show);
};

