import fs from 'node:fs';
import path from 'node:path';
import { extractReactApi } from './extract-react-api.mjs';
import { buildReferenceDocuments, updateReferenceDocuments, referenceIndexes } from './reference-docs.mjs';

const root = path.resolve(import.meta.dirname, '../..');
const check = process.argv.includes('--check');
if (process.argv.slice(2).some(argument => argument !== '--check')) throw new Error('Usage: build-reference-docs.mjs [--check]');

// 本次必須讀成功解析的 Flutter 清冊；不自動回退舊快照。
const flutterManifest = JSON.parse(fs.readFileSync(path.join(root, 'build/reference-api.json'), 'utf8'));
const reactDeclarations = await extractReactApi(root);
const result = buildReferenceDocuments({ root, flutterManifest, reactDeclarations });
updateReferenceDocuments(root, result, check);
const outputs = [...referenceIndexes(result.entries), {
	/* source：跨平台機器索引；content：只有識別及路由，不複製文件正文。 */
	source: 'docs/reference/manifest.json', content: `${JSON.stringify(result.entries, null, '\t')}\n`,
}];
for (const output of outputs) {
	const target = path.join(root, output.source);
	if (check) {
		if (!fs.existsSync(target) || fs.readFileSync(target, 'utf8') !== output.content) throw new Error(`Stale reference index: ${output.source}`);
	}
	else fs.writeFileSync(target, output.content);
}

// 每個具 API 標記的頁面都必須屬於當次公開清冊；不靜默留下已移除的 API。
const known = new Set(result.entries.map(entry => entry.source));
function checkOrphans(directory) {
	for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
		const target = path.join(directory, entry.name);
		if (entry.isDirectory()) checkOrphans(target);
		else if (entry.name.endsWith('.md') && fs.readFileSync(target, 'utf8').includes('<!-- reference-api:start -->') && !known.has(path.relative(root, target).replaceAll('\\', '/'))) throw new Error(`Unlisted reference page: ${target}`);
	}
}
checkOrphans(path.join(root, 'docs/reference'));
console.log(`${check ? 'Verified' : 'Updated'} ${result.entries.length} public reference pages (${reactDeclarations.length} React).`);
