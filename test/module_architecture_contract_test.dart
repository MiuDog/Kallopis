import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _acceptedModules = {
	'application',
	'capabilities',
	'composition',
	'features',
	'foundation',
	'kernel',
	'rendering',
	'runtime',
	'styling',
};

const _requiredSections = {
	'目的',
	'非目標',
	'目標階段與能力範圍',
	'所屬路徑與公開介面',
	'責任分布與相依方向',
	'不變條件、生命週期與錯誤權責',
	'允許與禁止的相依',
	'採用設計與否決方案',
	'目前階段切片',
	'驗收證據與測試狀態',
	'受保護路徑',
};

String _read(File file) {
	// 讀取受保護的架構契約，並統一換行以避免平台差異影響判定。
	return file.readAsStringSync().replaceAll('\r\n', '\n');
}

Set<String> _firstLevelDirectories(Directory root) {
	// 僅列舉第一層責任根，巢狀責任區不屬於此模組登錄範圍。
	return root.listSync().whereType<Directory>().map((directory) {
		return directory.path.replaceAll(r'\', '/').split('/').last;
	}).toSet();
}

List<String> _registeredModules(String registry) {
	final registeredSection = registry
		.split('## 已登錄模組')
		.last
		.split('## 相依規則')
		.first;
	final row = RegExp(r'^\|\s*L\d+\s*\|\s*`([^`]+)`\s*\|', multiLine: true);

	return row.allMatches(registeredSection).map((match) => match.group(1)!).toList();
}

void main() {
	late String registry;
	late List<String> registeredModules;

	setUpAll(() {
		registry = _read(File('lib/src/architecture.md'));
		registeredModules = _registeredModules(registry);
	});

	test('module registry lists exactly the nine accepted source modules', () {
		expect(registeredModules, hasLength(_acceptedModules.length), reason: '模組 registry 必須恰好包含九筆且不得重複。');
		expect(registeredModules.toSet(), _acceptedModules, reason: '模組 registry 必須符合已接受的九個責任根。');
	});

	test('module registry matches every first-level source directory', () {
		final firstLevelDirectories = _firstLevelDirectories(Directory('lib/src'));

		expect(registeredModules.toSet(), firstLevelDirectories, reason: '模組 registry 不得遺漏或多列 lib/src 第一層責任根。');
	});

	test('every registered module has a PLAN READY architecture contract', () {
		final violations = <String>[];

		for (final module in registeredModules) {
			final contract = File('lib/src/$module/architecture.md');

			// 先確認契約檔存在，避免缺檔被後續讀取錯誤遮蔽。
			if (!contract.existsSync()) {
				violations.add('$module: 缺少 architecture.md');
				continue;
			}

			final source = _read(contract);
			if (!RegExp(r'^Status:\s*PLAN READY\b', multiLine: true).hasMatch(source)) {
				violations.add('$module: Status 不是 PLAN READY');
			}

			for (final section in _requiredSections) {
				if (!source.contains('\n## $section\n')) violations.add('$module: 缺少「$section」section');
			}
		}

		expect(violations, isEmpty, reason: '架構契約違規：\n${violations.join('\n')}');
	});
}
