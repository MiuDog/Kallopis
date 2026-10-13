import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { importStyleTables } from '../src/index.mjs';

try {
	// 僅讀正式三表；舊 JSON 快照不參與此次遷移。
	const documents = Object.fromEntries(['primitives', 'semantics', 'recipes'].map(name => [name, readFileSync(new URL(`../../docs/design-tokens/${name}.md`, import.meta.url), 'utf8')]));
	const pack = importStyleTables(documents, { id: 'kallopis-v1', version: '1.0.0' });
	const destination = new URL('../kallopis-v1.json', import.meta.url);
	const content = JSON.stringify(pack, null, '\t') + '\n';
	if (process.argv.includes('--check')) {
		// 對照所有值與原文；不以數量或檔案存在冒充同步。
		if (readFileSync(destination, 'utf8') !== content) throw new Error('Default style pack is stale');
	}
	else {
		// 此入口只生成 module 資料，不覆寫正式 Markdown 或框架產物。
		writeFileSync(destination, content);
	}
	console.log(`Style pack: ${Object.keys(pack.primitives).length} primitives, ${Object.keys(pack.semantics).length} semantics × 4, ${Object.keys(pack.recipes).length} recipes (${fileURLToPath(destination)})`);
}
catch (error) {
	console.error(error.message);
	process.exitCode = 1;
}
