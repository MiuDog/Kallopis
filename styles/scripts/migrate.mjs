import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { validateStylePack, exportStyleTables } from '../src/index.mjs';

try {
	const destination = new URL('../kallopis-v1.json', import.meta.url);
	const pack = validateStylePack(JSON.parse(readFileSync(destination, 'utf8')));
	// 共通資料擁有值；只替換資料列，保留文件標題、說明與連結。
	for (const [name, table] of Object.entries(exportStyleTables(pack))) {
		const path = new URL(`../../docs/design-tokens/${name}.md`, import.meta.url);
		const original = readFileSync(path, 'utf8');
		const rows = table.split(/\r?\n/).filter(line => /^\|\s*`/.test(line));
		const byId = new Map(rows.map(row => [row.match(/^\|\s*`([^`]+)`/)[1], row]));
		const seen = new Set();
		const content = original.replace(/^\|\s*`([^`]+)`[^\r\n]*/gm, (row, id) => {
			if (!byId.has(id) || seen.has(id)) throw new Error(`Invalid table ID: ${name}.${id}`);
			seen.add(id);
			return byId.get(id);
		});
		if (seen.size !== byId.size) throw new Error(`Missing table IDs: ${name}`);
		if (process.argv.includes('--check')) {
			if (original !== content) throw new Error(`Generated style table stale: ${name}`);
		} else writeFileSync(path, content);
	}
	console.log(`Style pack: ${Object.keys(pack.primitives).length} primitives, ${Object.keys(pack.semantics).length} semantics × 4, ${Object.keys(pack.recipes).length} recipes (${fileURLToPath(destination)})`);
}
catch (error) {
	console.error(error.message);
	process.exitCode = 1;
}
