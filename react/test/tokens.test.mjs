import assert from 'node:assert/strict';
import test from 'node:test';
import { createHash } from 'node:crypto';
import { mkdtempSync, writeFileSync, readFileSync, existsSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';
import * as publicApi from '../dist/index.js';
import { documents, expectedPrimitives, expectedRecipes, expectedTheme, modes, repository, semanticExpressions } from './source-contract.mjs';

test('全部正式 primitive、配方與四主題完整保留且平台轉換正確', () => {
	assert.equal(Object.keys(expectedPrimitives).length, 270);
	assert.equal(Object.keys(expectedRecipes).length, 118);
	assert.equal(Object.keys(semanticExpressions).length, 350);
	assert.deepEqual(publicApi.klpPrimitives, expectedPrimitives);
	assert.deepEqual(publicApi.klpRecipes, expectedRecipes);
	assert.deepEqual(Object.keys(publicApi.klpThemes).sort(), [...modes].sort());
	for (const mode of modes) {
		const expected = expectedTheme(mode);
		assert.deepEqual(publicApi.klpThemes[mode], expected, `${mode} 全部語意值必須來自正式規格`);
		assert.deepEqual(publicApi.createKlpTheme(mode), expected);
	}
	assert.throws(() => publicApi.createKlpTheme('unknown'), /mode|theme|主題/i);
});

const script = join(repository, 'react/scripts/generate-tokens.mjs');
function generator(source, output, check = false) {
	return spawnSync(process.execPath, [script, '--source-dir', source, '--output-dir', output, ...(check ? ['--check'] : [])], { encoding: 'utf8', cwd: repository });
}

function fixture(t, transform = {}) {
	const directory = mkdtempSync(join(tmpdir(), 'kallopis-react-contract-'));
	t.after(() => rmSync(directory, { recursive: true, force: true }));
	for (const [name, text] of Object.entries(documents)) writeFileSync(join(directory, `${name}.md`), transform[name] ? transform[name](text) : text);
	return directory;
}

test('產生器 CLI 提供來源證據並以內容判斷新鮮度', t => {
	const source = fixture(t);
	const output = join(source, 'output');
	let result = generator(source, output);
	assert.equal(result.status, 0, result.stderr + result.stdout);
	for (const file of ['generated.ts', 'tokens.css', 'source-manifest.json']) assert.ok(existsSync(join(output, file)), `${file} 必須存在`);
	const manifest = JSON.stringify(JSON.parse(readFileSync(join(output, 'source-manifest.json'), 'utf8')));
	for (const [name, text] of Object.entries(documents)) {
		const hash = createHash('sha256').update(text).digest('hex');
		assert.ok(manifest.includes(hash), `${name} 原始來源 SHA256 必須可追溯`);
	}
	for (const id of [...Object.keys(expectedPrimitives), ...Object.keys(semanticExpressions), ...Object.keys(expectedRecipes)]) assert.ok(manifest.includes(JSON.stringify(id)), `${id} 必須列入來源清冊`);
	result = generator(source, output, true);
	assert.equal(result.status, 0, result.stderr + result.stdout);
	writeFileSync(join(source, 'primitives.md'), documents.primitives.replace('`#FFF8F6F1`', '`#FFF8F6F2`'));
	result = generator(source, output, true);
	assert.notEqual(result.status, 0, '數量相同但正式值改變時 --check 必須失敗');
});

const invalidSources = [
	['缺失 primitive 引用', { semantics: text => text.replace('p(parchment150)', 'p(missing-contract-primitive)') }],
	['缺失 semantic 引用', { semantics: text => text.replace('p(parchment150)', 's(theme.missing.contract)') }],
	['semantic 自循環', { semantics: text => text.replace('p(parchment150)', 's(theme.colors.app)') }],
	['未知 theme 表達式', { semantics: text => text.replace('p(parchment150)', 'unknown(p(parchment150))') }],
	['重複 primitive ID', { primitives: text => `${text}\n| \`parchment50\` | \`#FFF8F6F1\` | 重複 |\n` }],
	['重複 semantic ID', { semantics: text => `${text}\n${text.split(/\r?\n/).find(line => line.startsWith('| `theme.colors.app`'))}\n` }],
	['缺失配方繼承', { recipes: text => text.replace('| button-base | background=opaque', '| missing-contract-recipe | background=opaque') }],
	['配方繼承循環', { recipes: text => text.replace('| button-base | background=opaque', '| button-primary | background=opaque') }],
];

for (const [name, transform] of invalidSources) test(`產生器拒絕${name}`, t => {
	const source = fixture(t, transform);
	for (const [file, change] of Object.entries(transform)) assert.notEqual(change(documents[file]), documents[file], '失敗來源必須確實改變');
	const result = generator(source, join(source, 'output'));
	assert.notEqual(result.status, 0, `${name} 不得靜默略過`);
	assert.match(result.stderr + result.stdout, /missing|unknown|duplicate|cycle|circular|reference|缺失|循環|重複|不存在|未定義|無法/i);
});

// 四模式均採正式桌面控制尺寸；保留既有語意 ID 的相容性。
test('四主題維持方形圓角與已接受的桌面控制尺寸', () => {
	assert.equal(publicApi.klpPrimitives['length-15'], 15);
	const dimensions = {
		'theme.shape.control': 6,
		'theme.shape.pill': 6,
		'theme.components.badgeRadius': 6,
		'theme.components.fieldHeight': 24,
		'theme.geometry.control.fieldHeight': 24,
		'theme.geometry.control.selectionControl': 15,
		'theme.geometry.control.toggleWidth': 34,
		'theme.geometry.control.toggleHeight': 16,
		'theme.geometry.control.toggleThumb': 14,
		'theme.geometry.control.toggleInset': 1,
	};
	for (const mode of modes) {
		const theme = publicApi.createKlpTheme(mode);
		for (const [semantic, expected] of Object.entries(dimensions)) {
			assert.equal(theme[semantic], expected, `${mode} 的 ${semantic} 必須符合正式桌面尺寸`);
		}
	}
});
