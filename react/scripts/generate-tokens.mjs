import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createHash } from 'node:crypto';
import { exportStyleTables } from '../../styles/src/index.mjs';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const args = process.argv.slice(2);
const option = (name, fallback) => args.includes(name) ? args[args.indexOf(name) + 1] : fallback;
const source = option('--source-dir', resolve(root, 'docs/design-tokens'));
const output = option('--output-dir', resolve(root, 'react/src'));
const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const unquote = value => value.replace(/^`|`$/g, '');
const documents = {};
const packText = readFileSync(resolve(root, 'styles/kallopis-v1.json'), 'utf8');
const packTables = exportStyleTables(JSON.parse(packText));
if (!args.includes('--source-dir')) documents['styles/kallopis-v1.json'] = createHash('sha256').update(packText).digest('hex');

// 僅接受正式表格中的識別碼；重複鍵不得被後列靜默覆蓋。
function table(name) {
	const text = args.includes('--source-dir') ? readFileSync(resolve(source, `${name}.md`), 'utf8') : packTables[name];
	documents[name] = createHash('sha256').update(text).digest('hex');
	const result = {};
	for (const line of text.split(/\r?\n/).filter(line => /^\|\s*`/.test(line))) {
		const [first, ...values] = line.split('|').slice(1, -1).map(cell => cell.trim());
		const id = first.match(/^`([^`]+)`/)?.[1];
		if (!id) throw new Error(`Unknown identifier: ${first}`);
		if (Object.hasOwn(result, id)) throw new Error(`Duplicate ${name} ID: ${id}`);
		result[id] = values;
	}
	return result;
}

function browserValue(value) {
	if (Array.isArray(value)) return value.map(browserValue);
	if (typeof value !== 'string') return value;
	if (/^#[\dA-Fa-f]{8}$/.test(value)) return `#${value.slice(3)}${value.slice(1, 3)}`.toUpperCase();
	return value.replace(/^packages\/kallopis\//, '');
}

try {
	const primitives = Object.fromEntries(Object.entries(table('primitives')).map(([id, [raw]]) => {
		const text = unquote(raw);
		return [id, /^-?\d+(?:\.\d+)?$/.test(text) ? Number(text) : text.startsWith('[') ? JSON.parse(text) : text];
	}));
	const expressions = table('semantics');
	const recipes = Object.fromEntries(Object.entries(table('recipes')).map(([id, [aliases, inherit, parameters]]) => [id, { aliases, inherit, parameters }]));
	const requireKey = (object, id) => {
		if (!Object.hasOwn(object, id)) throw new Error(`Missing reference: ${id}`);
		return object[id];
	};
	const themes = {};
	for (const [column, mode] of modes.entries()) {
		const tokens = {};
		const active = new Set();
		function semantic(id) {
			if (Object.hasOwn(tokens, id)) return tokens[id];
			if (active.has(id)) throw new Error(`Semantic cycle: ${id}`);
			active.add(id);
			const columns = requireKey(expressions, id);
			if (columns.length !== 4) throw new Error(`Unknown theme columns: ${id}`);
			const value = expression(unquote(columns[column]));
			active.delete(id);
			return tokens[id] = value;
		}
		function expression(text) {
			const reference = text.match(/^([ps])\(([^()]+)\)$/);
			if (reference) return reference[1] === 'p' ? browserValue(requireKey(primitives, reference[2])) : semantic(reference[2]);
			if (/^\[p\([^()]+\)(?:,\s*p\([^()]+\))*\]$/.test(text)) return [...text.matchAll(/p\(([^()]+)\)/g)].map(match => browserValue(requireKey(primitives, match[1])));
			const add = text.match(/^add\(s\(([^()]+)\),\s*s\(([^()]+)\)\)$/);
			if (add) {
				const left = semantic(add[1]), right = semantic(add[2]);
				if (typeof left !== 'number' || typeof right !== 'number') throw new Error(`Unknown numeric expression: ${text}`);
				return left + right;
			}
			throw new Error(`Unknown theme expression: ${text}`);
		}
		Object.keys(expressions).forEach(semantic);
		themes[mode] = tokens;
	}
	// 配方的自然語言條件保留原文；明確繼承及引用仍須完整驗證。
	const checked = new Set(), activeRecipes = new Set();
	function recipe(id) {
		if (checked.has(id)) return;
		if (activeRecipes.has(id)) throw new Error(`Recipe cycle: ${id}`);
		activeRecipes.add(id);
		const data = requireKey(recipes, id);
		if (data.inherit !== '—' && !data.inherit.startsWith('繼承')) recipe(unquote(data.inherit));
		for (const match of data.parameters.matchAll(/([ps])\(([^()]+)\)/g)) {
			if (match[1] === 'p') requireKey(primitives, match[2]);
			else if (match[2].startsWith('theme.')) requireKey(expressions, match[2]);
			else requireKey(recipes, match[2]);
		}
		activeRecipes.delete(id);
		checked.add(id);
	}
	Object.keys(recipes).forEach(recipe);
	const variable = id => `--klp-${id.replace(/^theme\./, '').replaceAll('.', '-')}`;
	const cssValue = (id, value) => Array.isArray(value) ? value.map(entry => typeof entry === 'string' && !['serif', 'sans-serif', 'monospace'].includes(entry) ? JSON.stringify(entry) : entry).join(', ') : typeof value === 'number' && /(?:spacing|shape|geometry|components)\./.test(id) && !/(?:Opacity|Factor|Lines|Ratio|BaselineOffsetY)/.test(id) ? `${value}px` : String(value);
	const outputs = {
		'generated.ts': `// 由正式規範產生，禁止手改。\nexport const klpPrimitives = ${JSON.stringify(primitives, null, '\t')} as const;\nexport const klpRecipes = ${JSON.stringify(recipes, null, '\t')} as const;\nexport const klpThemes = ${JSON.stringify(themes, null, '\t')} as const;\n`,
		'tokens.css': modes.map(mode => `[data-klp-mode="${mode}"] {\n${Object.entries(themes[mode]).map(([id, value]) => `\t${variable(id)}: ${cssValue(id, value)};`).join('\n')}\n}`).join('\n') + '\n',
		'source-manifest.json': JSON.stringify({ sources: documents, primitives: Object.keys(primitives), semantics: Object.keys(expressions), recipes: Object.keys(recipes), modes }, null, '\t') + '\n',
	};
	for (const [name, content] of Object.entries(outputs)) {
		const path = resolve(output, name);
		if (args.includes('--check')) {
			if (readFileSync(path, 'utf8') !== content) throw new Error(`Generated output stale: ${name}`);
		} else {
			mkdirSync(output, { recursive: true });
			writeFileSync(path, content);
		}
	}
	console.log(`Tokens: ${Object.keys(primitives).length} primitives, ${Object.keys(expressions).length} semantics × ${modes.length}, ${checked.size} recipes`);
} catch (error) {
	console.error(error.message);
	process.exitCode = 1;
}
