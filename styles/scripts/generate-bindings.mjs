import { readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { resolve, relative } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../../', import.meta.url));
const pack = JSON.parse(readFileSync(resolve(root, 'styles/kallopis-v1.json'), 'utf8'));

// 只索引手寫程式；生成資料不作為元件確實引用 token 的證據。
function sources(directory) {
	return readdirSync(directory, { withFileTypes: true }).flatMap(entry => {
		const path = resolve(directory, entry.name);
		if (entry.isDirectory()) return sources(path);
		if (!/\.(dart|tsx?|css)$/.test(entry.name) || /generated|style-pack-data|tokens\.css/.test(entry.name)) return [];
		return [{ path: relative(root, path).replaceAll('\\', '/'), text: readFileSync(path, 'utf8') }];
	});
}

const files = [...sources(resolve(root, 'react/src')), ...sources(resolve(root, 'flutter/lib/src'))];
const bindings = Object.keys(pack.semantics).map(id => {
	const member = id.slice('theme.'.length);
	const css = `--klp-${member.replaceAll('.', '-')}`;
	const references = files.flatMap(file => file.text.split(/\r?\n/).flatMap((line, index) => line.includes(id) || line.includes(member) || line.includes(css) ? [{ path: file.path, line: index + 1 }] : []));
	return { id, flutter: member, react: id, css, references };
});
const content = JSON.stringify({ schemaVersion: 1, bindings }, null, '\t') + '\n';
const output = resolve(root, 'styles/component-bindings.json');
if (process.argv.includes('--check')) {
	if (readFileSync(output, 'utf8') !== content) throw new Error('Component bindings are stale');
} else writeFileSync(output, content);
