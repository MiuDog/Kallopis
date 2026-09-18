import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { test } from 'node:test';
import { createMarkdownRenderer } from './markdown.mjs';

function fixture() {
	// 以獨立暫存儲存庫驗證連結，不受正式文件內容影響。
	const root = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-markdown-'));
	fs.mkdirSync(path.join(root, 'docs'));
	fs.writeFileSync(path.join(root, 'docs', 'sample.md'), '# 中文標題');
	fs.writeFileSync(path.join(root, 'docs', 'next.md'), '# Next');
	const sourceLinks = [];
	const output = path.join(root, 'output');
	const render = createMarkdownRenderer({ root, output, routeMap: { 'docs/sample.md': 'docs/guides/sample.html', 'docs/next.md': 'docs/guides/next.html' }, sourceLinks });
	return { root, output, sourceLinks, render: (text) => render(text, 'docs/sample.md', 'docs/guides/sample.html') };
}

test('renders tables, nested lists, fenced code and Mermaid without dropping content', () => {
	const { render } = fixture();
	const html = render('| 欄位 | 值 |\n| --- | --- |\n| 名稱 | 範例 |\n\n1. 外層\n   - 內層\n\n```dart\nprint("<safe>");\n```\n\n```mermaid\ngraph TD\nA --> B\n```');
	assert.match(html, /<table>/);
	assert.match(html, /<td>範例<\/td>/);
	assert.match(html, /<ol>[\s\S]*<ul>[\s\S]*內層/);
	assert.match(html, /language-dart/);
	assert.match(html, /&lt;safe&gt;/);
	assert.match(html, /class="mermaid"/);
});

test('preserves duplicate Chinese headings and explicit anchors', () => {
	const { render } = fixture();
	const html = render('# 中文標題\n\n# 中文標題\n\n<a id="anchor"></a>\n\n[跳轉](#anchor)');
	assert.match(html, /id="中文標題"/);
	assert.match(html, /id="中文標題-1"/);
	assert.match(html, /id="anchor"/);
	assert.match(html, /href="sample.html#anchor"/);
});

test('rewrites relative Markdown links and retains source diagnostics', () => {
	const { render, sourceLinks } = fixture();
	const html = render('[下一頁](next.md#next) [不存在](missing.md)');
	assert.match(html, /href="next.html#next"/);
	assert.match(html, /https:\/\/github.com\/miudog\/Kallopis\/blob\/main\/docs\/missing.md/);
	assert.equal(sourceLinks[1].exists, false);
});

test('escapes raw scripts and blocks executable URL schemes', () => {
	const { render } = fixture();
	const html = render('<script>alert(1)</script>\n\n[危險](javascript:alert%281%29)');
	assert.doesNotMatch(html, /<script>/);
	assert.doesNotMatch(html, /href="javascript:/);
});

test('copies only repository images into output assets', () => {
	const { root, output, render, sourceLinks } = fixture();
	fs.writeFileSync(path.join(root, 'docs', 'sample.png'), 'fixture image');
	const html = render('![本地](sample.png) ![越界](../../outside.png)');
	assert.match(html, /\.\.\/\.\.\/assets\/repository\/docs\/sample.png/);
	assert.equal(fs.readFileSync(path.join(output, 'assets', 'repository', 'docs', 'sample.png'), 'utf8'), 'fixture image');
	assert.equal(sourceLinks[1].exists, false);
});
