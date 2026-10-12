import assert from 'node:assert/strict';
import test from 'node:test';
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, isAbsolute, join, relative, resolve, sep } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { spawnSync } from 'node:child_process';

const packageRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const script = join(packageRoot, 'scripts', 'reference-components.mjs');
const { extractReactComponents } = await import(pathToFileURL(script).href);

function fixture(context, files) {
	const root = mkdtempSync(join(tmpdir(), 'kallopis-reference-'));
	context.after(() => rmSync(root, { recursive: true, force: true }));
	// 暫存 package 只借用既有依賴，宣告與產物均由此測試擁有。
	symlinkSync(join(packageRoot, 'node_modules'), join(root, 'node_modules'), 'junction');
	writeFileSync(join(root, 'package.json'), '{"type":"module"}');
	for (const [name, contents] of Object.entries(files)) {
		const path = join(root, name);
		mkdirSync(dirname(path), { recursive: true });
		writeFileSync(path, contents);
	}
	return root;
}

function validateInventory(inventory, root) {
	assert.equal(inventory.schemaVersion, 1);
	assert.equal(inventory.framework, 'react');
	assert.equal(inventory.entrypoint, '@kallopis/react');
	const names = inventory.components.map(component => component.name);
	assert.deepEqual(names, [...names].sort(), '公開名稱必須按 UTF-16 排序');
	assert.equal(new Set(names).size, names.length, '每個公開 export 只能一筆');
	for (const component of inventory.components) {
		assert.equal(component.id, `@kallopis/react#${component.name}`);
		assert.equal(typeof component.signature, 'string');
		assert.equal(typeof component.propsType, 'string');
		assert.ok(component.signature.length > 0);
		assert.equal(isAbsolute(component.source), false, 'source 必須 package-relative');
		assert.equal(component.source.includes('\\'), false, 'source 必須 POSIX');
		const local = relative(root, resolve(root, component.source));
		assert.ok(local !== '..' && !local.startsWith(`..${sep}`) && !isAbsolute(local), 'source 不得越出 package root');
	}
}

test('公開 alias、泛型、nullable、React 型別別名與 callable const 保留原宣告', async context => {
	const declarations = {
		'dist/index.d.ts': `export { Zed, Zed as Alias, Generic, NoProps, nullable, callableAlias, Ångstrom, apple } from './views.js';
export type { TypeOnly } from './views.js';
export { type InlineTypeOnly } from './views.js';
export type * from './type-only.js';
export * from './data.js';`,
		'dist/views.d.ts': `import type { JSX, ReactElement, ReactNode } from 'react';
import type * as React from 'react';
export interface Props { readonly title: string; }
type View = ReactNode;
type Callable = (props: Props) => ReactElement | null;
export declare function Zed(props: Props): JSX.Element;
export declare function Generic<T>(props: { readonly value: T }): ReactElement<{ readonly value: T }> | null;
export declare function NoProps(): import('react').JSX.Element;
export declare const nullable: (props: Props) => View | null;
export declare const callableAlias: Callable;
export declare function Ångstrom(props: Props): React.ReactElement;
export declare function apple(props: Props): React.ReactNode;
export declare function TypeOnly(props: Props): ReactNode;
export declare function InlineTypeOnly(props: Props): ReactNode;
declare function PrivateView(props: Props): ReactNode;`,
		'dist/type-only.d.ts': "export declare function StarTypeOnly(): import('react').ReactNode;",
		'dist/data.d.ts': `import type { ReactNode } from './fake.js';
export interface Model { title: string; }
export type Text = string;
export declare class Data { title: string; }
export declare const constant: string;
export declare function ordinary(): number;
export declare function fakeNode(): ReactNode;
export declare function fakeElement(): import('./fake.js').JSX.Element;
export declare function later(): Promise<import('react').ReactNode>;`,
		'dist/fake.d.ts': `export type ReactNode = string;
export namespace JSX { interface Element { readonly fake: true; } }`,
	};
	const root = fixture(context, declarations);
	const result = await extractReactComponents(join(root, 'dist/index.d.ts'), root);
	validateInventory(result, root);
	assert.deepEqual(result.components.map(component => component.name), [
		'Alias', 'Generic', 'NoProps', 'Zed', 'apple', 'callableAlias', 'nullable', 'Ångstrom',
	]);
	for (const component of result.components) {
		assert.equal(component.source, 'dist/views.d.ts');
		assert.ok(declarations[component.source].includes(component.signature), `${component.name} 必須保留原 callable 宣告文字`);
	}
	const byName = new Map(result.components.map(component => [component.name, component]));
	assert.equal(byName.get('Alias').signature, byName.get('Zed').signature);
	assert.equal(byName.get('Zed').propsType, 'Props');
	assert.equal(byName.get('Generic').propsType, '{ readonly value: T }');
	assert.equal(byName.get('NoProps').propsType, '');
	assert.equal(byName.get('nullable').propsType, 'Props');
	assert.equal(byName.get('callableAlias').propsType, 'Props');
	assert.match(byName.get('Generic').signature, /<T>/);
});

test('無元件的有效公開入口仍產生空清單', async context => {
	const root = fixture(context, { 'dist/index.d.ts': 'export declare function calculate(value: number): number;' });
	const result = await extractReactComponents(join(root, 'dist/index.d.ts'), root);
	validateInventory(result, root);
	assert.deepEqual(result.components, []);
});

test('無效路徑、缺失入口與編譯錯誤必須拒絕', async context => {
	const root = fixture(context, {
		'dist/index.d.ts': "export declare function Broken(props: MissingProps): import('react').ReactNode;",
	});
	const entrypoint = join(root, 'dist/index.d.ts');
	for (const [entry, scope] of [
		['dist/index.d.ts', root],
		[entrypoint, '.'],
		[join(root, 'dist/missing.d.ts'), root],
		[join(root, 'dist'), root],
		[entrypoint, root],
	]) {
		await assert.rejects(async () => extractReactComponents(entry, scope), '無效輸入不得產生清單');
	}
});

test('公開 re-export 指向 package root 外的元件必須拒絕', async context => {
	const root = fixture(context, {
		'outside.d.ts': "export declare function Escaped(): import('react').ReactNode;",
		'package/dist/index.d.ts': "export { Escaped } from '../../outside.js';",
	});
	await assert.rejects(async () => extractReactComponents(
		join(root, 'package/dist/index.d.ts'), join(root, 'package')
	), '來源越界必須拒絕，不能輸出 ../ source');
});

test('真實 dist 清單保留公開核心、布局與 host 宣告，排除公開資料與一般函式', async () => {
	const result = await extractReactComponents(join(packageRoot, 'dist/index.d.ts'), packageRoot);
	validateInventory(result, packageRoot);
	const byName = new Map(result.components.map(component => [component.name, component]));
	const witnesses = [
		['KlpText', 'dist/components.d.ts', 'KlpTextProps'],
		['KlpFileExplorer', 'dist/components.d.ts', 'KlpFileExplorerProps'],
		['KlpLayoutRow', 'dist/workbench-layout.d.ts', 'KlpLayoutLinearProps'],
		['KlpAppLayout', 'dist/workbench-layout.d.ts', 'KlpAppLayoutProps'],
		['KlpCommandShortcutHost', 'dist/command-shortcut-host.d.ts', 'KlpCommandShortcutHostProps<C>'],
	];
	for (const [name, source, propsType] of witnesses) {
		const component = byName.get(name);
		assert.ok(component, `${name} 公開元件不得遺漏`);
		assert.equal(component.source, source);
		assert.equal(component.propsType, propsType);
		assert.ok(readFileSync(join(packageRoot, source), 'utf8').includes(component.signature), `${name} 必須來自原宣告`);
	}
	for (const name of ['resolveKlpLinearLayout', 'createKlpStylePack', 'KlpCommandKeymap', 'KlpTextProps', 'klpPrimitives']) {
		assert.equal(byName.has(name), false, `${name} 不是公開呈現元件`);
	}
	// 全量每筆都回到自己的公開宣告，沒有固定元件數量快照。
	for (const component of result.components) {
		assert.ok(readFileSync(join(packageRoot, component.source), 'utf8').includes(component.signature), component.name);
	}
	assert.deepEqual(await extractReactComponents(join(packageRoot, 'dist/index.d.ts'), packageRoot), result, '重複擷取必須穩定');
});

test('CLI --output 成功寫 JSON，編譯失敗保留既有產物', context => {
	const root = fixture(context, {
		'dist/index.d.ts': "export declare function Visible(): import('react').ReactNode;",
	});
	mkdirSync(join(root, 'scripts'));
	// 以公開 CLI 作黑箱，不讀取或依賴內部實作。
	copyFileSync(script, join(root, 'scripts/reference-components.mjs'));
	const output = join(root, 'reference-components.json');
	const args = [join(root, 'scripts/reference-components.mjs'), '--output', output];
	const success = spawnSync(process.execPath, args, { cwd: root, encoding: 'utf8' });
	assert.equal(success.status, 0, success.stderr || success.stdout);
	const inventory = JSON.parse(readFileSync(output, 'utf8'));
	validateInventory(inventory, root);
	assert.deepEqual(inventory.components.map(component => component.name), ['Visible']);
	const before = readFileSync(output);
	writeFileSync(join(root, 'dist/index.d.ts'), 'export declare function Broken(props: UnknownProps): number;');
	const failure = spawnSync(process.execPath, args, { cwd: root, encoding: 'utf8' });
	assert.notEqual(failure.status, 0, '編譯錯誤必須令 CLI 失敗');
	assert.ok((failure.stderr + failure.stdout).trim().length > 0, 'CLI 失敗必須提供診斷');
	assert.deepEqual(readFileSync(output), before, '失敗不得覆蓋既有 JSON');
});
