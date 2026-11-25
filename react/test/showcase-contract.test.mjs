import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { dirname, extname, join, relative, resolve } from 'node:path';
import test from 'node:test';
import { JSDOM } from 'jsdom';
import { parseSync } from 'rolldown/utils';
import { componentsPage, homePage, showcasePage } from '../../tool/reference_site/layout.mjs';

const root = resolve(import.meta.dirname, '../..');
const example = join(root, 'react/example');
const site = new URL('https://example.test/Kallopis/');
const publishedBundles = new Set(['/Kallopis/examples/react/index.html', '/Kallopis/examples/flutter/index.html']);
const publicPackage = '@kallopis/react';
const provider = 'KlpThemeProvider';

function* nodes(node) {
	if (!node?.type)
		return;

	yield node;
	for (const value of Object.values(node)) {
		if (Array.isArray(value)) {
			for (const child of value)
				yield* nodes(child);
		} else {
			yield* nodes(value);
		}
	}
}

function inspectModule(file, source) {
	// 解析實際語法，避免將註解、可複製程式片段或字串中的標記當成畫面。
	const parsed = parseSync(file, source);
	assert.equal(parsed.errors.length, 0, `${file} 無法解析：${JSON.stringify(parsed.errors)}`);
	const syntax = [...nodes(parsed.program)];
	const imports = syntax.filter(node => node.type === 'ImportDeclaration' && node.importKind !== 'type');
	const dependencies = new Set();
	const bindings = new Map();
	const namespaces = new Set();
	const components = new Set();
	const composition = [];
	const styles = [];
	const styleBridges = new Set();
	let injectsPack = false;
	let rendersElements = false;

	function location(node) {
		return `${file}:${source.slice(0, node.start).split('\n').length}`;
	}

	for (const node of syntax) {
		if (['ImportDeclaration', 'ExportNamedDeclaration', 'ExportAllDeclaration', 'ImportExpression'].includes(node.type) && typeof node.source?.value === 'string')
			dependencies.add(node.source.value);
	}

	for (const node of imports) {
		const from = node.source.value;
		if (/^@kallopis\/react\/(?!styles\.css$)/.test(from) || /(?:^|\/)(?:src|dist)\//.test(from) && from.startsWith('.'))
			composition.push(`${location(node)} 請使用 ${publicPackage} 公開入口：${from}`);

		for (const item of node.specifiers) {
			if (from === publicPackage && item.type === 'ImportNamespaceSpecifier')
				namespaces.add(item.local.name);

			if (from === publicPackage && item.importKind !== 'type' && /^Klp[A-Z]/.test(item.imported?.name ?? ''))
				bindings.set(item.local.name, item.imported.name);

			if (from === './live-style-bridge.js' && item.imported?.name === 'useLiveStyleBridge')
				styleBridges.add(item.local.name);
		}
	}

	// 只有來自展示風格橋接的覆寫值可以經公開 provider 注入。
	const injectedStyles = new Set();
	for (const node of syntax) {
		if (node.type !== 'VariableDeclarator' || node.id.type !== 'ObjectPattern' || !styleBridges.has(node.init?.callee?.name))
			continue;

		for (const item of node.id.properties) {
			if (item.key?.name === 'customVars')
				injectedStyles.add(item.value.name);
		}
	}

	for (const node of syntax) {
		if (node.type !== 'JSXOpeningElement')
			continue;

		rendersElements = true;
		const name = node.name.name ?? node.name.property?.name;
		const libraryName = namespaces.has(node.name.object?.name) ? name : bindings.get(name);
		const isProvider = libraryName === provider;
		if (/^Klp[A-Z]/.test(libraryName ?? '') && !isProvider)
			components.add(libraryName);

		if (['button', 'select'].includes(name) && node.name.type === 'JSXIdentifier')
			composition.push(`${location(node)} <${name}> 請改用對應的 Kallopis 公開控制元件`);

		if (name === 'style' && node.name.type === 'JSXIdentifier')
			styles.push(`${location(node)} 請從外部注入樣式，移除 <style>`);

		for (const attribute of node.attributes) {
			const expression = attribute.value?.expression;
			if (attribute.name?.name === 'style' && !(isProvider && expression?.type === 'Identifier' && injectedStyles.has(expression.name)))
				styles.push(`${location(attribute)} <${name}> 的 style 請移到注入的樣式來源`);

			if (!isProvider || attribute.name?.name !== 'stylePack')
				continue;

			if (!expression || ['ObjectExpression', 'Literal'].includes(expression.type)) {
				styles.push(`${location(attribute)} stylePack 請從外部風格資料注入`);
			} else {
				injectsPack = true;
			}
		}
	}

	if (rendersElements && !components.size)
		composition.push(`${file} 未渲染從 ${publicPackage} 匯入的公開元件`);

	// dependencies 記錄入口依賴；composition 與 styles 保存違規位置；injectsPack 記錄是否經公開 provider 傳入風格。
	return { dependencies, composition, styles, injectsPack };
}

function inspectReactGraph() {
	const queue = [join(example, 'main.tsx')];
	const modules = new Map();
	for (const file of queue) {
		if (modules.has(file))
			continue;

		// 以 Vite 的正式入口為起點，只追蹤實際引用的本地展示模組。
		const result = inspectModule(relative(root, file).replaceAll('\\', '/'), readFileSync(file, 'utf8'));
		modules.set(file, result);
		for (const dependency of result.dependencies) {
			if (!dependency.startsWith('.') || !/\.(?:[cm]?[jt]sx?)$/.test(dependency))
				continue;

			const target = resolve(dirname(file), dependency);
			const base = target.slice(0, -extname(target).length);
			const source = [target, `${base}.ts`, `${base}.tsx`].find(candidate => existsSync(candidate));
			assert.ok(source, `${relative(root, file)} 找不到展示模組 ${dependency}`);
			queue.push(source);
		}
	}

	return [...modules.values()];
}

function inlineMarkup(document, file) {
	// 解析實際 HTML 元素；範例文字中跳脫過的標記不觸發檢查。
	const violations = [...document.querySelectorAll('style, [style]')].map(element => {
		const label = [element.localName, element.id, element.classList[0]].filter(Boolean).join(' ');
		return `${file} 的 <${label}> 含內嵌樣式`;
	});
	return new Set(violations);
}

test('展示驗證接受公開匯入別名與注入，拒絕原生替代及寫死的樣式', () => {
	const good = inspectModule('valid.tsx', `import { KlpThemeProvider as Theme, KlpButton as Action } from '@kallopis/react';
		import { useLiveStyleBridge } from './live-style-bridge.js';
		const { customVars: injected } = useLiveStyleBridge();
		const preview = <Theme stylePack={pack} style={injected}><Action>開啟</Action></Theme>;`);
	assert.deepEqual(good.composition, []);
	assert.deepEqual(good.styles, []);
	assert.ok(good.injectsPack);

	const bad = inspectModule('invalid.tsx', `import { KlpThemeProvider, KlpButton } from '@kallopis/react';
		const preview = <KlpThemeProvider stylePack={{ colors: {} }}><button style={{ color: 'red' }}>開啟</button></KlpThemeProvider>;`);
	assert.equal(bad.composition.length, 2);
	assert.equal(bad.styles.length, 2);
});

test('React 展示實際組合公開元件及控制項', () => {
	const violations = inspectReactGraph().flatMap(module => module.composition);
	assert.ok(!violations.length, violations.join('\n'));
});

test('React 展示經公開 provider 注入風格且無 JSX 內嵌樣式', () => {
	const modules = inspectReactGraph();
	assert.ok(modules.some(module => module.dependencies.has(`${publicPackage}/styles.css`)), '展示應載入公開套件樣式表');
	assert.ok(modules.some(module => module.injectsPack), '展示應透過公開 KlpThemeProvider 傳入 stylePack');
	const violations = modules.flatMap(module => module.styles);
	assert.ok(!violations.length, violations.join('\n'));
});

test('公開展示入口使用正式 bundle 和外部樣式來源', () => {
	// 以實際產頁函式驗證公開入口及其指向的獨立展示。
	const { themes } = JSON.parse(readFileSync(join(root, 'styles/themes/index.json'), 'utf8'));
	// interactive 啟用正式展示入口，themes 使用發布時的風格索引。
	const options = { interactive: true, themes };
	const pages = new Map([
		['index.html', homePage(options)],
		['showcase.html', showcasePage(options)],
		['components.html', componentsPage(options)],
	]);
	const violations = [];
	const standalone = new Set();
	for (const [file, html] of pages) {
		const { document } = new JSDOM(html).window;
		assert.ok(document.querySelector('link[rel="stylesheet"][href]'), `${file} 應載入外部樣式表`);
		const previews = [...document.querySelectorAll('iframe[src]')];
		assert.ok(previews.length, `${file} 未載入框架展示`);
		for (const frame of previews) {
			const target = new URL(frame.getAttribute('src'), site);
			assert.ok(target.origin === site.origin && publishedBundles.has(target.pathname), `${file} 的展示應載入正式框架 bundle：${target.href}`);
		}
		violations.push(...inlineMarkup(document, file));
		for (const link of document.querySelectorAll('a[href^="styles/examples/"]'))
			standalone.add(link.getAttribute('href'));
	}

	for (const file of standalone) {
		const { document } = new JSDOM(readFileSync(join(root, file), 'utf8')).window;
		const frames = [...document.querySelectorAll('iframe[src]')];
		const usesBundle = frames.some(frame => {
			const target = new URL(frame.getAttribute('src'), new URL(file, site));
			return target.origin === site.origin && publishedBundles.has(target.pathname);
		});
		if (!usesBundle)
			violations.push(`${file} 獨立展示未接入正式元件 bundle`);

		violations.push(...inlineMarkup(document, file));
	}

	assert.ok(!violations.length, violations.join('\n'));
});
