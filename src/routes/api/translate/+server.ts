import { env } from '$env/dynamic/private';
import { json } from '@sveltejs/kit';

export async function POST({ request, fetch }) {
	const { text, direction } = await request.json().catch(() => ({ text: '', direction: 'ja-en' }));

	if (typeof text !== 'string' || !text.trim()) {
		return json({ error: 'Write a line for the owl first.' }, { status: 400 });
	}

	if (text.length > 500) {
		return json({ error: 'Keep each line under 500 characters.' }, { status: 400 });
	}

	if (!env.SHISA_API_KEY) {
		return json({ error: 'Shisa is not connected on this machine yet.' }, { status: 503 });
	}

	const isEnglishToJapanese = direction === 'en-ja';

	const body = new FormData();
	body.set('text', text.trim());
	body.set('source_lang', isEnglishToJapanese ? 'en' : 'ja');
	body.set('target_lang', isEnglishToJapanese ? 'ja' : 'en');
	body.set('stream', 'false');

	try {
		const response = await fetch('https://api.shisa.ai/translate/', {
			method: 'POST',
			headers: { Authorization: `Bearer ${env.SHISA_API_KEY}` },
			body
		});
		const result = await response.json();

		if (!response.ok) {
			return json({ error: 'Shisa could not translate that just now.' }, { status: response.status });
		}

		return json({ translation: result?.choices?.[0]?.message?.content ?? '' });
	} catch {
		return json({ error: 'The owl could not reach Shisa.' }, { status: 502 });
	}
}
