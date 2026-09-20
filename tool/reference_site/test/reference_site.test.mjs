import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test, { after } from 'node:test';
import { spawnSync } from 'node:child_process';

const root = path.resolve(import.meta.dirname, '..', '..', '..');
const fixture = path.join(import.meta.dirname, 'fixtures', 'reference-api.json');
const apiManifest = path.join(root, 'build', 'reference-api.json');
const siteRoot = path.join(root, 'build', 'reference-site');
const surfaceContracts = [
	['theme', 'package:kallopis/kallopis_theme.dart', 'Stable Theme'],
	['foundation', 'package:kallopis/kallopis_foundation.dart', 'Stable Components'],
	['experimental', 'package:kallopis/kallopis_experimental.dart', 'Experimental'],
];
const originalApiManifest = fs.existsSync(apiManifest) ? fs.readFileSync(apiManifest) : null;

after(() => {
	if (originalApiManifest === null) {
		fs.rmSync(apiManifest, { force: true });
		return;
	}
	fs.writeFileSync(apiManifest, originalApiManifest);
});

function run(script) {
	return spawnSync(process.execPath, [script], {
		cwd: root,
		encoding: 'utf8',
	});
}

function readFixture() {
	return JSON.parse(fs.readFileSync(fixture, 'utf8'));
}

function readSiteJson(relativePath) {
	return JSON.parse(fs.readFileSync(path.join(siteRoot, relativePath), 'utf8'));
}

function declarationsOf(manifest) {
	return manifest.modules.flatMap((module) => module.declarations);
}

function declarationPage(declaration) {
	return `docs/api/${declaration.module.replaceAll('.', '/')}/${declaration.slug}.html`;
}

function modulePage(module) {
	return `docs/api/${module.name.replaceAll('.', '/')}/index.html`;
}

function escaped(value) {
	return new RegExp(value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
}

function prepareManifest(manifest = readFixture()) {
	fs.mkdirSync(path.dirname(apiManifest), { recursive: true });
	fs.writeFileSync(apiManifest, `${JSON.stringify(manifest, null, '\t')}\n`);
}

function generateSite(manifest) {
	prepareManifest(manifest);
	const result = run('tool/reference_site/generate.mjs');
	assert.equal(result.status, 0, result.stderr || result.stdout);
}

function formalDeclarationPages(directory) {
	if (!fs.existsSync(directory)) return [];
	return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
		const target = path.join(directory, entry.name);
		if (entry.isDirectory()) return formalDeclarationPages(target);
		const relative = path.relative(siteRoot, target).replaceAll('\\', '/');
		return relative.endsWith('.html') && !relative.endsWith('/index.html') ? [relative] : [];
	});
}

test('schema v1 只產生三個現行 surface 與 canonical declaration', () => {
	const api = readFixture();
	generateSite(api);
	const declarations = declarationsOf(api);
	const expectedById = new Map(declarations.map((declaration) => [declaration.id, declarationPage(declaration)]));
	const apiIndex = fs.readFileSync(path.join(siteRoot, 'docs/api/index.html'), 'utf8');

	assert.equal(api.schemaVersion, 1);
	assert.deepEqual(Object.keys(api), ['schemaVersion', 'surfaces', 'modules']);
	assert.deepEqual(api.surfaces.map((surface) => surface.name), surfaceContracts.map(([name]) => name));
	assert.doesNotMatch(JSON.stringify(api), /declarative/i);
	for (const [surface, entrypoint, label] of surfaceContracts) {
		assert.match(apiIndex, escaped(surface));
		assert.match(apiIndex, escaped(entrypoint));
		assert.match(apiIndex, escaped(label));
	}
	for (const module of api.modules) {
		assert.match(apiIndex, escaped(`${module.name.replaceAll('.', '/')}/index.html`));
	}

	const siteManifest = readSiteJson('site-manifest.json');
	assert.deepEqual(
		siteManifest.apiModules.map((module) => module.name),
		api.modules.map((module) => module.name),
		'site manifest 必須雙向列出全部 module',
	);
	assert.equal(siteManifest.apiDeclarations.length, declarations.length);
	assert.deepEqual(
		new Map(siteManifest.apiDeclarations.map((declaration) => [declaration.id, declaration.href])),
		expectedById,
		'site manifest 必須以 canonical id 雙向對應 declaration page',
	);

	const search = readSiteJson('search-index.json').filter((entry) => entry.category === 'API');
	assert.equal(search.length, declarations.length);
	assert.deepEqual(
		new Map(search.map((entry) => [entry.apiId, entry.href])),
		expectedById,
		'search 必須以 canonical id 雙向對應 declaration page',
	);

	for (const module of api.modules) {
		const moduleHtml = fs.readFileSync(path.join(siteRoot, modulePage(module)), 'utf8');
		for (const declaration of module.declarations) {
			assert.match(moduleHtml, escaped(`${declaration.slug}.html`));
			assert.match(moduleHtml, escaped(declaration.kind));
			const classHtml = fs.readFileSync(path.join(siteRoot, declarationPage(declaration)), 'utf8');
			assert.match(classHtml, escaped(declaration.sourceUri));
			assert.match(classHtml, escaped(declaration.signature));
			for (const surface of declaration.surfaces) {
				const contract = surfaceContracts.find(([name]) => name === surface);
				assert.ok(contract, `fixture 含未知 surface：${surface}`);
				assert.match(moduleHtml, escaped(surface));
				assert.match(classHtml, escaped(contract[1]), `${declaration.id} 必須列出 ${surface} import`);
			}
		}
	}

	assert.deepEqual(
		formalDeclarationPages(path.join(siteRoot, 'docs', 'api')).sort(),
		[...expectedById.values()].sort(),
		'每個 canonical declaration 恰好一頁且沒有額外 API 頁',
	);
	const shared = declarations.find((declaration) => declaration.name === 'KlpFixtureTheme');
	assert.deepEqual(shared.surfaces, ['theme', 'foundation']);
	assert.equal(siteManifest.apiDeclarations.filter((declaration) => declaration.id === shared.id).length, 1);
	const duplicateNames = declarations.filter((declaration) => declaration.name === 'KlpFixtureDuplicate');
	assert.equal(duplicateNames.length, 2);
	assert.equal(new Set(duplicateNames.map((declaration) => declaration.sourceUri)).size, 2);
	assert.equal(new Set(duplicateNames.map(declarationPage)).size, 2);
});

test('generator 明確拒絕 declarative surface', () => {
	const api = readFixture();
	api.surfaces.push({
		name: 'declarative',
		entrypoint: 'package:kallopis/kallopis_declarative.dart',
		stability: 'compatibility',
	});
	prepareManifest(api);

	const result = run('tool/reference_site/generate.mjs');
	assert.notEqual(result.status, 0);
	assert.match(`${result.stderr}\n${result.stdout}`, /declarative|surface/i);
});

test('verifier 拒絕缺頁與同一 declaration 多頁', () => {
	const api = readFixture();
	generateSite(api);
	const shared = declarationsOf(api).find((declaration) => declaration.name === 'KlpFixtureTheme');
	const sharedPage = path.join(siteRoot, declarationPage(shared));

	fs.rmSync(sharedPage);
	let result = run('tool/reference_site/verify.mjs');
	assert.notEqual(result.status, 0);
	assert.match(`${result.stderr}\n${result.stdout}`, /KlpFixtureTheme|fixture_theme\.dart#KlpFixtureTheme/);

	generateSite(api);
	fs.copyFileSync(sharedPage, path.join(path.dirname(sharedPage), 'klp-fixture-theme-copy.html'));
	result = run('tool/reference_site/verify.mjs');
	assert.notEqual(result.status, 0);
	assert.match(`${result.stderr}\n${result.stdout}`, /klp-fixture-theme-copy\.html|multiple|duplicate|unexpected/i);
});

test('verifier 拒絕 declaration page 的錯誤 surface', () => {
	const api = readFixture();
	generateSite(api);
	const shared = declarationsOf(api).find((declaration) => declaration.name === 'KlpFixtureTheme');
	const target = path.join(siteRoot, declarationPage(shared));
	const foundationImport = 'package:kallopis/kallopis_foundation.dart';
	const experimentalImport = 'package:kallopis/kallopis_experimental.dart';
	const html = fs.readFileSync(target, 'utf8');

	assert.match(html, escaped(foundationImport));
	fs.writeFileSync(target, html.replaceAll(foundationImport, experimentalImport));
	const result = run('tool/reference_site/verify.mjs');
	assert.notEqual(result.status, 0);
	assert.match(`${result.stderr}\n${result.stdout}`, /surface|foundation/i);
});
