import { applyStyleOverrides, resolveStylePack, validateStylePack, type KlpStylePack, type KlpStyleOverrides, type KlpStyleValue } from './style-runtime/index.mjs';
import { defaultStylePack, styleCatalog } from './style-pack-data.js';

export type { KlpStylePack, KlpStyleOverrides } from './style-runtime/index.mjs';

// 目錄限制獨立於 consumer pack，深度保護每一個參數及其用途清單。
function freeze<T>(value: T): T {
	if (value && typeof value === 'object' && !Object.isFrozen(value)) {
		for (const child of Object.values(value)) freeze(child);
		Object.freeze(value);
	}
	return value;
}
export const klpStyleParameters = freeze(styleCatalog.parameters);

export function createKlpStylePack(input: unknown = defaultStylePack): KlpStylePack {
	const pack = validateStylePack(typeof input === 'string' ? JSON.parse(input) : input);
	const canonical = defaultStylePack as KlpStylePack;
	// 元件所需的固定語意不可被替換風格刪除；新值不改變合法組合。
	for (const section of ['primitives', 'semantics', 'recipes'] as const) {
		for (const id of Object.keys(canonical[section])) {
			if (!Object.hasOwn(pack[section], id)) throw new Error(`Missing canonical ${section}.${id}`);
		}
	}
	for (const mode of ['light', 'dark', 'ultraDark', 'transparent'] as const) resolveStylePack(pack, mode, styleCatalog);
	return freeze(structuredClone(pack));
}

export function applyKlpStyleOverrides(pack: KlpStylePack, overrides: KlpStyleOverrides): KlpStylePack {
	return createKlpStylePack(applyStyleOverrides(pack, overrides, styleCatalog));
}

// CSS 色碼與字型名稱是平台表示法；common 資料保留 ARGB 及 package ownership。
export function browserStyleValue(value: KlpStyleValue): KlpStyleValue {
	if (Array.isArray(value)) return Object.freeze(value.map(browserStyleValue)) as readonly (string | number)[];
	if (typeof value !== 'string') return value;
	if (/^#[\dA-Fa-f]{8}$/.test(value)) return `#${value.slice(3)}${value.slice(1, 3)}`.toUpperCase();
	return value.replace(/^packages\/kallopis\//, '');
}

export function styleVariables(tokens: Readonly<Record<string, KlpStyleValue>>): Record<string, string> {
	return Object.fromEntries(Object.entries(tokens).map(([id, value]) => {
		const parameter = klpStyleParameters[id as keyof typeof klpStyleParameters];
		let encoded: string;
		if (parameter.type === 'curve') encoded = `cubic-bezier(${(value as readonly number[]).join(', ')})`;
		else if (Array.isArray(value)) encoded = value.map(entry => parameter.type === 'font-family-array' && typeof entry === 'string' && !['serif', 'sans-serif', 'monospace'].includes(entry) ? JSON.stringify(entry) : entry).join(', ');
		else if (parameter.type === 'length' && !id.startsWith('theme.typography.')) encoded = `${value}px`;
		else encoded = String(value);
		return [`--klp-${id.replace(/^theme\./, '').replaceAll('.', '-')}`, encoded];
	}));
}

export function resolveBrowserStyle(pack: KlpStylePack, mode: 'light' | 'dark' | 'ultraDark' | 'transparent') {
	const snapshot = resolveStylePack(createKlpStylePack(pack), mode, styleCatalog);
	return Object.freeze(Object.fromEntries(Object.entries(snapshot.tokens).map(([id, value]) => [id, browserStyleValue(value)])));
}
