import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { buildReferenceDocuments, updateReferenceDocuments } from '../reference-docs.mjs';
import { localDocumentTarget } from '../markdown.mjs';

const root = path.resolve(import.meta.dirname, '..', '..', '..');

function flutterDeclaration(name, overrides = {}) {
	return {
		id: `package:kallopis/src/example.dart#${name}`,
		name,
		slug: name.toLowerCase(),
		kind: 'class',
		renderable: false,
		module: 'example',
		sourceUri: 'package:kallopis/src/example.dart',
		primarySurface: 'foundation',
		surfaces: ['foundation'],
		signature: `class ${name}`,
		documentation: `${name} 公開說明`,
		typeRelationships: { extends: null, mixins: [], implements: [] },
		members: [],
		...overrides,
	};
}

function build(flutter = [], reactDeclarations = []) {
	return buildReferenceDocuments({
		root,
		flutterManifest: {
			schemaVersion: 1,
			surfaces: [{ name: 'foundation', entrypoint: 'package:kallopis/kallopis_foundation.dart', stability: 'stable' }],
			modules: [{ name: 'example', declarations: flutter }],
		},
		reactDeclarations,
	});
}

function documentFor(result, id) {
	const entries = result.entries.filter((entry) => entry.id === id);
	assert.equal(entries.length, 1, `${id} 必須只有一個索引項目`);
	const documents = result.documents.filter((document) => document.source === entries[0].source);
	assert.equal(documents.length, 1, `${id} 必須對應唯一 Markdown`);
	assert.match(entries[0].source, new RegExp(`^docs/reference/${entries[0].framework}/.+\\.md$`));
	assert.ok(entries[0].href, '索引必須提供網站路由');
	return documents[0].content;
}

function normalized(content) {
	// Markdown 表格可跳脫 union，HTML entity 亦保留同一語意。
	return content.replaceAll('\\|', '|').replaceAll('&vert;', '|').replaceAll('&#124;', '|')
		.replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'");
}

test('Flutter 每個宣告一頁，保留自有參數、方法與列舉值', () => {
	const widget = flutterDeclaration('KlpProbe', {
		renderable: true,
		signature: 'class KlpProbe extends StatelessWidget',
		typeRelationships: { extends: 'StatelessWidget', mixins: [], implements: [] },
		members: [
			{
				name: 'KlpProbe', kind: 'constructor', documentation: '建立探針。',
				signature: 'KlpProbe({required VoidCallback? onPressed, bool selected = false})',
				parameters: [
					{ name: 'onPressed', type: 'VoidCallback?', required: true, defaultValue: null },
					{ name: 'selected', type: 'bool', required: false, defaultValue: 'false' },
				],
			},
			{ name: 'clear', kind: 'method', signature: 'void clear({bool notify = true})', documentation: '清除探針。', parameters: [{ name: 'notify', type: 'bool', required: false, defaultValue: 'true' }] },
		],
	});
	const tone = flutterDeclaration('KlpProbeTone', {
		kind: 'enum', signature: 'enum KlpProbeTone',
		members: ['quiet', 'strong'].map((name) => ({ name, kind: 'enumValue', signature: name, documentation: `${name} 語意` })),
	});
	const result = build([widget, tone]);
	assert.equal(result.entries.length, 2);
	assert.equal(result.documents.length, 2);
	const content = normalized(documentFor(result, widget.id));
	for (const member of widget.members) {
		assert.ok(content.includes(member.signature), `不可遺漏自有成員簽章：${member.name}`);
		assert.ok(content.includes(member.documentation), `不可遺漏成員說明：${member.name}`);
	}
	assert.match(content, /required VoidCallback\? onPressed/);
	assert.match(content, /bool selected = false/);
	assert.match(content, /https:\/\/api\.flutter\.dev\/[^\s)"<>]*StatelessWidget-class\.html/);
	const enumContent = documentFor(result, tone.id);
	for (const member of tone.members) assert.ok(enumContent.includes(member.documentation), `列舉值 ${member.name} 必須完整列出`);
});

test('React type、function、controller 全部產生文件且保留 union', () => {
	const declarations = [
		{ id: 'react/src/types.ts#KlpMode', name: 'KlpMode', kind: 'type', source: 'react/src/types.ts', signature: "type KlpMode = 'quiet' | 'strong'", members: [] },
		{ id: 'react/src/actions.ts#makeKlpMode', name: 'makeKlpMode', kind: 'function', source: 'react/src/actions.ts', signature: 'function makeKlpMode(value: string | null): KlpMode', members: [], parameters: [{ name: 'value', type: 'string | null', required: true, defaultValue: null }] },
		{ id: 'react/src/controller.ts#KlpProbeController', name: 'KlpProbeController', kind: 'class', source: 'react/src/controller.ts', signature: 'class KlpProbeController', members: [{ name: 'reset', kind: 'method', signature: 'reset(mode: KlpMode | null): void', documentation: '重設模式。' }] },
	].map((declaration) => ({ documentation: `${declaration.name} 公開說明`, parameters: [], renderable: false, ...declaration }));
	const result = build([], declarations);
	assert.equal(result.entries.length, declarations.length);
	assert.equal(result.documents.length, declarations.length);
	for (const declaration of declarations) {
		const content = normalized(documentFor(result, declaration.id));
		assert.ok(content.includes(declaration.signature), `${declaration.kind} 的完整簽章不可遺漏`);
		assert.ok(content.includes(declaration.documentation));
		for (const member of declaration.members) {
			assert.ok(content.includes(member.signature));
			assert.ok(content.includes(member.documentation));
		}
	}
});

test('同名不同來源各有文件及速成例，範例只使用公開 import', () => {
	const first = flutterDeclaration('KlpShared', { members: [{ name: 'KlpShared', kind: 'constructor', signature: 'KlpShared()', documentation: '', parameters: [] }] });
	const second = { ...first, id: 'package:kallopis/src/another.dart#KlpShared', sourceUri: 'package:kallopis/src/another.dart' };
	const result = build([first, second]);
	assert.equal(result.documents.length, 2);
	assert.equal(new Set(result.entries.map((entry) => entry.source)).size, 2, '同名來源不得覆蓋 Markdown');
	assert.equal(new Set(result.entries.map((entry) => entry.href)).size, 2, '同名來源不得覆蓋網站路由');
	for (const declaration of [first, second]) {
		const content = documentFor(result, declaration.id);
		const samples = [...content.matchAll(/```[^\n]*\n([\s\S]*?)```/g)].map((match) => match[1]);
		const importedSamples = samples.filter((sample) => /\bimport\s/.test(sample));
		assert.ok(importedSamples.some((sample) => sample.includes(declaration.name)), '速成例須包含公開 import 與宣告的使用');
		for (const sample of importedSamples) {
			assert.doesNotMatch(sample, /(?:package:kallopis\/src\/|from\s*['"]\.|import\s*['"]\.)/, '範例不得使用私有或相對 import');
			assert.match(sample, /package:kallopis\/kallopis_foundation\.dart/);
		}
	}
});

test('重複宣告 id 必須拒絕，不能靜默覆蓋', () => {
	const declaration = flutterDeclaration('KlpDuplicate');
	assert.throws(() => build([declaration, { ...declaration }]), '重複 Flutter id 必須失敗');
	const react = { id: 'react/src/types.ts#KlpDuplicate', name: 'KlpDuplicate', kind: 'type', source: 'react/src/types.ts', signature: 'type KlpDuplicate = string', documentation: '', members: [], parameters: [], renderable: false };
	assert.throws(() => build([], [react, { ...react }]), '重複 React id 必須失敗');
});

function updateFixture(t) {
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-reference-preservation-'));
	// 清理僅限本案例自行建立的獨立暫存目錄。
	assert.ok(path.resolve(directory).startsWith(path.join(path.resolve(os.tmpdir()), 'kallopis-reference-preservation-')));
	t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
	const source = 'docs/reference/flutter/klp-probe.md';
	const file = path.join(directory, source);
	const api = '<!-- reference-api:start -->\n## API\nvoid refresh()\n<!-- reference-api:end -->';
	const content = `# 預設職責\n\n${api}\n\n## 預設例子\n`;
	const result = {
		documents: [{ source, content }],
		entries: [{ id: 'probe', framework: 'flutter', name: 'KlpProbe', source, href: 'docs/reference/flutter/klp-probe.html' }],
	};
	return {
		directory, file, api, result,
		write(value) {
			fs.mkdirSync(path.dirname(file), { recursive: true });
			fs.writeFileSync(file, value, 'utf8');
		},
	};
}

test('更新 API 僅取代 marker 內文字，逐字保留人工職責、例子與限制', (t) => {
	const env = updateFixture(t);
	const before = '# 手改職責：產品投影\n\n保留 `特殊符號 | < >` 與段落。\n\n';
	const after = '\n\n## 手改速成例\n```dart\nfinal label = "人工例子";\n```\n\n## 限制\n不可自行取得資料。\n';
	env.write(`${before}<!-- reference-api:start -->\n過期 API\n<!-- reference-api:end -->${after}`);
	updateReferenceDocuments(env.directory, env.result);
	assert.equal(fs.readFileSync(env.file, 'utf8'), `${before}${env.api}${after}`, '不得改動 API marker 外的人工內容');
});

test('check 遇到缺頁或過期 API 必須失敗且不能寫入', (t) => {
	const env = updateFixture(t);
	assert.throws(() => updateReferenceDocuments(env.directory, env.result, true), '缺頁必須報錯');
	assert.equal(fs.existsSync(env.file), false, 'check 不得建立缺少的文件');
	const outdated = '# 人工職責\n<!-- reference-api:start -->\n過期 API\n<!-- reference-api:end -->\n人工限制\n';
	env.write(outdated);
	assert.throws(() => updateReferenceDocuments(env.directory, env.result, true), 'API 過期必須報錯');
	assert.equal(fs.readFileSync(env.file, 'utf8'), outdated, 'check 不得更新過期文件');
});

test('既有頁面缺少 API marker 時拒絕寫入並保留人工文件', (t) => {
	const env = updateFixture(t);
	const manual = '# 人工維護頁面\n\n## 職責\n保留全部內容。\n';
	env.write(manual);
	assert.throws(() => updateReferenceDocuments(env.directory, env.result), '無 marker 文件不得遭覆蓋');
	assert.equal(fs.readFileSync(env.file, 'utf8'), manual);
});

test('本地連結移除 query 後仍保留缺檔與越界檢查所需的目標', () => {
	const href = 'docs/reference/react/components/actions/klp-button.html';
	assert.deepEqual(
		localDocumentTarget(href, '../../../../../examples/react/index.html?specimen=KlpButton'),
		{ target: 'examples/react/index.html', fragment: '' },
		'帶 specimen query 的範例連結應檢查真正 HTML 路徑',
	);
	assert.deepEqual(
		localDocumentTarget(href, '?x=1#段落'),
		{ target: href, fragment: '段落' },
		'只有 query 與 fragment 的連結仍指向同頁',
	);
	assert.deepEqual(
		localDocumentTarget(href, 'missing.html?x=1'),
		{ target: 'docs/reference/react/components/actions/missing.html', fragment: '' },
		'移除 query 不能略過缺檔連結',
	);
	assert.deepEqual(
		localDocumentTarget('docs/index.html', '../../../escape'),
		{ target: '../../escape', fragment: '' },
		'逃出網站 root 的相對路徑須保留，供 verifier 拒絕',
	);
});
