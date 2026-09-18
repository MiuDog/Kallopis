import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { spawnSync } from 'node:child_process';

const root = path.resolve(import.meta.dirname, '..', '..', '..');
const fixture = path.join(import.meta.dirname, 'fixtures', 'reference-api.json');
const apiManifest = path.join(root, 'build', 'reference-api.json');
const siteRoot = path.join(root, 'build', 'reference-site');

test('正式 reference 由宣告式 API manifest 建立完整 module 與逐宣告頁面', () => {
	fs.mkdirSync(path.dirname(apiManifest), { recursive: true });
	fs.copyFileSync(fixture, apiManifest);

	const result = spawnSync(process.execPath, ['tool/reference_site/generate.mjs'], {
		cwd: root,
		encoding: 'utf8',
	});
	assert.equal(result.status, 0, result.stderr || result.stdout);

	const siteManifest = JSON.parse(fs.readFileSync(path.join(siteRoot, 'site-manifest.json'), 'utf8'));
	assert.deepEqual(
		siteManifest.apiModules.map((module) => module.name),
		[
			'application',
			'capabilities',
			'composition',
			'features',
			'features.editing.providers',
			'foundation',
			'kernel',
			'rendering',
			'runtime',
			'styling',
		],
	);
	assert.deepEqual(
		siteManifest.apiDeclarations.map((declaration) => declaration.name),
		['KlpFixtureApplication', 'KlpFixtureProvider'],
	);

	for (const relative of [
		'docs/api/application/index.html',
		'docs/api/application/klp-fixture-application.html',
		'docs/api/features/editing/providers/index.html',
		'docs/api/features/editing/providers/klp-fixture-provider.html',
		'docs/api/rendering/index.html',
	]) {
		assert.equal(fs.existsSync(path.join(siteRoot, relative)), true, `缺少 ${relative}`);
	}

	const search = JSON.parse(fs.readFileSync(path.join(siteRoot, 'search-index.json'), 'utf8'));
	for (const name of ['KlpFixtureApplication', 'KlpFixtureProvider']) {
		assert.equal(
			search.filter((entry) => entry.category === 'API' && entry.title === name).length,
			1,
			`${name} 必須恰好有一個正式 API 搜尋項目`,
		);
	}
});
