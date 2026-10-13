import { createHash } from 'node:crypto';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { resolveStylePack } from '../../styles/src/index.mjs';

const root = fileURLToPath(new URL('../../', import.meta.url));
const destination = fileURLToPath(new URL('../lib/src/styling/style_pack/', import.meta.url));
const paths = ['styles/kallopis-v1.json', 'styles/catalog.json'];
const texts = paths.map(path => readFileSync(`${root}${path}`, 'utf8'));
const [pack, catalog] = texts.map(JSON.parse);
for (const mode of ['light', 'dark', 'ultraDark', 'transparent']) resolveStylePack(pack, mode, catalog);
// JSON 原文是交換 metadata，以標準 Unicode escape 保留解碼後的完整字串。
const jsonMetadata = value => JSON.stringify(value, null, '\t').replace(/[\u0080-\uffff]/g, character => '\\u' + character.charCodeAt(0).toString(16).padStart(4, '0'));
const data = `// 由 common style pack 生成，禁止手改。\nconst klpDefaultStylePackJson = r'''${jsonMetadata(pack)}''';\nconst klpStyleCatalogJson = r'''${jsonMetadata(catalog)}''';\n`;
const manifest = JSON.stringify(Object.fromEntries(paths.map((path, index) => [path, createHash('sha256').update(texts[index]).digest('hex')])), null, '\t') + '\n';
mkdirSync(destination, { recursive: true });
for (const [name, content] of Object.entries({ 'generated.dart': data, 'source-manifest.json': manifest })) {
	if (process.argv.includes('--check')) {
		if (readFileSync(`${destination}${name}`, 'utf8') !== content) throw new Error(`Generated Flutter style stale: ${name}`);
	} else writeFileSync(`${destination}${name}`, content);
}
console.log('Flutter style data: four modes validated, source hashes current');
