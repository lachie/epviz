import { writable, type Writable } from 'svelte/store'
import { browser } from '$app/environment';

function fromLocalStorage<T>(storageKey: string, fallbackValue: T): T {
	if (browser) {
		const storedValue = window.localStorage.getItem(storageKey)
		
		if (storedValue !== 'undefined' && storedValue !== null) {
			return (typeof fallbackValue === 'object') 
				? JSON.parse(storedValue)
				: storedValue
		}
	}
	
	return fallbackValue
}

function toLocalStorage<T>(store: Writable<T>, storageKey: string) {
	if (browser) {
		store.subscribe(value => {
			let storageValue = (typeof value === 'object') 
				? JSON.stringify(value)
				: `${value}`
				
			window.localStorage.setItem(storageKey, storageValue)
		})
	}
}

export default function settingStore<T>(key: string, fallback: T) {
	const store = writable<T>(fromLocalStorage(key, fallback))
	toLocalStorage(store, key)
	return store
}
