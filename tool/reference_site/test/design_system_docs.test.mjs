import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { spawnSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

const root = path.resolve(import.meta.dirname, '..', '..', '..');
const documents = [
	['docs/design-tokens/KALLOPIS-DESIGN-MAP.md', 'docs/design-system/index.html'],
	['docs/design-tokens/maintenance.md', 'docs/design-system/maintenance.html'],
	...['notation', 'primitives', 'semantics', 'recipes', 'examples', 'platform-notes'].map((name) => [`docs/design-tokens/${name}.md`, `docs/design-system/${name}.html`]),
	['docs/design-tokens/README.md', 'docs/design-system/export-snapshot.html'],
	['spec/multi-framework-design-system.md', 'docs/guides/spec-multi-framework-design-system.html'],
];

function sandbox(t) {
	// 每個案例使用獨立產物，避免既有 API suite 同時產生網站造成競態。
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-docs-contract-'));
	assert.ok(path.resolve(directory).startsWith(path.join(path.resolve(os.tmpdir()), 'kallopis-docs-contract-')), '清理目標限於專用暫存目錄');
	t.after(() => fs.rmSync(directory, { recursive: true, force: true }));
	for (const entry of ['docs', 'spec', 'tool/reference_site', 'README.md', 'CHANGELOG.md']) {
		fs.cpSync(path.join(root, entry), path.join(directory, entry), { recursive: true });
	}
	fs.mkdirSync(path.join(directory, 'build'), { recursive: true });
	fs.copyFileSync(path.join(import.meta.dirname, 'fixtures/reference-api.json'), path.join(directory, 'build/reference-api.json'));
	const site = path.join(directory, 'build/reference-site');
	return {
		directory,
		site,
		run(script) {
			return spawnSync(process.execPath, [`tool/reference_site/${script}.mjs`], { cwd: directory, encoding: 'utf8' });
		},
		read(href) { return fs.readFileSync(path.join(site, href), 'utf8'); },
		json(href) { return JSON.parse(this.read(href)); },
	};
}

function succeeds(result) {
	assert.equal(result.status, 0, result.stderr || result.stdout);
}

function fails(result, message) {
	assert.notEqual(result.status, 0, `${message}\n${result.stdout}\n${result.stderr}`);
}

function generated(t) {
	const env = sandbox(t);
	succeeds(env.run('generate'));
	for (const [, href] of documents) {
		assert.ok(fs.existsSync(path.join(env.site, href)), `缺少正式登錄文件頁：${href}`);
	}
	return env;
}

function textOf(html) {
	return html.replace(/<[^>]*>/g, '').replace(/&#(?:x([0-9a-f]+)|(\d+));/gi, (_, hex, decimal) => String.fromCodePoint(parseInt(hex || decimal, hex ? 16 : 10)))
		.replaceAll('&lt;', '<').replaceAll('&gt;', '>').replaceAll('&quot;', '"').replaceAll('&#39;', "'").replaceAll('&apos;', "'").replaceAll('&amp;', '&').trim();
}

function tableRows(html) {
	return [...html.matchAll(/<tr\b[^>]*>([\s\S]*?)<\/tr>/g)].map(([, row]) => [...row.matchAll(/<t[dh]\b[^>]*>([\s\S]*?)<\/t[dh]>/g)].map(([, cell]) => textOf(cell)));
}

test('docs 入口、八份正式規範、快照與核心目標都有唯一來源頁', (t) => {
	const env = generated(t);
	const docsIndex = env.read('docs/index.html');
	assert.match(docsIndex, /href=["'][^"']*design-system\/index\.html["']/);
	assert.match(docsIndex, /Flutter/);
	assert.ok(fs.existsSync(path.join(env.site, 'docs/api/index.html')), '既有 Flutter API 路由保留');
	const manifest = env.json('site-manifest.json');
	assert.ok(Array.isArray(manifest.documents), 'site manifest 應包含文件來源與路由');
	for (const [source, href] of documents) {
		assert.equal(manifest.documents.filter((entry) => entry.source === source && entry.href === href).length, 1, `${source} 恰好對應一頁`);
	}
	assert.match(env.read('docs/design-system/export-snapshot.html'), /匯出快照/);
	succeeds(env.run('verify'));
});

test('真實 primitive 與 recipe 的每個資料 cell 保留完整值、運算及繼承', (t) => {
	const env = generated(t);
	for (const name of ['primitives', 'recipes']) {
		const source = fs.readFileSync(path.join(env.directory, `docs/design-tokens/${name}.md`), 'utf8');
		// 真實規範目前資料列以 token code 起始；逐 cell 核對，避免只比數量。
		const expected = source.split(/\r?\n/).filter((line) => /^\|\s*`/.test(line)).map((line) => line.slice(1, -1).split('|').map((cell) => cell.replaceAll('`', '').trim()));
		assert.ok(expected.length > 0, `${name} 必須含真實表格資料`);
		const actual = tableRows(env.read(`docs/design-system/${name}.html`));
		for (const row of expected) {
			assert.ok(actual.some((candidate) => JSON.stringify(candidate) === JSON.stringify(row)), `${name} 遺失或誤切完整表格列：${JSON.stringify(row)}`);
		}
	}
});

test('正式索引相對連結在專案前綴下可到章節與快照', (t) => {
	const env = generated(t);
	const html = env.read('docs/design-system/index.html');
	const links = [...html.matchAll(/href=["']([^"']+)["']/g)].map(([, href]) => href);
	for (const [, href] of documents.filter(([source]) => source.startsWith('docs/design-tokens/'))) {
		if (href.endsWith('/index.html')) continue;
		assert.ok(links.some((link) => new URL(link, 'https://example.test/Kallopis/docs/design-system/index.html').pathname === `/Kallopis/${href}`), `規範索引缺少專案前綴可用連結：${href}`);
	}
});

test('文件搜尋 body 可定位 token 與 recipe，每頁只有一筆', (t) => {
	const env = generated(t);
	const search = env.json('search-index.json');
	for (const [, href] of documents) {
		const entries = search.filter((entry) => entry.href === href);
		assert.equal(entries.length, 1, `${href} 恰好一筆搜尋記錄`);
		assert.ok(typeof entries[0].body === 'string' && entries[0].body.trim(), `${href} 需要正文搜尋內容`);
	}
	for (const [query, href] of [['parchment50', 'docs/design-system/primitives.html'], ['button-size-md', 'docs/design-system/recipes.html']]) {
		assert.ok(search.some((entry) => entry.href === href && entry.body?.includes(query)), `${query} 需要定位到對應規範正文`);
	}
	const snapshot = search.find((entry) => entry.href === 'docs/design-system/export-snapshot.html');
	const formal = search.find((entry) => entry.href === 'docs/design-system/primitives.html');
	assert.notEqual(snapshot.category, formal.category, '快照不得與正式規範競爭同一搜尋分類');
});

test('generator 缺必要來源時失敗且保留既有輸出', (t) => {
	const env = sandbox(t);
	fs.mkdirSync(env.site, { recursive: true });
	const sentinel = path.join(env.site, 'existing-output.txt');
	fs.writeFileSync(sentinel, '先前可用產物');
	fs.rmSync(path.join(env.directory, 'docs/design-tokens/primitives.md'));
	fails(env.run('generate'), '必要正式來源缺失不能冒充完整網站');
	assert.equal(fs.readFileSync(sentinel, 'utf8'), '先前可用產物', '缺來源必須在清理輸出之前失敗');
});

for (const mutation of ['missing-source', 'missing-page', 'extra-page', 'bad-anchor', 'missing-body']) {
	test(`verifier 拒絕規範完整性破壞：${mutation}`, (t) => {
		const env = generated(t);
		succeeds(env.run('verify'));
		const target = path.join(env.site, 'docs/design-system/primitives.html');
		if (mutation === 'missing-source') fs.rmSync(path.join(env.directory, 'docs/design-tokens/primitives.md'));
		if (mutation === 'missing-page') fs.rmSync(target);
		if (mutation === 'extra-page') fs.copyFileSync(target, path.join(env.site, 'docs/design-system/unregistered.html'));
		if (mutation === 'bad-anchor') fs.appendFileSync(target, '<a href="notation.html#nonexistent-contract-anchor">壞連結</a>');
		if (mutation === 'missing-body') {
			const search = env.json('search-index.json');
			const entry = search.find((item) => item.href === 'docs/design-system/primitives.html');
			assert.ok(entry, '先確認正文搜尋記錄存在再破壞');
			delete entry.body;
			fs.writeFileSync(path.join(env.site, 'search-index.json'), JSON.stringify(search));
		}
		fails(env.run('verify'), `verifier 必須拒絕 ${mutation}`);
	});
}

test('公開 Markdown renderer 保留 escaped pipe／code、中文 anchors 並轉換來源相對連結', async () => {
	const parser = path.join(root, 'tool/reference_site/markdown.mjs');
	assert.ok(fs.existsSync(parser), '公開 renderer 尚未提供；此為 setup blocker，CLI 整合案例另提供 behavioral Red');
	const { renderMarkdown } = await import(pathToFileURL(parser).href);
	const markdown = fs.readFileSync(path.join(import.meta.dirname, 'fixtures/design-system/markdown.md'), 'utf8');
	const rendered = renderMarkdown(markdown, {
		source: 'docs/design-tokens/notation.md',
		href: 'docs/design-system/notation.html',
		routes: new Map(documents),
	});
	assert.deepEqual(tableRows(rendered.html), [
		['記號', '說明', '公式'],
		['a|b', '左|右', 'div(sub(height,mul(font-size,ratio)),2)'],
		['#FFF8F6F1', '繼承父層；none', 'p(space0)'],
	]);
	assert.match(rendered.html, /<code>a\|b<\/code>/);
	assert.match(rendered.body, /左\|右/);
	assert.match(rendered.body, /div\(sub\(height,mul\(font-size,ratio\)\),2\)/);
	const anchors = [...rendered.anchors];
	assert.equal(anchors.length, 2);
	assert.equal(new Set(anchors).size, 2, '同名標題應產生不同 anchors');
	assert.ok(anchors.includes('中文標題'), 'anchor 應支援中文');
	const links = [...rendered.html.matchAll(/href=["']([^"']+)["']/g)].map(([, href]) => href);
	const base = 'https://example.test/Kallopis/docs/design-system/notation.html';
	assert.ok(links.some((link) => new URL(link, base).href === 'https://example.test/Kallopis/docs/design-system/primitives.html#%E9%A1%8F%E8%89%B2'));
	assert.ok(links.some((link) => new URL(link, base).pathname === '/Kallopis/docs/guides/spec-multi-framework-design-system.html'));
	assert.ok(links.some((link) => link.includes('not-registered.md')), '未登錄 Markdown 保留明確原文目標');
	assert.ok(!links.some((link) => link.includes('not-registered.html')), '不得發明未登錄的 HTML 路由');
	assert.doesNotMatch(rendered.html, /<script\b|href=["']javascript:/i);
	assert.match(textOf(rendered.html), /<script>alert\('不可執行'\)<\/script>/);
});
