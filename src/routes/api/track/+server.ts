import type { RequestHandler } from '@sveltejs/kit';
import { setLastViewed } from '$lib/db';
import { text } from '@sveltejs/kit';

export const POST: RequestHandler = async ({ request }) => {
    const { iid } = await request.json() as { iid: string };
    await setLastViewed(iid);
    return text('ok')
};
