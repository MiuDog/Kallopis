import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { spawnSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

const root = path.resolve(
	import.meta.dirname,
	'..',
	'..',
	'..',
);
const runtimeConfig = path.join(root, 'flutter/.dart_tool/package_config.json');
const extractor = path.join(root, 'tool/reference_site/extract_api.dart');
const dart = 'D:/flutter/bin/dart.bat';
const sharedSource = `import 'package:flutter/widgets.dart';

class FixtureDirect extends Widget {
	const FixtureDirect({super.key});
	@override
	Element createElement() => throw UnimplementedError();
}
class FixtureInherited extends FixtureDirect {}
final class FixtureFinal extends FixtureDirect {}
base class FixtureBase extends FixtureDirect {}
interface class FixtureInterface extends FixtureDirect {}
mixin class FixtureMixinClass implements Widget {
	@override
	dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
abstract class FixtureAbstract extends Widget {}
sealed class FixtureSealed extends Widget {}
abstract final class FixtureAbstractFinal extends Widget {}
abstract base class FixtureAbstractBase extends Widget {}
class FixtureData {}
mixin FixtureMixin {}
enum FixtureEnum { value }
extension FixtureExtension on FixtureData {}
class FixtureHidden extends FixtureDirect {}
class FixtureNeverExported extends FixtureDirect {}
class _FixturePrivate extends FixtureDirect {}
`;
const fakeSource = `class Widget {}
class FixtureFakeWidget extends Widget {}
`;

// 暫存 fixture 由此測試擁有；只沿用已安裝套件，不修改正式 manifest 或套件設定。
function workspace() {
	const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'kallopis-renderable-'));
	const flutter = path.join(directory, 'flutter');
	const library = path.join(flutter, 'lib');
	fs.mkdirSync(path.join(library, 'src/foundation'), { recursive: true });
	fs.mkdirSync(path.join(flutter, '.dart_tool'), { recursive: true });
	fs.writeFileSync(path.join(flutter, 'pubspec.yaml'), 'name: kallopis\nenvironment: {sdk: ^3.12.2}\n');
	const config = JSON.parse(fs.readFileSync(runtimeConfig, 'utf8'));
	for (const entry of config.packages) {
		entry.rootUri = entry.name === 'kallopis'
			? pathToFileURL(`${flutter}${path.sep}`).href
			: new URL(entry.rootUri, pathToFileURL(runtimeConfig)).href;
	}
	fs.writeFileSync(path.join(flutter, '.dart_tool/package_config.json'), JSON.stringify(config));
	fs.writeFileSync(path.join(library, 'src/foundation/shared.dart'), sharedSource);
	fs.writeFileSync(path.join(library, 'src/foundation/fake.dart'), fakeSource);
	fs.writeFileSync(path.join(library, 'src/foundation/transitive.dart'), "export 'shared.dart' hide FixtureNeverExported;\n");
	fs.writeFileSync(path.join(library, 'kallopis_theme.dart'), "export 'src/foundation/transitive.dart' show FixtureDirect, FixtureData;\n");
	fs.writeFileSync(path.join(library, 'kallopis_foundation.dart'), "export 'src/foundation/transitive.dart' hide FixtureHidden;\nexport 'src/foundation/fake.dart';\n");
	fs.writeFileSync(path.join(library, 'kallopis_experimental.dart'), "export 'src/foundation/transitive.dart' show FixtureDirect;\n");
	return { directory, library, output: path.join(directory, 'manifest.json') };
}

function run(fixture) {
	const command = `"${dart}" "--packages=${runtimeConfig}" "${extractor}" --output "${fixture.output}"`;
	const arguments_ = [
		'/d',
		'/s',
		'/c',
		`"${command}"`,
	];
	return spawnSync(process.env.ComSpec || 'cmd.exe', arguments_, {
		cwd: fixture.directory,
		encoding: 'utf8',
		timeout: 120_000,
		windowsVerbatimArguments: true,
	});
}

function manifest(fixture) {
	const result = run(fixture);
	assert.equal(result.error, undefined, 'CLI 必須可啟動');
	assert.equal(result.status, 0, result.stderr || result.stdout);
	return JSON.parse(fs.readFileSync(fixture.output, 'utf8'));
}

function declarations(api) {
	return api.modules.flatMap((module) => module.declarations);
}

function cleanup(fixture) {
	fs.rmSync(fixture.directory, { recursive: true, force: true });
}

test('真正 Flutter Widget 的具體子型別具 renderable，抽象與其他型別不具 renderable', () => {
	const fixture = workspace();
	try {
		const api = manifest(fixture);
		assert.equal(api.schemaVersion, 1);
		const entries = declarations(api);
		const expected = new Map([
			['FixtureDirect', true],
			['FixtureInherited', true],
			['FixtureFinal', true],
			['FixtureBase', true],
			['FixtureInterface', true],
			['FixtureMixinClass', true],
			['FixtureAbstract', false],
			['FixtureSealed', false],
			['FixtureAbstractFinal', false],
			['FixtureAbstractBase', false],
			['FixtureData', false],
			['FixtureMixin', false],
			['FixtureEnum', false],
			['FixtureExtension', false],
			['Widget', false],
			['FixtureFakeWidget', false],
		]);
		for (const entry of entries) {
			assert.equal(typeof entry.renderable, 'boolean', `${entry.name} 必須提供 boolean renderable`);
		}
		for (const [name, renderable] of expected) {
			const entry = entries.find((value) => value.name === name);
			assert.ok(entry, `${name} 必須出現在公開清單`);
			assert.equal(entry.renderable, renderable, `${name} 的 renderable 必須符合真實 Flutter identity 與 abstract 狀態`);
		}
	} finally {
		cleanup(fixture);
	}
});

test('root export show/hide 限制公開集合，canonical identity 跨 surface 合併', () => {
	const fixture = workspace();
	try {
		const entries = declarations(manifest(fixture));
		for (const name of ['FixtureHidden', 'FixtureNeverExported', '_FixturePrivate']) {
			assert.equal(entries.some((entry) => entry.name === name), false, `${name} 不得由 transitive library 遍歷追回`);
		}
		const shared = entries.filter((entry) => entry.name === 'FixtureDirect');
		assert.equal(shared.length, 1, '同來源 declaration 跨三個 barrels 必須只出現一次');
		assert.equal(shared[0].id, 'package:kallopis/src/foundation/shared.dart#FixtureDirect');
		assert.equal(shared[0].sourceUri, 'package:kallopis/src/foundation/shared.dart');
		assert.deepEqual([...shared[0].surfaces].sort(), ['experimental', 'foundation', 'theme']);
		const data = entries.find((entry) => entry.name === 'FixtureData');
		assert.deepEqual([...data.surfaces].sort(), ['foundation', 'theme']);
		const inherited = entries.find((entry) => entry.name === 'FixtureInherited');
		assert.deepEqual(inherited.surfaces, ['foundation'], 'theme 與 experimental 的 show 不得增加未公開的 surface');
		assert.equal(new Set(entries.map((entry) => entry.id)).size, entries.length);
	} finally {
		cleanup(fixture);
	}
});

for (const failure of ['missing-input', 'analyzer-error']) {
	test(`${failure} 失敗時保留既有 manifest 原始內容`, () => {
		const fixture = workspace();
		try {
			manifest(fixture);
			const original = Buffer.from('既有 manifest，必須完整保留\n');
			fs.writeFileSync(fixture.output, original);
			if (failure === 'missing-input') {
				fs.rmSync(path.join(fixture.library, 'kallopis_theme.dart'));
			} else {
				fs.appendFileSync(path.join(fixture.library, 'src/foundation/shared.dart'), '\nclass FixtureBroken extends DoesNotExist {}\n');
			}
			const result = run(fixture);
			assert.equal(result.error, undefined, '失敗證據必須來自 CLI，不能是 launcher 錯誤');
			assert.notEqual(result.status, null, 'CLI 不得因 timeout 或 signal 中斷');
			assert.notEqual(result.status, 0, `${failure} 必須非零結束`);
			assert.deepEqual(fs.readFileSync(fixture.output), original, `${failure} 不得覆寫舊 manifest`);
		} finally {
			cleanup(fixture);
		}
	});
}
