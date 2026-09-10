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

	test(
		'compatibility library delegates to the three responsibility entries',
		() {
			final compatibility = File('lib/kallopis.dart');
			expect(_exportUris(compatibility), {
				'kallopis_experimental.dart',
				'kallopis_foundation.dart',
				'kallopis_theme.dart',
			});
		},
	);

	test('source root does not retain retired architecture families', () {
		final sourceRoot = Directory('lib/src');
		final directories = sourceRoot
				.listSync()
				.whereType<Directory>()
				.map((directory) => directory.uri.pathSegments.reversed.skip(1).first)
				.toSet();

		for (final retiredDirectory in const {
			'app',
			'components',
			'controls',
			'data',
			'editor',
			'feedback',
			'form',
			'interaction',
			'layout',
			'l10n',
			'navigation',
			'overlay',
			'routing',
			'settings',
			'shell',
			'styles',
			'surface',
			'theme',
			'tokens',
			'typography',
		}) {
			expect(
				directories,
				isNot(contains(retiredDirectory)),
				reason: 'lib/src 不得保留退役目錄 $retiredDirectory。',
			);
		}
	});

	test('tokens contain primitives without a semantic forwarding barrel', () {
		expect(File('lib/src/styling/legacy_tokens/primitive_token.dart').existsSync(), isTrue);
		expect(File('lib/src/styling/legacy_tokens/semantic_token.dart').existsSync(), isFalse);
	});

	test('action region exposes typed style and keeps Flutter UI in primitives', () {
		final entry = File('lib/src/foundation/interaction/klp_action_region.dart').readAsStringSync();
		final primitive = File(
			'lib/src/foundation/interaction/primitives/klp_action_region_widget.dart',
		).readAsStringSync();
		final publicLibrary = File('lib/kallopis_foundation.dart').readAsStringSync();
		final nativeUi = RegExp(
			r'\b(?:Material|InkWell|Semantics|StatefulBuilder)\s*(?:\.|<|\()',
		);

		expect(nativeUi.hasMatch(entry), isFalse);
		expect(primitive, contains('KlpActionRegionStyle style'));
		expect(primitive, isNot(contains('Color foreground')));
		expect(
			publicLibrary,
			contains("export 'src/foundation/interaction/klp_action_region_style.dart';"),
		);
	});

	test('command menu composition uses typed Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/actions/command_menu/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Column|DecoratedBox|Expanded|Focus|InkWell|Material|Padding|Row|Semantics|SizedBox)\s*(?:\.|<|\()',
		);
		final rawStyle = RegExp(
			r'final\s+(?:double|Color|EdgeInsets|BorderRadius)\??\s+',
		);
		final violations = <String>[];
		for (final file in _dartFiles(Directory('lib/src/features/actions/command_menu'))) {
			final path = _relativePath(file);
			final source = file.readAsStringSync();
			if (!primitivePath.hasMatch(path)) {
				for (final match in nativeUi.allMatches(source)) {
					violations.add('$path:${match.start} ${match.group(0)}');
				}
			}
			for (final match in rawStyle.allMatches(source)) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}
		expect(
			violations,
			isEmpty,
			reason:
					'Command menu 組裝只能使用 typed Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('command menu files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)*'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final violations = <String>[];
		for (final file in _dartFiles(Directory('lib/src/features/actions/command_menu'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}
		expect(violations, isEmpty);
	});

	test('navigation rail does not depend on shell composition', () {
		final violations = <String>[];
		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/rail'))) {
			if (RegExp(
				r'''(?:import|export)\s+['"][^'"]*shell/''',
			).hasMatch(file.readAsStringSync())) {
				violations.add(_relativePath(file));
			}
		}
		expect(
			violations,
			isEmpty,
			reason:
					'NavigationRail 是內容元件；PanelFrame 組合必須留在 shell：\n${violations.join('\n')}',
		);
	});

	test('navigation rail composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/navigation/widgets/rail/primitives/klp_rail_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedOpacity|Center|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Draggable|DragTarget|Expanded|Flexible|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|Row|Semantics|SingleChildScrollView|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Wrap)\s*(?:\.|<|\()',
		);
		final files = _dartFiles(Directory('lib/src/features/navigation/widgets/rail'));
		final violations = <String>[];

		for (final file in files.toSet()) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Navigation rail 組裝層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('navigation rail implementation files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)*'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = _dartFiles(Directory('lib/src/features/navigation/widgets/rail'));
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Navigation rail 實作每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('generated component entries point to existing source files', () {
		final sourceLink = RegExp(r'檔案路徑：\[`([^`]+)`\]');
		final violations = <String>[];
		for (final doc
				in Directory('docs/architecture/components')
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

	test('platform strategies dispatch only through KlpAdaptive', () {
		const providerPath = 'lib/src/foundation/platform/klp_platform_info.dart';
		const adaptivePath = 'lib/src/foundation/layout/klp_adaptive.dart';
		const appScopePath = 'lib/src/application/legacy/klp_app_scope.dart';
		final bypass = RegExp(
			r'Theme\.of\(context\)\.platform|defaultTargetPlatform|'
			r'Platform\.is(?:Windows|MacOS|Linux|Android|IOS|Fuchsia)',
		);
		final violations = <String>[];

		for (final file in sources) {
			final path = _relativePath(file);
			final source = file.readAsStringSync();
			if (path == providerPath) {
				final providerUses = RegExp(
					r'\bdefaultTargetPlatform\b',
				).allMatches(source);
				expect(providerUses, hasLength(1));
				continue;
			}
			if (bypass.hasMatch(source)) violations.add(path);
			if (source.contains('KlpEnvironmentScope.maybeOf(context)') &&
					path != adaptivePath &&
					path != appScopePath) {
				violations.add(path);
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'平台偵測只能由 $providerPath 提供並由 $adaptivePath 分發：\n'
					'${violations.join('\n')}',
		);
	});

	test('window components dogfood Kallopis primitives', () {
		final protectedPath = RegExp(r'lib/src/features/workspace/shell/window/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in sources) {
			final path = _relativePath(file);
			if (!protectedPath.hasMatch(path)) continue;

			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Window 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('window implementation files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/window'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Window Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('typography files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/content'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Typography Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('app files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/application/legacy'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 App Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('app frame dogfoods Kallopis layout primitives', () {
		final nativeLayout = RegExp(
			r'\b(?:Align|Center|Column|Container|DecoratedBox|Expanded|Flexible|GestureDetector|IconButton|InkWell|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|TextField|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/application/legacy'))) {
			final path = _relativePath(file);
			for (final match in nativeLayout.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'App 組合層只能使用 Kallopis 排版原語：\n${violations.join('\n')}',
		);
	});

	test('app screen composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ColoredBox|Column|Container|DecoratedBox|Expanded|Flexible|GestureDetector|IconButton|InkWell|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|TextField|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/composition/app_screen'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'App screen 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('app screen public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/composition/app_screen'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'App screen 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('app screen files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/composition/app_screen'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 App screen Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('stage header dogfoods Kallopis layout primitives', () {
		final source = File(
			'lib/src/features/workspace/shell/stage/klp_stage_header.dart',
		).readAsStringSync();
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|Container|Expanded|Flexible|Padding|Positioned|Row|SizedBox|Spacer|Stack|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[
			for (final match in nativeUi.allMatches(source))
				'lib/src/features/workspace/shell/stage/klp_stage_header.dart:${match.start} ${match.group(0)}',
		];

		expect(
			violations,
			isEmpty,
			reason:
					'Stage header 只能使用 Kallopis 排版原語：\n${violations.join('\n')}',
		);
		expect(source, contains('KlpSpaceSize.chromeToolbar'));
		expect(source, isNot(contains('KlpGap.width(')));
	});

	test('stage top bar composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart'),
			File('lib/src/features/workspace/shell/stage/klp_stage_tab.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Stage top bar 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('stage top bar public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart'),
			File('lib/src/features/workspace/shell/stage/klp_stage_tab.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Stage top bar 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('stage top bar files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart'),
			File('lib/src/features/workspace/shell/stage/klp_stage_tab.dart'),
			..._dartFiles(Directory('lib/src/features/workspace/shell/stage/primitives')).where(
				(file) => _relativePath(file).contains('klp_stage_tab_'),
			),
			File('test/klp_stage_top_bar_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Stage top bar Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('settings components dogfood Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|Container|DecoratedBox|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/settings'))) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Settings 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('overlay composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/overlays/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/overlays'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Overlay 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('feedback composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/feedback/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/feedback'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Feedback 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('button composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/actions/button/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/actions/button'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Button 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('toggle composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/toggle/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/toggle'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Toggle 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('selection composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/selection/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/selection'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Selection 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('form selection fields dogfood Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:AbsorbPointer|Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/selection'))) {
			final path = _relativePath(file);
			final inScope = path.contains('klp_multi_select_') ||
					path.contains('klp_status_role_') ||
					path.contains('klp_date_field');
			if (!inScope || path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Form selection 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('form selection fields expose typed style interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/selection'))) {
			final path = _relativePath(file);
			final inScope = path.contains('klp_multi_select_') ||
					path.contains('klp_status_role_') ||
					path.contains('klp_date_field');
			if (!inScope || path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Form selection 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('form selection field files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/forms/selection')).where((file) {
				final path = _relativePath(file);
				return path.contains('klp_multi_select_') ||
						path.contains('klp_status_role_') ||
						path.contains('klp_date_field');
			}),
			File('lib/src/foundation/interaction/primitives/klp_pointer_blocker.dart'),
			File('test/klp_form_selection_fields_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Form selection Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('input composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/input/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|ConstrainedBox|Container|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/input'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Input 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('form input recipes dogfood Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/(?:input|internal)/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:AbsorbPointer|Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/forms/input')),
			..._dartFiles(Directory('lib/src/features/forms/internal')),
			File('lib/src/features/forms/selection/klp_date_range_field.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Form input recipe 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('compound field composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/input/primitives/klp_compound_field_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/forms/input/klp_compound_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/input/internal')).where(
				(file) => file.path.contains('klp_compound_field_'),
			),
			..._dartFiles(Directory('lib/src/features/forms/input/primitives')).where(
				(file) => file.path.contains('klp_compound_field_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Compound field 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('compound field public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/forms/input/klp_compound_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/input/internal')).where(
				(file) => file.path.contains('klp_compound_field_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Compound field 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('color control composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/color/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|ExcludeSemantics|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/color'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Color control 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('structured form composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/structured/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|ExcludeSemantics|Expanded|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/structured'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Structured form 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('form core composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/core/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/core'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Form Core 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('password field composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|Center|Column|Container|DecoratedBox|Expanded|Flexible|GestureDetector|Icon|IconButton|InkWell|Material|Padding|Positioned|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/forms/input/klp_password_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/input')).where(
				(file) => _relativePath(file).contains('klp_password_'),
			),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Password field 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('password field files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/forms/input/klp_password_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/input')).where(
				(file) => _relativePath(file).contains('klp_password_'),
			),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Password field 每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('code data composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/collections/code/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Builder|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/code'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Code data 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('code data public widgets accept typed viewport geometry', () {
		final rawGeometry = RegExp(
			r'final\s+double\??\s+(?:height|maxHeight|viewportHeight)\b',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/code/internal'))) {
			final path = _relativePath(file);
			for (final match in rawGeometry.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Code data 公開元件必須以 KlpCodeViewportLimit 接收高度：\n${violations.join('\n')}',
		);
	});

	test('advanced data composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/collections/advanced/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/advanced'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Advanced data 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('docking composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/workspace/shell/docking/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/docking'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Docking 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('explorer composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/navigation/widgets/explorer/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/explorer'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Explorer 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('explorer public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/explorer'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Explorer 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('navigator composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/navigation/widgets/navigator/primitives/.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|Center|ClipRRect|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/navigator'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Navigator 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('navigator public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/navigator'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Navigator 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('stepper composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/collections/stepper/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/stepper'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Stepper 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('stepper public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/stepper'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Stepper 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('calendar composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/selection/primitives/klp_calendar_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Dialog|Expanded|Flexible|Focus|GestureDetector|GridView|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|RotatedBox|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_calendar.dart'),
			..._dartFiles(Directory('lib/src/features/forms/selection/internal')).where(
				(file) => file.path.contains('klp_calendar_'),
			),
			..._dartFiles(Directory('lib/src/features/forms/selection/models')).where(
				(file) => file.path.contains('klp_calendar_'),
			),
			..._dartFiles(Directory('lib/src/features/forms/selection/primitives')).where(
				(file) => file.path.contains('klp_calendar_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Calendar 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('calendar public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_calendar.dart'),
			..._dartFiles(Directory('lib/src/features/forms/selection/internal')).where(
				(file) => file.path.contains('klp_calendar_'),
			),
			..._dartFiles(Directory('lib/src/features/forms/selection/models')).where(
				(file) => file.path.contains('klp_calendar_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Calendar 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('select field composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/forms/selection/primitives/klp_select_field_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_select_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/selection/internal')).where(
				(file) => file.path.contains('klp_select_field_'),
			),
			..._dartFiles(Directory('lib/src/features/forms/selection/primitives')).where(
				(file) => file.path.contains('klp_select_field_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Select field 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('select field public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_select_field.dart'),
			..._dartFiles(Directory('lib/src/features/forms/selection/internal')).where(
				(file) => file.path.contains('klp_select_field_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Select field 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('key value composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/collections/key_value/primitives/klp_key_value_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/collections/key_value/klp_key_value_table.dart'),
			..._dartFiles(Directory('lib/src/features/collections/key_value/internal')).where(
				(file) => file.path.contains('klp_key_value_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/key_value/models')).where(
				(file) => file.path.contains('klp_key_value_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/key_value/primitives')).where(
				(file) => file.path.contains('klp_key_value_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Key value 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('key value public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/collections/key_value/klp_key_value_table.dart'),
			..._dartFiles(Directory('lib/src/features/collections/key_value/internal')).where(
				(file) => file.path.contains('klp_key_value_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/key_value/models')).where(
				(file) => file.path.contains('klp_key_value_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Key value 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('accordion composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/collections/accordion/primitives/klp_accordion_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/collections/accordion/klp_accordion.dart'),
			..._dartFiles(Directory('lib/src/features/collections/accordion/internal')).where(
				(file) => file.path.contains('klp_accordion_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/accordion/models')).where(
				(file) => file.path.contains('klp_accordion_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/accordion/primitives')).where(
				(file) => file.path.contains('klp_accordion_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Accordion 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('accordion public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/collections/accordion/klp_accordion.dart'),
			..._dartFiles(Directory('lib/src/features/collections/accordion/internal')).where(
				(file) => file.path.contains('klp_accordion_'),
			),
			..._dartFiles(Directory('lib/src/features/collections/accordion/models')).where(
				(file) => file.path.contains('klp_accordion_'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Accordion 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('artifact workspace composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/workspace/artifact/primitives/klp_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File(
				'lib/src/features/workspace/artifact/klp_artifact_workspace.dart',
			),
			..._dartFiles(
				Directory('lib/src/features/workspace/artifact/internal'),
			),
			..._dartFiles(
				Directory('lib/src/features/workspace/artifact/models'),
			),
			..._dartFiles(
				Directory('lib/src/features/workspace/artifact/primitives'),
			),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Artifact workspace 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('artifact workspace files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = <File>[
			File(
				'lib/src/features/workspace/artifact/klp_artifact_workspace.dart',
			),
			..._dartFiles(Directory('lib/src/features/workspace/artifact')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Artifact workspace 每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('canvas workspace composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/infinite_canvas/primitives/klp_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|InteractiveViewer|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/infinite_canvas/klp_canvas_workspace.dart'),
			..._dartFiles(Directory('lib/src/features/infinite_canvas')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Canvas workspace 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('canvas workspace files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/infinite_canvas/klp_canvas_workspace.dart'),
			..._dartFiles(Directory('lib/src/features/infinite_canvas')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Canvas workspace 每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('page chrome composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|InteractiveViewer|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/page_chrome/klp_page_chrome.dart'),
			..._dartFiles(Directory('lib/src/features/workspace/page_chrome')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Page chrome 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('page chrome files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/page_chrome/klp_page_chrome.dart'),
			..._dartFiles(Directory('lib/src/features/workspace/page_chrome')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Page chrome 每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('entity picker composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(
			r'lib/src/features/workspace/entity_picker/primitives/klp_.+\.dart$',
		);
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|InteractiveViewer|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/entity_picker/klp_entity_picker.dart'),
			..._dartFiles(Directory('lib/src/features/workspace/entity_picker')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Entity picker 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('entity picker files contain one structural definition', () {
		final declaration = RegExp(
			r'^\s*(?:(?:abstract|base|final|interface|sealed)\s+)?'
			r'(?:class|enum|extension|mixin|typedef)\s+',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/entity_picker/klp_entity_picker.dart'),
			..._dartFiles(Directory('lib/src/features/workspace/entity_picker')),
		];
		final violations = <String>[];

		for (final file in files.toSet()) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) violations.add('${_relativePath(file)}: $count');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Entity picker 每檔只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('advanced data public geometry uses typed interfaces', () {
		final rawGeometry = RegExp(
			r'final\s+double\??\s+(?:height|width|extent|size)\b',
		);
		final violations = <String>[];

		for (final directory in const [
			'lib/src/features/collections/advanced/internal',
			'lib/src/features/collections/advanced/models',
		]) {
			for (final file in _dartFiles(Directory(directory))) {
				final path = _relativePath(file);
				for (final match in rawGeometry.allMatches(file.readAsStringSync())) {
					violations.add('$path:${match.start} ${match.group(0)}');
				}
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Advanced data 公開幾何必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('card composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/collections/card/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|Column|ConstrainedBox|Container|DecoratedBox|Expanded|FittedBox|Flexible|GestureDetector|Icon|IconButton|InkWell|LayoutBuilder|ListView|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/card'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Card 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('card public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/card'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Card 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('timeline composition dogfoods Kallopis primitives', () {
		final primitivePath = RegExp(r'lib/src/features/collections/timeline/primitives/.+\.dart$');
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/timeline'))) {
			final path = _relativePath(file);
			if (primitivePath.hasMatch(path)) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Timeline 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('timeline public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/timeline'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Timeline 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('message composer composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(
			Directory('lib/src/features/workspace/message_composer'),
		)) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Message composer 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('message composer public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(
			Directory('lib/src/features/workspace/message_composer'),
		)) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Message composer 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('filter composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/interaction/filter'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Filter 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('filter public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|BorderRadius|BoxBorder)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/interaction/filter'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Filter 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('filter files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/interaction/filter'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Filter Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('badge composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/badge'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Badge 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('badge public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|BorderRadius|BoxBorder)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/badge'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Badge 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('badge files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/badge'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Badge Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('progress composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/progress'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Progress 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('progress files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/progress'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Progress Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('list tile composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/list_tile'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'ListTile 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('list tile public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/list_tile'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'ListTile 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('list tile files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/list_tile'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 ListTile Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('message thread composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/message_thread'))) {
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'MessageThread 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('message thread public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/message_thread'))) {
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'MessageThread 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('message thread files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/message_thread'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 MessageThread Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('preview card composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/preview_card'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'PreviewCard 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('preview card public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/preview_card'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'PreviewCard 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('preview card files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/collections/preview_card')),
			File('test/klp_preview_card_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 PreviewCard Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('sort control composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/sort_control'))) {
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'SortControl 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('sort control public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/sort_control'))) {
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'SortControl 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('sort control files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/collections/sort_control')),
			File('test/klp_sort_control_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 SortControl Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('date grid composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/date_grid'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'DateGrid 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('date grid public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/collections/date_grid'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'DateGrid 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('date grid files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/collections/date_grid')),
			File('test/klp_date_grid_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 DateGrid Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('primary sidebar composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart'),
			File('lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Primary Sidebar 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('primary sidebar public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis|BorderRadius)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart'),
			File('lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Primary Sidebar 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('primary sidebar files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_frame.dart'),
			File('lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_header_inset.dart'),
			File('lib/src/features/workspace/shell/sidebar/klp_sidebar_frame.dart'),
			File('lib/src/features/workspace/shell/sidebar/klp_sidebar_inset.dart'),
			File('test/klp_primary_sidebar_footer_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Primary Sidebar Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('sidebar identity composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final file = File(
			'lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart',
		);
		final violations = <String>[];

		for (final match in nativeUi.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Sidebar identity 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('sidebar identity public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final file = File(
			'lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart',
		);
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Sidebar identity 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('sidebar identity files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/navigation/widgets/sidebar/klp_sidebar_identity_header.dart'),
			File(
				'lib/src/features/navigation/widgets/sidebar/primitives/klp_sidebar_identity_icon_frame.dart',
			),
			File('test/klp_sidebar_identity_header_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Sidebar identity Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('sidebar navigation button composition uses its primitive frame', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart'),
			File(
				'lib/src/features/navigation/widgets/sidebar/internal/klp_sidebar_navigation_button_state.dart',
			),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add(
					'${_relativePath(file)}:${match.start} ${match.group(0)}',
				);
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Sidebar navigation button 組合層只能使用 primitive frame：\n${violations.join('\n')}',
		);
	});

	test('sidebar navigation button public style inputs are semantic', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis|BorderRadius)\??\s+',
		);
		final file = File(
			'lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart',
		);
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Sidebar navigation button 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('sidebar navigation button files contain one definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart'),
			File(
				'lib/src/features/navigation/widgets/sidebar/internal/klp_sidebar_navigation_button_state.dart',
			),
			File(
				'lib/src/features/navigation/widgets/sidebar/primitives/klp_sidebar_navigation_button_frame.dart',
			),
			File('lib/src/features/navigation/widgets/sidebar/klp_navigation_icon_box_key.dart'),
			File('test/klp_sidebar_navigation_button_test.dart'),
			File('test/support/sidebar_navigation_button_subject.dart'),
			File('test/support/sidebar_navigation_button_background.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Sidebar navigation button Dart 檔案只能有一份定義：\n${violations.join('\n')}',
		);
	});

	test('navigation controls composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/controls'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Navigation controls 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('navigation controls public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/controls'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Navigation controls 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('navigation controls files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/navigation/widgets/controls')),
			File('test/klp_navigation_controls_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Navigation controls Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('preview tree composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:AbsorbPointer|Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|ExcludeSemantics|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/preview_tree'))) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Preview tree 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('preview tree public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/preview_tree'))) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Preview tree 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('preview tree files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/navigation/widgets/preview_tree'))) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Preview tree Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('pane composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|ExcludeSemantics|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/composition/pane'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Pane 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('pane public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/workspace/shell/composition/pane'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Pane 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('pane files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/workspace/shell/composition/pane')),
			File('test/klp_pane_components_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Pane Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('reference picker composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/picker'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Reference picker 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('reference picker public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/forms/picker'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Reference picker 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('reference picker files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/forms/picker')),
			File('test/klp_reference_picker_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Reference picker Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('avatar composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/collections/avatar/klp_avatar.dart'),
			File('lib/src/features/collections/avatar/klp_avatar_group.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Avatar 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('avatar public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+|final\s+bool\s+emphasized\b',
		);
		final files = <File>[
			File('lib/src/features/collections/avatar/klp_avatar.dart'),
			File('lib/src/features/collections/avatar/klp_avatar_group.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add(
					'${_relativePath(file)}:${match.start} ${match.group(0)}',
				);
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Avatar 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('avatar files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/collections/avatar')),
			File('test/klp_avatar_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Avatar Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('status bar composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/status/klp_status_bar.dart'),
			File('lib/src/features/workspace/shell/status/internal/klp_status_group.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Status bar 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('status bar public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final file = File('lib/src/features/workspace/shell/status/klp_status_bar.dart');
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Status bar 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('status bar files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/status/klp_status_bar.dart'),
			File('lib/src/features/workspace/shell/status/internal/klp_status_group.dart'),
			File('test/klp_status_bar_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Status bar Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('section composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final file = File('lib/src/foundation/surface/legacy_components/klp_section.dart');
		final violations = <String>[];

		for (final match in nativeUi.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Section 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('section public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final file = File('lib/src/foundation/surface/legacy_components/klp_section.dart');
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Section 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('section files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/foundation/surface/legacy_components/klp_section.dart'),
			File('test/klp_section_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Section Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('panel frame composition delegates Flutter UI to its primitive', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Scrollbar|ScrollbarTheme|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final file = File('lib/src/features/workspace/shell/panel/klp_panel_frame.dart');
		final violations = <String>[];

		for (final match in nativeUi.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Panel frame 組合層只能委派給 primitive frame：\n${violations.join('\n')}',
		);
	});

	test('panel frame public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis|BorderRadius)\??\s+',
		);
		final file = File('lib/src/features/workspace/shell/panel/klp_panel_frame.dart');
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Panel frame 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('panel frame files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/panel/klp_panel_frame.dart'),
			File('lib/src/features/workspace/shell/panel/klp_panel_header_size.dart'),
			File('lib/src/features/workspace/shell/panel/klp_panel_tone.dart'),
			File('lib/src/features/workspace/shell/panel/primitives/klp_panel_frame_view.dart'),
			File('test/klp_panel_frame_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Panel frame Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('panel header composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final file = File('lib/src/features/workspace/shell/panel/klp_panel_header.dart');
		final violations = <String>[];

		for (final match in nativeUi.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Panel header 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('panel header public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/panel/klp_panel_header.dart'),
			File('lib/src/features/workspace/shell/panel/klp_panel_header_drag_region_builder.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Panel header 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('panel header files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/panel/klp_panel_header.dart'),
			File('lib/src/features/workspace/shell/panel/klp_panel_header_drag_region_builder.dart'),
			File('lib/src/features/workspace/shell/panel/primitives/klp_panel_header_frame.dart'),
			File('test/klp_panel_header_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Panel header Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('tabs composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/navigation/widgets/tabs/klp_tabs.dart'),
			File('lib/src/features/navigation/widgets/tabs/internal/klp_tab.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Tabs 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('tabs public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final file = File('lib/src/features/navigation/widgets/tabs/klp_tabs.dart');
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Tabs 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('tabs files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/navigation/widgets/tabs/klp_tabs.dart'),
			File('lib/src/features/navigation/widgets/tabs/internal/klp_tab.dart'),
			File('lib/src/features/navigation/widgets/tabs/primitives/klp_tab_frame.dart'),
			File('lib/src/features/navigation/widgets/tabs/primitives/klp_tabs_viewport.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Tabs Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('stage frame composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final file = File('lib/src/features/workspace/shell/stage/klp_stage_frame.dart');
		final violations = <String>[];

		for (final match in nativeUi.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Stage frame 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('stage frame public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final file = File('lib/src/features/workspace/shell/stage/klp_stage_frame.dart');
		final violations = <String>[];

		for (final match in rawStyle.allMatches(file.readAsStringSync())) {
			violations.add('${_relativePath(file)}:${match.start} ${match.group(0)}');
		}

		expect(
			violations,
			isEmpty,
			reason: 'Stage frame 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('stage frame files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/stage/klp_stage_frame.dart'),
			File('lib/src/features/workspace/shell/stage/primitives/klp_stage_header_slot.dart'),
			File('lib/src/features/workspace/shell/stage/primitives/klp_stage_status_slot.dart'),
			File('lib/src/features/workspace/shell/stage/primitives/klp_stage_surface.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Stage frame Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('tag input composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_tag_chip.dart'),
			File('lib/src/features/forms/selection/klp_tag_input_field.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Tag input 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('tag input public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/forms/selection/klp_tag_chip.dart'),
			File('lib/src/features/forms/selection/klp_tag_input_field.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Tag input 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('tag input files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/forms/selection')).where(
				(file) => _relativePath(file).contains('klp_tag_'),
			),
			File('test/klp_tag_input_field_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Tag input Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('theme preview composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|AspectRatio|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|IgnorePointer|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Opacity|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/theme/klp_theme_preview_mode.dart'),
			File('lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart'),
			File('lib/src/features/workspace/settings/klp_theme_mode_picker.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Theme preview 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('theme preview public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final files = <File>[
			File('lib/src/features/workspace/shell/theme/klp_theme_preview_mode.dart'),
			File('lib/src/features/workspace/shell/theme/klp_theme_preview_tile.dart'),
			File('lib/src/features/workspace/settings/klp_theme_mode_picker.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final path = _relativePath(file);
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Theme preview 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('theme preview files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/workspace/shell/theme')).where(
				(file) => _relativePath(file).contains('klp_theme_preview_'),
			),
			File('lib/src/features/workspace/settings/klp_theme_mode_picker.dart'),
			File('test/klp_theme_preview_tile_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Theme preview Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('split layout composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/layout'))) {
			final path = _relativePath(file);
			if (!path.contains('/klp_split_') || path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Split layout 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('split layout public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/foundation/layout'))) {
			final path = _relativePath(file);
			if (!path.contains('/klp_split_') || path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: 'Split layout 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('split layout files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/foundation/layout'))
					.where((file) => _relativePath(file).contains('/klp_split_')),
			File('test/klp_split_layout_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason: '每個 Split layout Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test('editor action bars composition dogfoods Kallopis primitives', () {
		final nativeUi = RegExp(
			r'\b(?:Align|AnimatedRotation|AnimatedSize|Center|ClipRRect|ColoredBox|Column|ConstrainedBox|Container|CustomPaint|DecoratedBox|Expanded|FittedBox|Flexible|Focus|FractionallySizedBox|GestureDetector|Icon|IconButton|InkWell|IntrinsicHeight|LayoutBuilder|ListView|Material|MouseRegion|Padding|Positioned|PositionedDirectional|Row|Semantics|SizedBox|Spacer|Stack|StatefulBuilder|Text|TextField|TextFormField|Tooltip|Transform|Wrap)\s*(?:\.|<|\()',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/actions/editor'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in nativeUi.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Editor action bars 組合層只能使用 Kallopis 原語：\n${violations.join('\n')}',
		);
	});

	test('editor action bars public style inputs use typed interfaces', () {
		final rawStyle = RegExp(
			r'final\s+(?:double|EdgeInsetsGeometry|Color|Axis)\??\s+',
		);
		final violations = <String>[];

		for (final file in _dartFiles(Directory('lib/src/features/actions/editor'))) {
			final path = _relativePath(file);
			if (path.contains('/primitives/')) continue;
			for (final match in rawStyle.allMatches(file.readAsStringSync())) {
				violations.add('$path:${match.start} ${match.group(0)}');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'Editor action bars 公開樣式輸入必須使用 typed interface：\n${violations.join('\n')}',
		);
	});

	test('editor action bars files contain one structural definition', () {
		final declaration = RegExp(
			r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
			multiLine: true,
		);
		final files = <File>[
			..._dartFiles(Directory('lib/src/features/actions/editor')),
			File('test/klp_editor_action_bars_test.dart'),
		];
		final violations = <String>[];

		for (final file in files) {
			final count = declaration.allMatches(file.readAsStringSync()).length;
			if (count > 1) {
				violations.add('${_relativePath(file)}: $count definitions');
			}
		}

		expect(
			violations,
			isEmpty,
			reason:
					'每個 Editor action bars Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
		);
	});

	test(
		'advanced data, button, calendar, card, code data, color, docking, explorer, message composer, navigator, stepper, timeline, input, selection, toggle, feedback, form, foundation, l10n, overlay, routing, settings, and token files contain one structural definition',
		() {
			final declaration = RegExp(
				r'^(?:(?:abstract|base|final|interface|sealed)\s+)*(?:class|enum|extension|mixin|typedef)\s+|^(?:const|final|var|[A-Za-z_][A-Za-z0-9_<>?]*)\s+[a-zA-Z_][A-Za-z0-9_]*\s*\(',
				multiLine: true,
			);
			final violations = <String>[];

			for (final directory in const [
				'lib/src/features/actions/button',
				'lib/src/features/collections/advanced',
				'lib/src/features/collections/card',
				'lib/src/features/collections/code',
				'lib/src/features/forms/color',
				'lib/src/features/workspace/shell/docking',
				'lib/src/features/navigation/widgets/explorer',
				'lib/src/features/navigation/widgets/navigator',
				'lib/src/features/workspace/message_composer',
				'lib/src/features/collections/stepper',
				'lib/src/features/collections/timeline',
				'lib/src/features/forms/selection/internal',
				'lib/src/features/forms/selection/models',
				'lib/src/features/forms/selection/primitives',
				'lib/src/features/forms/input',
				'lib/src/foundation/interaction/controls',
				'lib/src/features/forms/selection',
				'lib/src/features/forms/toggle',
				'lib/src/features/feedback',
				'lib/src/features/forms/core',
				'lib/src/features/forms/input',
				'lib/src/features/forms/internal',
				'lib/src/features/forms/structured',
				'lib/src/foundation/binding',
				'lib/src/foundation/definitions',
				'lib/src/foundation/internal',
				'lib/src/foundation/metrics',
				'lib/src/foundation/platform',
				'lib/src/foundation/templates',
				'lib/src/application/localization',
				'lib/src/features/overlays',
				'lib/src/features/navigation/legacy_router',
				'lib/src/features/workspace/settings',
				'lib/src/styling/legacy_tokens',
			]) {
				for (final file in _dartFiles(Directory(directory))) {
					final count = declaration.allMatches(file.readAsStringSync()).length;
					if (count > 1) {
						violations.add('${_relativePath(file)}: $count definitions');
					}
				}
			}

			expect(
				violations,
				isEmpty,
				reason:
						'每個 Button／Calendar／Card／Color／Docking／Explorer／Message Composer／Navigator／Stepper／Timeline／Input／Selection／Toggle／Feedback／Form Core／Form Input／Structured Form／Foundation／L10n／Overlay／Routing／Settings／Token Dart 檔案只能有一份結構定義：\n${violations.join('\n')}',
			);
		},
	);
}
