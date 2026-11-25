import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

const root = path.resolve(import.meta.dirname, '../..');
const entries = JSON.parse(fs.readFileSync(path.join(root, 'docs/reference/manifest.json'), 'utf8'));

function snippet(source) {
	const content = fs.readFileSync(path.join(root, source), 'utf8');
	const section = content.includes('## 速成使用') ? content.split('## 速成使用')[1].split('<!-- reference-api:start -->')[0] : content;
	const match = section.match(/```(?:dart|tsx)\n([\s\S]*?)```/);
	if (!match) throw new Error(`Missing quick-use example: ${source}`);
	return match[1];
}

function prepare(framework) {
	const base = framework === 'flutter' ? 'flutter/.dart_tool' : 'react/build';
	// 每輪用獨立的忽略目錄，避免混入上一版已移除的 API；不刪除使用者檔案。
	fs.mkdirSync(path.join(root, base), { recursive: true });
	const directory = fs.mkdtempSync(path.join(root, base, 'reference-doc-examples-'));
	const selected = entries.filter(entry => entry.framework === framework);
	for (const entry of selected) {
		let example = snippet(entry.source);
		if (/import[^\n]*(?:kallopis\/src\/|from ['"]\.)/.test(example)) throw new Error(`Private example import: ${entry.source}`);
		if (framework === 'flutter' && entry.name === 'KlpButton') {
			// 文件中的 Widget tree 片段包成回傳函式，保留原始操作內容。
			example = `import 'package:flutter/widgets.dart';\n${example.replace('KlpButton(', 'Widget buildExample() => KlpButton(').trim()};\n`;
		}
		const extension = framework === 'flutter' ? 'dart' : 'tsx';
		const name = path.basename(entry.source, '.md').replaceAll('-', '_');
		fs.writeFileSync(path.join(directory, `${name}.${extension}`), example);
	}
	const extension = framework === 'flutter' ? 'dart' : 'tsx';
	fs.writeFileSync(path.join(directory, `quickstart.${extension}`), snippet(`docs/reference/${framework}/quickstart.md`));
	if (framework === 'react') {
		fs.writeFileSync(path.join(directory, 'tsconfig.json'), JSON.stringify({
			/* extends：沿用產品型別政策；paths：直接驗證公開 src；noEmit：不改 library 產物。 */
			extends: '../../tsconfig.json', compilerOptions: {
				rootDir: '../..', noEmit: true,
				paths: { '@kallopis/react': ['../../src/index.ts'], '@kallopis/react/styles.css': ['../../src/styles.d.ts'] },
			}, include: ['*.tsx'],
		}, null, '\t'));
	}
	return { /* directory：本輪隔離檢查來源；count：包括平台 quickstart。 */ directory, count: selected.length + 1 };
}

function dartExecutable() {
	for (const directory of (process.env.PATH ?? '').split(path.delimiter)) {
		const candidates = process.platform === 'win32' ? ['dart.exe', 'cache/dart-sdk/bin/dart.exe'] : ['dart'];
		for (const candidate of candidates) {
			const target = path.join(directory, candidate);
			if (fs.existsSync(target)) return target;
		}
	}
	throw new Error('Dart SDK executable not found on PATH');
}

function run(command, args, label) {
	// 將完整診斷保存在 build，失敗不改寫文件或放寬 compiler 設定。
	const result = spawnSync(command, args, { cwd: root, encoding: 'utf8', maxBuffer: 16 * 1024 * 1024, windowsHide: true });
	fs.writeFileSync(path.join(root, `build/reference-${label}-examples.log`), `${result.stdout ?? ''}${result.stderr ?? ''}`);
	if (result.error || result.status !== 0) throw new Error(`${label} example check failed; see build/reference-${label}-examples.log: ${result.error ?? result.status}`);
}

const flutter = prepare('flutter');
const react = prepare('react');
run(process.execPath, [path.join(root, 'react/node_modules/typescript/bin/tsc'), '-p', path.join(react.directory, 'tsconfig.json')], 'react');
run(dartExecutable(), ['analyze', '--format', 'machine', flutter.directory], 'flutter');
console.log(`Verified ${flutter.count} Flutter and ${react.count} React quick-use examples.`);
