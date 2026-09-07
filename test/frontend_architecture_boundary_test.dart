import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Iterable<File> _dartFiles(Directory root) {
	// 只掃描原始碼，讓規則直接對應會被套件編譯的內容。
	return root
			.listSync(recursive: true)
			.whereType<File>()
			.where((file) => file.path.endsWith('.dart'));
}

String _relativePath(File file) => file.path.replaceAll(r'\', '/');

Set<String> _exportUris(File library) {
	final directive = RegExp("^export\\s+['\"]([^'\"]+)['\"]", multiLine: true);
	return directive
			.allMatches(library.readAsStringSync())
			.map((match) => match.group(1)!)
			.toSet();
}

void main() {
	late List<File> sources;

	setUpAll(() {
		sources = _dartFiles(Directory('lib/src')).toList();
	});

	test('Kallopis excludes note product directories and public types', () {
		final noteDirectories = Directory('lib/src')
				.listSync(recursive: true)
				.whereType<Directory>()
				.map((directory) => directory.path.replaceAll(r'\', '/'))
				.where((path) => RegExp(r'/(?:note|notes)(?:/|$)').hasMatch(path))
				.toList();
		final noteDeclaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+KlpNote[A-Za-z0-9_]*\b',
			multiLine: true,
		);
		final noteTypes = <String>[];

		for (final file in sources) {
			if (noteDeclaration.hasMatch(file.readAsStringSync())) {
				noteTypes.add(_relativePath(file));
			}
		}

		expect(
			noteDirectories,
			isEmpty,
			reason: '筆記產品目錄屬於 Notist：\n${noteDirectories.join('\n')}',
		);
		expect(
			noteTypes,
			isEmpty,
			reason: 'KlpNote* 帶有產品語意，必須遷移到 Notist：\n${noteTypes.join('\n')}',
		);
	});

	test('Kallopis excludes requirement and proposal domain types', () {
		final domainDeclaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+'
			r'Klp(?:Requirement|Proposal)[A-Za-z0-9_]*\b',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in sources) {
			if (domainDeclaration.hasMatch(file.readAsStringSync())) {
				violations.add(_relativePath(file));
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Requirement／Proposal 是產品工作流程，不屬於 Kallopis：\n'
					'${violations.join('\n')}',
		);
	});

	test('stable public libraries do not export experimental APIs', () {
		final theme = File('lib/kallopis_theme.dart');
		final foundation = File('lib/kallopis_foundation.dart');
		final experimental = File('lib/kallopis_experimental.dart');

		expect(theme.existsSync(), isTrue);
		expect(foundation.existsSync(), isTrue);
		expect(experimental.existsSync(), isTrue);

		final experimentalExports = _exportUris(experimental);
		for (final stable in [theme, foundation]) {
			final stableExports = _exportUris(stable);
			final overlap = stableExports.intersection(experimentalExports);
			expect(
				stableExports,
				isNot(contains('kallopis_experimental.dart')),
				reason: '${_relativePath(stable)} 不得反向匯出 experimental 入口。',
			);
			expect(
				overlap,
				isEmpty,
				reason:
						'${_relativePath(stable)} 匯出了 experimental 專屬來源：\n'
						'${overlap.join('\n')}',
			);
		}
	});

	test('compatibility library delegates to the three responsibility entries', () {
		final compatibility = File('lib/kallopis.dart');
		expect(
			_exportUris(compatibility),
			{
				'kallopis_experimental.dart',
				'kallopis_foundation.dart',
				'kallopis_theme.dart',
			},
		);
	});

	test('tokens contain primitives without a semantic forwarding barrel', () {
		expect(File('lib/src/tokens/primitive_token.dart').existsSync(), isTrue);
		expect(File('lib/src/tokens/semantic_token.dart').existsSync(), isFalse);
	});

	test('navigation rail does not depend on shell composition', () {
		final violations = <String>[];
		for (final file in _dartFiles(Directory('lib/src/navigation/rail'))) {
			if (RegExp(r'''(?:import|export)\s+['"][^'"]*shell/''')
					.hasMatch(file.readAsStringSync())) {
				violations.add(_relativePath(file));
			}
		}
		expect(
			violations,
			isEmpty,
			reason: 'NavigationRail 是內容元件；PanelFrame 組合必須留在 shell：\n${violations.join('\n')}',
		);
	});

	test('generated component entries point to existing source files', () {
		final sourceLink = RegExp(r'檔案路徑：\[`([^`]+)`\]');
		final violations = <String>[];
		for (final doc in Directory('docs/architecture/components')
				.listSync(recursive: true)
				.whereType<File>()
				.where((file) => file.path.endsWith('.md'))) {
			final match = sourceLink.firstMatch(doc.readAsStringSync());
			if (match != null && !File(match.group(1)!).existsSync()) {
				violations.add('${_relativePath(doc)} -> ${match.group(1)}');
			}
		}
		expect(
			violations,
			isEmpty,
			reason: '元件架構入口不得指向已搬移或刪除的來源：\n${violations.join('\n')}',
		);
	});

	test('components obtain platform only from KlpEnvironmentScope', () {
		const providerPath = 'lib/src/app/klp_platform_info.dart';
		const legacyWindowAdapterPath =
				'lib/src/shell/window/internal/klp_window_platform.dart';
		final bypass = RegExp(
			r'Theme\.of\(context\)\.platform|defaultTargetPlatform|'
			r'Platform\.is(?:Windows|MacOS|Linux|Android|IOS|Fuchsia)',
		);
		final violations = <String>[];

		for (final file in sources) {
			final path = _relativePath(file);
			final source = file.readAsStringSync();
			if (path == providerPath) {
				final providerUses = RegExp(r'\bdefaultTargetPlatform\b').allMatches(source);
				expect(providerUses, hasLength(1));
				continue;
			}
			if (path == legacyWindowAdapterPath) {
				final environmentRead = source.indexOf('KlpEnvironmentScope.maybeOf(context)');
				final legacyFallback = source.indexOf('Theme.of(context).platform');
				if (legacyFallback >= 0) {
					expect(
						environmentRead,
						inInclusiveRange(0, legacyFallback - 1),
						reason: '舊視窗 fallback 只能在 KlpEnvironmentScope 缺失後執行。',
					);
					expect(
						RegExp(r'Theme\.of\(context\)\.platform').allMatches(source),
						hasLength(1),
						reason: '相容 fallback 只能集中在單一 adapter。',
					);
				}
				continue;
			}

			if (bypass.hasMatch(source)) violations.add(path);
		}

		expect(
			violations,
			isEmpty,
			reason:
					'平台偵測只能集中在 $providerPath；元件請讀 context.klpPlatform：\n'
					'${violations.join('\n')}',
		);
	});
}
