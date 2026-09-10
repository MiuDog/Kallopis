"""依 Dart AST 中介資料建立逐目錄、逐檔的繁體中文架構索引。"""

import argparse
import hashlib
import html
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def relative(target, page):
	return Path(os.path.relpath(target, page.parent)).as_posix()


def cell(value):
	return html.escape(str(value)).replace('|', '&#124;').replace('\n', ' ')


def label(value):
	return str(value).replace('&', '&amp;').replace('"', '&quot;').replace('<', '&lt;').replace('>', '&gt;')


def chunks(items, size):
	return [items[index:index + size] for index in range(0, len(items), size)]


def evidence(root, source, page, line):
	return f'[{source}:{line}]({relative(root / source, page)}#L{line})'


def diagram(nodes, edges, kind='flowchart TD'):
	if len(nodes) > 4:
		kind = 'flowchart LR'
	lines = [kind]
	for index, name in enumerate(nodes):
		lines.append(f'\tn{index}["{label(name)}"]')
	for start, end, verb in edges:
		lines.append(f'\tn{start} -->|"{label(verb)}"| n{end}')
	return '```mermaid\n' + '\n'.join(lines) + '\n```\n'


def declaration_diagram(nodes, edges):
	lines = ['classDiagram']
	if len(nodes) > 4 and not edges:
		lines.append('\tdirection LR')
	for index, name in enumerate(nodes):
		lines.append(f'\tclass n{index}["{label(name)}"]')
	for start, end, verb in edges:
		relation = {'extends': '--|>', 'implements': '..|>'}.get(verb, '..>')
		lines.append(f'\tn{start} {relation} n{end} : {verb}')
	return '```mermaid\n' + '\n'.join(lines) + '\n```\n'


def generate(root, records):
	# 先備份已有交付目錄；重建才不會留下已刪除來源的舊頁面。
	output = root / 'docs/architecture/src'
	if output.exists():
		backup = Path(tempfile.mkdtemp(prefix='kallopis-atlas-backup-')) / 'src'
		shutil.copytree(output, backup)
		if output.resolve() != (root.resolve() / 'docs/architecture/src'):
			raise ValueError('輸出路徑超出預期位置')
		shutil.rmtree(output)
		print(f'Existing atlas backed up to {backup}')
	output.mkdir(parents=True)
	files = {item['path']: item for item in records}
	source_root = root / 'lib/src'
	folders = sorted([source_root] + [item for item in source_root.rglob('*') if item.is_dir()])
	manifest = {'sourceRoot': 'lib/src', 'extractor': 'Dart analyzer 10.1.0 AST; unresolved syntax', 'folders': [], 'files': [], 'diagramCount': 0, 'maxDiagramNodes': 12}
	limitations = '箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。'
	for source, record in files.items():
		local = Path(source).relative_to('lib/src')
		page = output / local.with_suffix('.md')
		page.parent.mkdir(parents=True, exist_ok=True)
		lines = [f'# {local.name}：直接依賴與宣告架構', '', f'[回到目錄](README.md) · [來源檔案]({relative(root / source, page)})', '', '## 範圍', '', f'核心是 `{source}`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。', '', '## 直接依賴圖', '']
		count = 0
		directives = record['directives']
		for batch in chunks(directives, 11) or [[]]:
			lines.append(diagram([local.name] + [item['target'] for item in batch], [(0, index + 1, item['kind']) for index, item in enumerate(batch)]))
			count += 1
		lines += ['## 依賴證據', '', '| 關係 | 原始 directive | 來源 |', '|---|---|---|']
		for item in directives:
			lines.append(f"| {cell(item['kind'])} | <code>{cell(item['signature'])}</code> | {evidence(root, source, page, item['line'])} |")
		if not directives:
			lines.append('| 無 | 本檔未宣告 import／export／part | ' + evidence(root, source, page, 1) + ' |')
		lines += ['', '## 宣告關係圖', '']
		declarations = record['declarations']
		classlike = [item for item in declarations if item['kind'] in ('ClassDeclaration', 'EnumDeclaration', 'MixinDeclaration', 'ExtensionDeclaration')]
		for batch in chunks(classlike, 12):
			lines += ['本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。', '', declaration_diagram([item['name'] for item in batch], [])]
			count += 1
		for declaration in classlike:
			for batch in chunks(declaration['relations'], 11):
				lines.append(declaration_diagram([declaration['name']] + [item['target'] for item in batch], [(0, index + 1, item['kind']) for index, item in enumerate(batch)]))
				count += 1
		if not classlike:
			lines.append('本檔沒有 class／enum／mixin／extension 宣告；頂層函式、變數與 typedef 見下表。')
		lines += ['', '## 宣告與成員證據', '', '成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。', '']
		for declaration in declarations:
			lines += [f"### {declaration['name']}", '', f"{declaration['kind']} · {declaration['visibility']} · {evidence(root, source, page, declaration['line'])}", '', f"<code>{cell(declaration['signature'])}</code>", '']
			if declaration['summary']:
				lines += ['來源註解摘要：' + cell(declaration['summary'][:700]), '']
			for relation in declaration['relations']:
				lines.append(f"- `{relation['kind']}` → <code>{cell(relation['target'])}</code>：{evidence(root, source, page, relation['line'])}")
			if declaration['members']:
				lines += ['', '| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |', '|---|---|---|---|---|']
				for item in declaration['members']:
					lines.append(f"| {cell(item['kind'])} <code>{cell(item['name'])}</code> | {item['visibility']} | <code>{cell(item['signature'])}</code> | {cell(item['summary'][:350])} | {evidence(root, source, page, item['line'])} |")
			lines.append('')
		lines += ['## 閱讀說明與限制', '', limitations, '', '本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。', '']
		page.write_text('\n'.join(lines), encoding='utf-8')
		manifest['files'].append({'source': source, 'document': page.relative_to(root).as_posix(), 'sha256': hashlib.sha256((root / source).read_bytes()).hexdigest(), 'declarations': len(declarations), 'members': sum(len(item['members']) for item in declarations), 'directives': directives, 'diagramCount': count})
		manifest['diagramCount'] += count
	# 目錄頁逐層導航；每個節點都有實際來源路徑。
	for folder in folders:
		local = folder.relative_to(source_root)
		page = output / local / 'README.md'
		page.parent.mkdir(parents=True, exist_ok=True)
		children = sorted(item for item in folder.iterdir() if item.is_dir())
		ownfiles = sorted(item for item in folder.iterdir() if item.is_file() and item.suffix == '.dart')
		name = 'lib/src' if local == Path('.') else 'lib/src/' + local.as_posix()
		lines = [f'# {name}：架構分析入口', '']
		if folder != source_root:
			lines += ['[上一層](../README.md)', '']
		lines += ['## 範圍', '', f'閱讀 `{name}` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。', '']
		brief = root / 'tool/architecture_atlas/briefs' / f'{local.name}.md'
		if len(local.parts) == 1 and brief.exists():
			lines += ['## 模組閱讀重點', '', brief.read_text(encoding='utf-8').strip(), '']
		# 依本層檔案的明示 directive 聚合同一目錄邊界；保留來源證據，不猜測呼叫。
		dependencies = {}
		local_dependencies = []
		for sourcefile in ownfiles:
			source_name = sourcefile.relative_to(root).as_posix()
			for directive in files[source_name]['directives']:
				target = directive['target']
				if target.startswith('package:kallopis/'):
					resolved = root / 'lib' / target.removeprefix('package:kallopis/')
					boundary = resolved.parent.relative_to(root).as_posix()
				elif target.startswith('package:'):
					boundary = target.rsplit('/', 1)[0] if '/' in target else target
				elif target.startswith('dart:'):
					boundary = target
				elif directive['kind'] == 'part of' and not target.endswith('.dart'):
					boundary = 'library ' + target
				else:
					resolved = (sourcefile.parent / target).resolve()
					boundary = Path(os.path.relpath(resolved.parent, root)).as_posix()
				if boundary == name:
					local_dependencies.append((source_name, directive))
					continue

				dependencies.setdefault((boundary, directive['kind']), []).append((source_name, directive))
		lines += ['## 本層直接依賴圖', '', '箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。', '']
		dependency_batches = chunks(sorted(dependencies), 11)
		for batch in dependency_batches:
			lines.append(diagram([name] + [target for target, kind in batch], [(0, index + 1, kind) for index, (target, kind) in enumerate(batch)]))
		if not dependencies:
			lines += ['本層檔案未宣告跨目錄依賴；子目錄依賴請循下一層入口閱讀。', '']
		lines += ['| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |', '|---|---|---|---|']
		for (boundary, kind), items in sorted(dependencies.items()):
			source_name, directive = items[0]
			lines.append(f"| <code>{cell(boundary)}</code> | {kind} | {len(items)} | {evidence(root, source_name, page, directive['line'])} |")
		if not dependencies:
			lines.append('| 無 | — | 0 | 來源清單見本層檔案 |')
		if local_dependencies:
			lines += ['', '### 同目錄依賴', '', '| 來源 → 目標 | 關係 | 證據 |', '|---|---|---|']
			for source_name, directive in local_dependencies:
				lines.append(f"| <code>{cell(Path(source_name).name)} → {cell(directive['target'])}</code> | {directive['kind']} | {evidence(root, source_name, page, directive['line'])} |")
		lines.append('')
		lines += ['## 目錄結構圖', '']
		entries = children + ownfiles
		batches = chunks(entries, 11) or [[]]
		for batch in batches:
			lines.append(diagram([name] + [item.name + ('/' if item.is_dir() else '') for item in batch], [(0, index + 1, 'contains') for index, item in enumerate(batch)]))
		lines += ['## 子目錄', '', '| 目錄 | 導航 | 來源證據 |', '|---|---|---|']
		for child in children:
			lines.append(f'| `{child.name}/` | [架構入口]({child.name}/README.md) | [來源目錄]({relative(child, page)}) |')
		if not children:
			lines.append('| 無 | 目前沒有下一層目錄 | — |')
		lines += ['', '## 本層檔案', '', '| 檔案 | 宣告 | 細節 | 來源證據 |', '|---|---|---|---|']
		for sourcefile in ownfiles:
			record = files[sourcefile.relative_to(root).as_posix()]
			symbols = ', '.join(item['name'] for item in record['declarations']) or '無頂層宣告'
			lines.append(f'| `{sourcefile.name}` | {cell(symbols)} | [架構與 API]({sourcefile.stem}.md) | {evidence(root, record["path"], page, 1)} |')
		if not ownfiles:
			lines.append('| 無 | 本層沒有 Dart 檔案 | — | — |')
		lines += ['', '## 閱讀說明', '', limitations, '', '本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。', '']
		page.write_text('\n'.join(lines), encoding='utf-8')
		manifest['folders'].append({'source': name, 'document': page.relative_to(root).as_posix(), 'diagramCount': len(batches) + len(dependency_batches)})
		manifest['diagramCount'] += len(batches) + len(dependency_batches)
	(output / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent='\t') + '\n', encoding='utf-8')
	print(f"Generated {len(files)} file pages, {len(folders)} folder pages, {manifest['diagramCount']} diagrams.")


def main():
	parser = argparse.ArgumentParser(description=__doc__)
	parser.add_argument('--dart', default='dart', help='Dart executable path')
	parser.add_argument('--check', action='store_true', help='在暫存目錄重新生成，逐位元比較現有圖集')
	args = parser.parse_args()
	root = Path(__file__).resolve().parents[2]
	# 中介檔放在系統暫存，不污染工作目錄或版控。
	with tempfile.TemporaryDirectory(prefix='kallopis-atlas-') as temporary:
		data = Path(temporary) / 'source.json'
		subprocess.run([args.dart, 'run', 'extract.dart', str(root), str(data)], cwd=Path(__file__).parent, check=True)
		records = json.loads(data.read_text(encoding='utf-8'))
		if not args.check:
			generate(root, records)
			return

		# 驗證使用隔離副本，避免修改現有圖集；目錄、雜湊及全文都會納入比較。
		check_root = Path(temporary) / 'check'
		shutil.copytree(root / 'lib/src', check_root / 'lib/src')
		briefs = root / 'tool/architecture_atlas/briefs'
		if briefs.exists():
			shutil.copytree(briefs, check_root / 'tool/architecture_atlas/briefs')
		generate(check_root, records)
		actual = root / 'docs/architecture/src'
		expected = check_root / 'docs/architecture/src'
		actual_files = {item.relative_to(actual).as_posix(): item.read_bytes() for item in actual.rglob('*') if item.is_file()}
		expected_files = {item.relative_to(expected).as_posix(): item.read_bytes() for item in expected.rglob('*') if item.is_file()}
		changed = sorted(name for name in actual_files.keys() | expected_files.keys() if actual_files.get(name) != expected_files.get(name))
		if changed:
			details = []
			for name in changed:
				actual_hash = hashlib.sha256(actual_files.get(name, b'')).hexdigest()[:12]
				expected_hash = hashlib.sha256(expected_files.get(name, b'')).hexdigest()[:12]
				details.append(f'{name} ({actual_hash} != {expected_hash})')
			raise SystemExit('Atlas out of date: ' + ', '.join(details))
		print(f'Freshness check passed: {len(expected_files)} files match byte for byte.')


if __name__ == '__main__':
	main()
