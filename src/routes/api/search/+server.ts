import type { RequestHandler } from '@sveltejs/kit';
import { getAutocompleteResults } from '$lib/db';
import { json } from '@sveltejs/kit';

export const GET: RequestHandler = async ({ url }) => {
  const query = url.searchParams.get('q') || '';
  const titles = await getAutocompleteResults(query);
  return json({ titles });
};
