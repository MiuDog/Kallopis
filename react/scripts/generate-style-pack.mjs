import { createHash } from 'node:crypto';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { resolveStylePack } from '../../styles/src/index.mjs';

const root = fileURLToPath(new URL('../../', import.meta.url));
const output = fileURLToPath(new URL('../src/', import.meta.url));
const sources = ['styles/kallopis-v1.json', 'styles/catalog.json', ...['index.mjs', 'pack.mjs', 'runtime.mjs', 'index.d.mts'].map(name => `styles/src/${name}`)];
const contents = Object.fromEntries(sources.map(path => [path, readFileSync(`${root}${path}`, 'utf8')]));
const pack = JSON.parse(contents['styles/kallopis-v1.json']);
const catalog = JSON.parse(contents['styles/catalog.json']);
for (const mode of ['light', 'dark', 'ultraDark', 'transparent']) resolveStylePack(pack, mode, catalog);
// 框架產物擁有執行資料及純函式副本；值與算法仍由 common source 維護。
const outputs = {
	'style-pack-data.ts': `// 由 common style pack 產生，禁止手改。\nexport const defaultStylePack: unknown = ${JSON.stringify(pack, null, '\t')};\nexport const styleCatalog = ${JSON.stringify(catalog, null, '\t')} as const;\n`,
	'style-pack-manifest.json': JSON.stringify(Object.fromEntries(sources.map(path => [path, createHash('sha256').update(contents[path]).digest('hex')])), null, '\t') + '\n',
	...Object.fromEntries(sources.filter(path => path.startsWith('styles/src/')).map(path => [path.replace('styles/src/', 'style-runtime/'), contents[path]])),
};
for (const [path, content] of Object.entries(outputs)) {
	if (process.argv.includes('--check')) {
		if (readFileSync(`${output}${path}`, 'utf8') !== content) throw new Error(`Generated style output stale: ${path}`);
	} else {
		mkdirSync(fileURLToPath(new URL(`../src/${path.slice(0, path.lastIndexOf('/') + 1)}`, import.meta.url)), { recursive: true });
		writeFileSync(`${output}${path}`, content);
	}
}
console.log('Style pack: four modes validated; owned runtime and source hashes current');
