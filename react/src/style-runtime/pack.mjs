const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const unsafeKeys = new Set(['__proto__', 'prototype', 'constructor']);

export function importStyleTables(documents, identity) {

	const primitives = {}, primitiveDescriptions = {}, semantics = {}, semanticDescriptions = {}, recipes = {};
	for (const [id, cells, description] of tableRows(documents.primitives, 'primitives', 3)) {
		primitives[id] = primitiveValue(unquote(cells[1]));
		primitiveDescriptions[id] = cells[2];
	}
	for (const [id, cells, description] of tableRows(documents.semantics, 'semantics', 5)) {
		semantics[id] = Object.fromEntries(modes.map((mode, index) => [mode, unquote(cells[index + 1])]));
		semanticDescriptions[id] = description;
	}
	for (const [id, cells] of tableRows(documents.recipes, 'recipes', 4)) {
		recipes[id] = {
			/* aliases：保留原有雙語查詢名稱，不影響元件身份。 */
			aliases: cells[1],
			/* inherit：保存原始繼承記號，合法性由驗證器判斷。 */
			inherit: cells[2],
			/* parameters：先保存既有配方原文，避免遷移時自行改設計。 */
			parameters: cells[3],
		};
	}
	const pack = {
		/* schemaVersion：交換契約版本，未知版本禁止部分套用。 */
		schemaVersion: 1,
		/* id／version：風格身份及版本，不是框架 library 版本。 */
		id: identity.id,
		version: identity.version,
		/* primitives／semantics／recipes：分別擁有值、用途及視覺組合。 */
		primitives,
		semantics,
		recipes,
		/* descriptions：文件說明不重複保存任何風格值。 */
		primitiveDescriptions,
		semanticDescriptions,
	};
	return validateStylePack(pack);
}

export function validateStylePack(pack) {

	dictionary(pack, 'pack');
	if (pack.schemaVersion !== 1) fail('schemaVersion', 'unsupported version');
	text(pack.id, 'id');
	text(pack.version, 'version');
	for (const name of ['primitives', 'semantics', 'recipes', 'primitiveDescriptions', 'semanticDescriptions']) dictionary(pack[name], name);
	for (const [id, value] of Object.entries(pack.primitives)) {
		identifier(id, `primitives.${id}`);
		const values = Array.isArray(value) ? value : [value];
		if (!values.every(entry => typeof entry === 'string' || typeof entry === 'number' && Number.isFinite(entry))) fail(`primitives.${id}`, 'expected string, finite number or scalar array');
		text(pack.primitiveDescriptions[id], `primitiveDescriptions.${id}`, true);
	}
	for (const [id, expressions] of Object.entries(pack.semantics)) {
		identifier(id, `semantics.${id}`);
		dictionary(expressions, `semantics.${id}`);
		if (Object.keys(expressions).length !== modes.length) fail(`semantics.${id}`, 'expected exactly four modes');
		for (const mode of modes) text(expressions[mode], `semantics.${id}.${mode}`);
		text(pack.semanticDescriptions[id], `semanticDescriptions.${id}`, true);
	}
	for (const [id, recipe] of Object.entries(pack.recipes)) {
		identifier(id, `recipes.${id}`);
		dictionary(recipe, `recipes.${id}`);
		for (const field of ['aliases', 'inherit', 'parameters']) text(recipe[field], `recipes.${id}.${field}`, true);
	}
	for (const mode of modes) validateSemantics(pack, mode);
	validateRecipes(pack);
	return pack;
}

export function exportStyleTables(pack) {

	validateStylePack(pack);
	return {
		/* 每份輸出只含正式資料表，章節排版與說明由文件擁有。 */
		primitives: markdownTable(['Primitive名稱', '實際值', '來源'], Object.entries(pack.primitives).map(([id, value]) => [code(id), code(Array.isArray(value) ? JSON.stringify(value) : String(value)), pack.primitiveDescriptions[id]])),
		semantics: markdownTable(['Semantic ID', ...modes], Object.entries(pack.semantics).map(([id, values]) => [code(id) + pack.semanticDescriptions[id], ...modes.map(mode => code(values[mode]))])),
		recipes: markdownTable(['Semantic ID', '自然語言／別名', '繼承', '設計參數'], Object.entries(pack.recipes).map(([id, recipe]) => [code(id), recipe.aliases, recipe.inherit, recipe.parameters])),
	};
}

function tableRows(document, name, columns) {

	text(document, name);
	const result = [], seen = new Set();
	for (const line of document.split(/\r?\n/)) {
		if (!/^\s*\|\s*`/.test(line)) continue;

		const cells = line.trim().slice(1, -1).split('|').map(cell => cell.trim());
		const match = cells[0].match(/^`([^`]+)`(.*)$/);
		if (!match || cells.length !== columns) fail(name, 'invalid data row');
		const [, id, description] = match;
		identifier(id, `${name}.${id}`);
		if (seen.has(id)) fail(`${name}.${id}`, 'duplicate ID');
		seen.add(id);
		result.push([id, cells, description]);
	}
	if (!result.length) fail(name, 'missing data rows');
	return result;
}

function validateSemantics(pack, mode) {

	const complete = new Set(), active = new Set();
	function visit(id) {

		if (complete.has(id)) return;

		const path = `semantics.${id}.${mode}`;
		if (active.has(id)) fail(path, 'semantic cycle');
		active.add(id);
		const expression = pack.semantics[id][mode];
		const single = /^[ps]\([^()]+\)$/.test(expression);
		const list = /^\[p\([^()]+\)(?:,\s*p\([^()]+\))*\]$/.test(expression);
		const addition = /^add\(s\([^()]+\),\s*s\([^()]+\)\)$/.test(expression);
		if (!single && !list && !addition) fail(path, 'unknown expression');
		for (const [, kind, target] of expression.matchAll(/([ps])\(([^()]+)\)/g)) {
			const values = kind === 'p' ? pack.primitives : pack.semantics;
			if (!Object.hasOwn(values, target)) fail(path, `missing reference ${target}`);
			if (kind === 's') visit(target);
		}
		active.delete(id);
		complete.add(id);
	}
	Object.keys(pack.semantics).forEach(visit);
}

function validateRecipes(pack) {

	const complete = new Set(), active = new Set();
	function visit(id) {

		if (complete.has(id)) return;

		const path = `recipes.${id}`;
		if (!Object.hasOwn(pack.recipes, id)) fail(path, 'missing inherited recipe');
		if (active.has(id)) fail(path, 'recipe inheritance cycle');
		active.add(id);
		const recipe = pack.recipes[id];
		if (recipe.inherit !== '—' && !recipe.inherit.startsWith('繼承')) visit(unquote(recipe.inherit));
		for (const [, kind, target] of recipe.parameters.matchAll(/([ps])\(([^()]+)\)/g)) {
			let values = pack.recipes;
			if (kind === 'p') values = pack.primitives;
			else if (target.startsWith('theme.')) values = pack.semantics;
			if (!Object.hasOwn(values, target)) fail(path, `missing reference ${target}`);
		}
		active.delete(id);
		complete.add(id);
	}
	Object.keys(pack.recipes).forEach(visit);
}

function primitiveValue(value) {

	if (/^-?\d+(?:\.\d+)?$/.test(value)) return Number(value);

	// 陣列記號保留來源表示法；跨框架 typed resolver 在下一 slice 解析。
	return value;
}

function dictionary(value, path) {

	if (!value || typeof value !== 'object' || Array.isArray(value) || ![Object.prototype, null].includes(Object.getPrototypeOf(value))) fail(path, 'expected dictionary');
}

function identifier(value, path) {

	text(value, path);
	if (value !== value.trim() || unsafeKeys.has(value)) fail(path, 'unsafe or padded ID');
}

function text(value, path, allowEmpty = false) {

	if (typeof value !== 'string' || !allowEmpty && !value.trim()) fail(path, 'expected text');
}

function unquote(value) {

	return value.startsWith('`') && value.endsWith('`') ? value.slice(1, -1) : value;
}

function code(value) {

	return `\`${value}\``;
}

function markdownTable(headers, rows) {

	return [headers, headers.map(() => '---'), ...rows].map(row => `| ${row.join(' | ')} |`).join('\n') + '\n';
}

function fail(path, reason) {

	throw new Error(`${path}: ${reason}`);
}
