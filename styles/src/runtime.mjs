import { validateStylePack } from './pack.mjs';

const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const numericTypes = new Set(['length', 'ratio', 'opacity', 'duration', 'weight', 'count']);
const colorPattern = /^#(?:[\da-f]{6}|[\da-f]{8})$/i;

export function resolveStylePack(pack, mode, catalog) {

	validateStylePack(pack);
	if (!modes.includes(mode)) fail('mode', `unsupported mode ${mode}`);
	validateCatalog(catalog, pack);
	const tokens = {};
	function semantic(id) {

		if (Object.hasOwn(tokens, id)) return tokens[id];

		const expression = pack.semantics[id][mode];
		const reference = expression.match(/^([ps])\(([^()]+)\)$/);
		let value;
		if (reference) value = reference[1] === 'p' ? pack.primitives[reference[2]] : semantic(reference[2]);
		else if (expression.startsWith('[')) value = [...expression.matchAll(/p\(([^()]+)\)/g)].map(match => pack.primitives[match[1]]);
		else {
			const references = [...expression.matchAll(/s\(([^()]+)\)/g)].map(match => semantic(match[1]));
			if (references.length !== 2 || !references.every(entry => typeof entry === 'number')) fail(id, 'add requires two numbers');
			value = references[0] + references[1];
		}
		const resolved = typedValue(value, catalog.parameters[id], id);
		tokens[id] = resolved;
		return resolved;
	}
	Object.keys(pack.semantics).forEach(semantic);
	validateConstraints(tokens, catalog.constraints);
	const snapshot = {
		/* id／version／mode：保留風格身份及本次解析的主題，不取代產品狀態。 */
		id: pack.id,
		version: pack.version,
		mode,
		/* tokens：只含已驗證的 typed 值，平台轉換由框架 adapter 擁有。 */
		tokens,
		/* recipes：完整保存原文；不得假稱本 slice 已實作所有配方運算。 */
		recipes: pack.recipes,
	};
	// 複製後凍結，禁止 provider 的 snapshot 凍結或共享 consumer 輸入資料。
	return freeze(structuredClone(snapshot));
}

export function applyStyleOverrides(pack, overrides, catalog) {

	validateStylePack(pack);
	dictionary(overrides, 'overrides');
	for (const key of Object.keys(overrides)) {
		if (!['primitives', 'semantics'].includes(key)) fail(`overrides.${key}`, 'unsupported override section');
	}
	// 整體複製與驗證後才交付，原 pack 與已存在 snapshot 不會被部分修改。
	const next = structuredClone(pack);
	if (Object.hasOwn(overrides, 'primitives')) {
		dictionary(overrides.primitives, 'overrides.primitives');
		for (const [id, value] of Object.entries(overrides.primitives)) {
			if (!Object.hasOwn(pack.primitives, id)) fail(`primitives.${id}`, 'unknown override ID');
			next.primitives[id] = structuredClone(value);
		}
	}
	if (Object.hasOwn(overrides, 'semantics')) {
		dictionary(overrides.semantics, 'overrides.semantics');
		for (const [id, expressions] of Object.entries(overrides.semantics)) {
			if (!Object.hasOwn(pack.semantics, id)) fail(`semantics.${id}`, 'unknown override ID');
			dictionary(expressions, `semantics.${id}`);
			for (const [mode, expression] of Object.entries(expressions)) {
				if (!modes.includes(mode)) fail(`semantics.${id}.${mode}`, 'unknown override mode');
				next.semantics[id][mode] = expression;
			}
		}
	}
	for (const mode of modes) resolveStylePack(next, mode, catalog);
	return next;
}

function validateCatalog(catalog, pack) {

	dictionary(catalog, 'catalog');
	if (catalog.schemaVersion !== 1) fail('catalog.schemaVersion', 'unsupported version');
	dictionary(catalog.parameters, 'catalog.parameters');
	if (!Array.isArray(catalog.constraints)) fail('catalog.constraints', 'expected array');
	for (const id of Object.keys(pack.semantics)) {
		if (!Object.hasOwn(catalog.parameters, id)) fail(id, 'missing catalog metadata');
		dictionary(catalog.parameters[id], `catalog.${id}`);
		const metadata = catalog.parameters[id];
		if (typeof metadata.unit !== 'string' || !metadata.unit) fail(id, 'missing parameter unit');
		for (const field of ['min', 'max', 'exclusiveMin']) {
			if (Object.hasOwn(metadata, field) && (typeof metadata[field] !== 'number' || !Number.isFinite(metadata[field]))) fail(id, `invalid ${field}`);
		}
		if (metadata.min !== undefined && metadata.max !== undefined && metadata.min > metadata.max) fail(id, 'catalog min exceeds max');
	}
}

function typedValue(value, metadata, id) {

	const type = metadata.type;
	if (numericTypes.has(type)) {
		if (typeof value !== 'number' || !Number.isFinite(value)) fail(id, `expected finite ${type}`);
		if (metadata.integer && !Number.isInteger(value)) fail(id, 'expected integer');
		if (metadata.min !== undefined && value < metadata.min) fail(id, `value below ${metadata.min}`);
		if (metadata.max !== undefined && value > metadata.max) fail(id, `value above ${metadata.max}`);
		if (metadata.exclusiveMin !== undefined && value <= metadata.exclusiveMin) fail(id, `value must exceed ${metadata.exclusiveMin}`);
		return value;
	}
	if (type === 'curve') {
		let curve = value;
		if (typeof curve === 'string') {
			// 曲線只接受 JSON 四點資料；不執行任意表達式或函式。
			try { curve = JSON.parse(curve); }
			catch { fail(id, 'invalid curve JSON'); }
		}
		if (!Array.isArray(curve) || curve.length !== 4 || !curve.every(point => typeof point === 'number' && Number.isFinite(point))) fail(id, 'expected four finite curve points');
		if (curve[0] < 0 || curve[0] > 1 || curve[2] < 0 || curve[2] > 1) fail(id, 'curve x coordinates must be in [0,1]');
		return curve;
	}
	if (type === 'color') {
		if (typeof value !== 'string' || !colorPattern.test(value)) fail(id, 'expected #RRGGBB or #AARRGGBB color');
		return value;
	}
	if (type === 'font-family' || type === 'symbol') {
		if (typeof value !== 'string' || !value.trim()) fail(id, `expected ${type} string`);
		return value;
	}
	if (type === 'color-array' || type === 'font-family-array') {
		if (!Array.isArray(value) || !value.length) fail(id, `expected nonempty ${type}`);
		for (const entry of value) {
			const valid = typeof entry === 'string' && entry.trim() && (type !== 'color-array' || colorPattern.test(entry));
			if (!valid) fail(id, `invalid ${type} entry`);
		}
		return value;
	}
	fail(id, `unknown catalog type ${type}`);
}

function validateConstraints(tokens, constraints) {

	function number(id) {

		if (!Object.hasOwn(tokens, id) || typeof tokens[id] !== 'number') fail(id, 'constraint requires numeric token');
		return tokens[id];
	}
	for (const [index, rule] of constraints.entries()) {
		dictionary(rule, `catalog.constraints.${index}`);
		if (rule.kind === 'ordered') {
			if (!Array.isArray(rule.ids) || rule.ids.length < 2) fail(`catalog.constraints.${index}`, 'ordered requires two or more IDs');
			const values = rule.ids.map(number);
			for (let position = 1; position < values.length; position++) {
				if (values[position - 1] > values[position]) fail(rule.ids[position - 1], `must not exceed ${rule.ids[position]}`);
			}
		}
		else if (rule.kind === 'fits') {
			if (!Array.isArray(rule.containers) || !rule.containers.length) fail(`catalog.constraints.${index}`, 'fits requires container IDs');
			const extent = number(rule.child) + 2 * number(rule.inset);
			if (!Number.isFinite(extent) || extent > Math.min(...rule.containers.map(number))) fail(rule.child, `does not fit ${rule.containers.join(', ')}`);
		}
		else fail(`catalog.constraints.${index}`, `unknown constraint ${rule.kind}`);
	}
}

function freeze(value, seen = new Set()) {

	if (!value || typeof value !== 'object' || seen.has(value)) return value;

	seen.add(value);
	Object.values(value).forEach(entry => freeze(entry, seen));
	return Object.freeze(value);
}

function dictionary(value, path) {

	if (!value || typeof value !== 'object' || Array.isArray(value) || ![Object.prototype, null].includes(Object.getPrototypeOf(value))) fail(path, 'expected dictionary');
}

function fail(path, reason) {

	throw new Error(`${path}: ${reason}`);
}
