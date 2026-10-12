import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
	importStyleTables,
	validateStylePack,
	exportStyleTables,
} from '../src/index.mjs';

const tableNames = ['primitives', 'semantics', 'recipes'];
const modes = ['light', 'dark', 'ultraDark', 'transparent'];
const identity = { id: 'kallopis-v1', version: '1.0.0' };
const documents = Object.fromEntries(await Promise.all(tableNames.map(async (name) => [
	name,
	await readFile(new URL(`../../docs/design-tokens/${name}.md`, import.meta.url), 'utf8'),
])));

// 僅辨識公開文件的資料列，不讀產品解析器；保留每個原始儲存格。
function rows(document) {
	return document.split(/\r?\n/)
		.filter((line) => /^\s*\|\s*`[^`]+`/.test(line))
		.map((line) => line.trim().slice(1, -1).split('|').map((cell) => cell.trim()));
}

function unquote(cell) {
	return cell.startsWith('`') && cell.endsWith('`') ? cell.slice(1, -1) : cell;
}

function rowId(row) {
	return /^`([^`]+)`/.exec(row[0])[1];
}

function freshPack() {
	return importStyleTables(documents, identity);
}

// 拒絕必須包含可定位的參數路徑，不能只回傳 false 或吞掉錯誤。
function rejects(pack, path) {
	assert.throws(() => validateStylePack(pack), (error) => {
		assert.ok(error instanceof Error);
		assert.ok(error.message.includes(path), `錯誤必須定位 ${path}：${error.message}`);
		assert.ok(error.message.trim().length > path.length, '錯誤必須包含原因');
		return true;
	});
}

test('正式三表逐格往返，原料型別、來源、四模式及配方原文完整保留', () => {
	const pack = freshPack();
	assert.equal(pack.schemaVersion, 1);
	assert.equal(pack.id, identity.id);
	assert.equal(pack.version, identity.version);
	assert.deepEqual(validateStylePack(pack), pack);
	assert.deepEqual(JSON.parse(JSON.stringify(pack)), pack, '完整 pack 必須可無損交換為 JSON');

	const primitiveRows = rows(documents.primitives);
	assert.deepEqual(Object.keys(pack.primitives).sort(), primitiveRows.map(rowId).sort());
	for (const row of primitiveRows) {
		const id = rowId(row);
		const raw = unquote(row[1]);
		const expected = /^-?\d+(?:\.\d+)?$/.test(raw) ? Number(raw) : raw;
		assert.deepEqual(pack.primitives[id], expected, `原料值 ${id}`);
		assert.equal(pack.primitiveDescriptions[id], row[2], `原料說明 ${id}`);
	}

	const semanticRows = rows(documents.semantics);
	assert.deepEqual(Object.keys(pack.semantics).sort(), semanticRows.map(rowId).sort());
	for (const row of semanticRows) {
		const id = rowId(row);
		assert.equal(pack.semanticDescriptions[id], row[0].slice(id.length + 2), `${id} 語意說明原文`);
		assert.deepEqual(Object.keys(pack.semantics[id]).sort(), [...modes].sort(), `四模式 ${id}`);
		modes.forEach((mode, index) => {
			assert.equal(pack.semantics[id][mode], unquote(row[index + 1]), `${id}.${mode} 原文`);
		});
	}

	const recipeRows = rows(documents.recipes);
	assert.deepEqual(Object.keys(pack.recipes).sort(), recipeRows.map(rowId).sort());
	for (const row of recipeRows) {
		const id = rowId(row);
		assert.equal(pack.recipes[id].aliases, row[1], `${id}.aliases 原文`);
		assert.equal(pack.recipes[id].inherit, row[2], `${id}.inherit 原文`);
		assert.equal(pack.recipes[id].parameters, row[3], `${id}.parameters 原文`);
	}

	const exported = exportStyleTables(pack);
	for (const name of tableNames) {
		assert.equal(typeof exported[name], 'string', `${name} 匯出 Markdown`);
		// 排版與分組不具權威；同一 ID 的所有 cell（含中文語意說明）必須保留。
		const byId = (document) => rows(document).sort((a, b) => rowId(a).localeCompare(rowId(b)));
		assert.deepEqual(byId(exported[name]), byId(documents[name]), `${name} 每個原始 cell`);
	}
	assert.deepEqual(importStyleTables(exported, identity), pack, '第二次匯入不能改變 pack');
});

test('合法 primitive 接受字串、有限數值及其陣列，且不改寫 none 與 inherit', () => {
	const pack = freshPack();
	pack.primitives.space0 = [0, -0.5, 'none', 'inherit', '—'];
	assert.deepEqual(validateStylePack(pack), pack);
	assert.deepEqual(pack.primitives.space0, [0, -0.5, 'none', 'inherit', '—']);
});

test('三種正式表格的重複 ID 都必須在匯入時拒絕', async (context) => {
	for (const name of tableNames) {
		await context.test(name, () => {
			const duplicate = documents[name].split(/\r?\n/).find((line) => /^\s*\|\s*`[^`]+`/.test(line));
			const id = rowId(rows(duplicate)[0]);
			assert.throws(() => importStyleTables({ ...documents, [name]: `${documents[name]}\n${duplicate}\n` }, identity), (error) => {
				assert.ok(error instanceof Error);
				assert.ok(error.message.includes(id), `重複錯誤必須指出 ${id}`);
				return true;
			});
		});
	}
});

test('未知 schemaVersion 及非法結構必須拒絕並定位', async (context) => {
	for (const value of [0, 2, '1', null]) {
		await context.test(`schemaVersion=${JSON.stringify(value)}`, () => {
			const pack = freshPack();
			pack.schemaVersion = value;
			rejects(pack, 'schemaVersion');
		});
	}
	for (const value of [null, [], 42]) {
		await context.test(`root=${JSON.stringify(value)}`, () => {
			assert.throws(() => validateStylePack(value), Error);
		});
	}
	for (const name of tableNames) {
		for (const value of [null, [], 'dictionary']) {
			await context.test(`${name}=${JSON.stringify(value)}`, () => {
				const pack = freshPack();
				pack[name] = value;
				rejects(pack, name);
			});
		}
		await context.test(`${name} 空 ID`, () => {
			const pack = freshPack();
			pack[name][''] = Object.values(pack[name])[0];
			rejects(pack, name);
		});
	}
	for (const name of ['id', 'version']) {
		await context.test(`${name} 空字串`, () => {
			const pack = freshPack();
			pack[name] = '';
			rejects(pack, name);
		});
	}
});

test('非法 primitive 不得通過驗證', async (context) => {
	const invalid = [null, true, {}, NaN, Infinity, -Infinity, [NaN], [null], [true], [[1]], [{ value: 1 }]];
	for (const [index, value] of invalid.entries()) {
		await context.test(`非法原料 ${index}`, () => {
			const pack = freshPack();
			pack.primitives.space0 = value;
			rejects(pack, 'space0');
		});
	}
});

test('任一 semantic 遺漏模式或非文字表達式都必須拒絕', async (context) => {
	for (const mode of modes) {
		await context.test(`缺 ${mode}`, () => {
			const pack = freshPack();
			delete pack.semantics['theme.colors.app'][mode];
			rejects(pack, 'theme.colors.app');
		});
		await context.test(`${mode} 非文字`, () => {
			const pack = freshPack();
			pack.semantics['theme.colors.app'][mode] = 0;
			rejects(pack, 'theme.colors.app');
		});
	}
});

test('recipe 的公開原文字段必須是字串', async (context) => {
	for (const field of ['aliases', 'inherit', 'parameters']) {
		await context.test(field, () => {
			const pack = freshPack();
			pack.recipes['app-background'][field] = {};
			rejects(pack, 'app-background');
		});
	}
});

test('semantic 與 recipe 的缺失 p／s 引用必須拒絕', async (context) => {
	for (const expression of ['p(missing-primitive)', 's(theme.missing-semantic)']) {
		await context.test(`semantic ${expression}`, () => {
			const pack = freshPack();
			pack.semantics['theme.colors.app'].light = expression;
			rejects(pack, 'theme.colors.app');
		});
		await context.test(`recipe ${expression}`, () => {
			const pack = freshPack();
			pack.recipes['app-background'].parameters = `background=${expression}; shadow=none`;
			rejects(pack, 'app-background');
		});
	}
	await context.test('缺 recipe 的 s 引用', () => {
		const pack = freshPack();
		pack.recipes['app-background'].parameters = 'typography=s(missing-recipe)';
		rejects(pack, 'app-background');
	});
});

test('semantic 直接與間接循環都必須拒絕', async (context) => {
	await context.test('直接循環', () => {
		const pack = freshPack();
		pack.semantics['theme.colors.app'].light = 's(theme.colors.app)';
		rejects(pack, 'theme.colors.app');
	});
	await context.test('單一模式間接循環', () => {
		const pack = freshPack();
		pack.semantics['theme.colors.app'].dark = 's(theme.colors.surface)';
		pack.semantics['theme.colors.surface'].dark = 's(theme.colors.app)';
		rejects(pack, 'theme.colors');
	});
});

test('recipe 直接與間接繼承循環都必須拒絕', async (context) => {
	await context.test('直接循環', () => {
		const pack = freshPack();
		pack.recipes['surface-base'].inherit = 'surface-base';
		rejects(pack, 'surface-base');
	});
	await context.test('間接循環', () => {
		const pack = freshPack();
		pack.recipes['surface-base'].inherit = 'surface-inset';
		pack.recipes['surface-inset'].inherit = 'surface-base';
		assert.throws(() => validateStylePack(pack), (error) => {
			assert.ok(error instanceof Error);
			assert.match(error.message, /surface-(?:base|inset)/, '錯誤必須指出循環 recipe');
			return true;
		});
	});
});
