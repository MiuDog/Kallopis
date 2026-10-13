import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

export const repository = fileURLToPath(new URL('../../', import.meta.url));
export const sourceDirectory = fileURLToPath(new URL('../../docs/design-tokens/', import.meta.url));
export const modes = ['light', 'dark', 'ultraDark', 'transparent'];
export const documents = Object.fromEntries(['primitives', 'semantics', 'recipes'].map(name => [name, readFileSync(`${sourceDirectory}/${name}.md`, 'utf8')]));

// 只解析正式表格，預期值不依賴套件的產生器或私有程式。
function rows(document) {
	return document.split(/\r?\n/).filter(line => /^\|\s*`/.test(line)).map(line => line.split('|').slice(1, -1).map(cell => cell.trim()));
}

function unquote(value) {
	return value.replace(/^`|`$/g, '');
}

function primitive(value) {
	if (/^-?\d+(?:\.\d+)?$/.test(value)) return Number(value);
	if (value.startsWith('[')) return JSON.parse(value);
	return value;
}

export const expectedPrimitives = Object.fromEntries(rows(documents.primitives).map(([id, value]) => [unquote(id), primitive(unquote(value))]));
export const expectedRecipes = Object.fromEntries(rows(documents.recipes).map(([id, aliases, inherit, parameters]) => [unquote(id), { aliases, inherit, parameters }]));
export const semanticExpressions = Object.fromEntries(rows(documents.semantics).filter(([id]) => id.startsWith('`theme.')).map(([id, ...expressions]) => [id.match(/^`([^`]+)`/)[1], expressions.map(unquote)]));

function browserValue(value) {
	if (Array.isArray(value)) return value.map(browserValue);
	if (typeof value !== 'string') return value;
	if (/^#[\dA-Fa-f]{8}$/.test(value)) return `#${value.slice(3)}${value.slice(1, 3)}`.toUpperCase();
	return value.replace(/^packages\/kallopis\//, '');
}

export function expectedTheme(mode) {
	const column = modes.indexOf(mode);
	const result = {};
	const active = new Set();
	function resolve(id) {
		if (Object.hasOwn(result, id)) return result[id];
		if (active.has(id)) throw new Error(`正式規格有循環 ${id}`);
		active.add(id);
		result[id] = expression(semanticExpressions[id][column]);
		active.delete(id);
		return result[id];
	}
	function expression(text) {
		const reference = text.match(/^([ps])\(([^()]+)\)$/);
		if (reference) return reference[1] === 'p' ? browserValue(expectedPrimitives[reference[2]]) : resolve(reference[2]);
		if (text.startsWith('[')) return [...text.matchAll(/p\(([^()]+)\)/g)].map(match => browserValue(expectedPrimitives[match[1]]));
		const addition = text.match(/^add\(s\(([^()]+)\),\s*s\(([^()]+)\)\)$/);
		if (addition) return resolve(addition[1]) + resolve(addition[2]);
		throw new Error(`測試參考解析器無法辨識正式表達式 ${text}`);
	}
	Object.keys(semanticExpressions).forEach(resolve);
	return result;
}
