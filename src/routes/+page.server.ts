import { getBookmarkedShows } from "$lib/db";
import type { PageServerLoad } from "./$types";

const load: PageServerLoad = async () => {
	return { bookmarks: await getBookmarkedShows() };
}
export { load }
