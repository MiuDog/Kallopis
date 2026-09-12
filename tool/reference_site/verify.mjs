import fs from 'node:fs';
import path from 'node:path';

const root = path.resolve(import.meta.dirname, '..', '..');
const output = path.join(root, 'build', 'reference-site');
const manifest = JSON.parse(fs.readFileSync(path.join(output, 'site-manifest.json'), 'utf8'));
const examples = JSON.parse(fs.readFileSync(path.join(root, 'tool/reference_site/assembly_examples.json'), 'utf8'));

function slug(value) {
	return value.replace(/([a-z0-9])([A-Z])/g, '$1-$2').replaceAll('_', '-').toLowerCase();
}

function fail(message) {
	console.error(message);
	process.exitCode = 1;
}

for (const name of manifest.components) {
	const page = path.join(output, 'components', `${slug(name)}.html`);
	if (!fs.existsSync(page)) fail(`Missing component page: ${name}`);
}
for (const document of manifest.apiDocuments) {
	const relative = document.replace(/^docs\/architecture\/src\//, '').replace(/\.md$/, '.html');
	if (!fs.existsSync(path.join(output, 'api', relative))) fail(`Missing API page: ${document}`);
}
for (const guide of manifest.guides) {
	const relative = guide.replace(/^docs\//, '').replace(/\.md$/, '.html');
	if (!fs.existsSync(path.join(output, 'guides', relative))) fail(`Missing guide page: ${guide}`);
}
for (const [name, example] of Object.entries(examples)) {
	if (!manifest.components.includes(name)) fail(`Example targets an unknown component: ${name}`);
	if (!example.import.startsWith('package:kallopis/') || example.import.includes('/src/')) fail(`Example uses a non-public import: ${name}`);
	if (!example.code.includes(name)) fail(`Example does not assemble its component: ${name}`);
}
for (const required of ['index.html', 'get-started.html', 'search-index.json', 'components/index.html', 'api/index.html']) {
	if (!fs.existsSync(path.join(output, required))) fail(`Missing site entry: ${required}`);
}
if (process.exitCode) process.exit(process.exitCode);
console.log(`Reference site verified: ${manifest.components.length} components and ${manifest.apiDocuments.length} API pages.`);
