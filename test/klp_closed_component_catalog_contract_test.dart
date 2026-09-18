import 'dart:io';

import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

const _libraryOwnedApplication = '''import 'package:kallopis/kallopis_declarative.dart';

final destination = KlpDestination<int, String>(KlpId.parse('main'));
KlpScreen screen(KlpRouteInput<int, String> input) => KlpScreen(
	id: KlpId.parse('screen'),
	accessibilityLabel: 'Screen',
	child: KlpAppLayout(
		id: KlpId.parse('layout'),
		child: KlpAppFrame(
			id: KlpId.parse('frame'),
			child: KlpFrameGroups(
				id: KlpId.parse('groups'),
				groups: [
					KlpFrameGroup(
						id: KlpId.parse('group'),
						content: [
							KlpWorkspaceBlock(
								id: KlpId.parse('content'),
								kind: KlpWorkspaceBlockKind.paper,
								title: 'Content',
							),
						],
					),
				],
			),
		),
	),
);
final route = KlpRoute<int, String>(destination, screen: screen);
final router = KlpRouter(
	id: KlpId.parse('router'),
	initial: destination.location(1),
	routes: [route],
);
KlpApplication application(KlpPrimitiveSet primitives) => KlpApplication(
	title: 'App',
	primitives: primitives,
	router: router,
);
''';

void main() {
	_testExplorerClosure();
	_testLayoutClosure();
	_testFileSelectionClosure();
	late KlpExternalCompileFixture fixture;
	final cases = <({String name, String source, String code})>[
		(
			name: 'KlpApplication.components registration',
			source:
				"KlpApplication invalid(KlpPrimitiveSet primitives) => KlpApplication(title: 'App', primitives: primitives, router: router, components: const []);",
			code: 'undefined_named_parameter',
		),
		(
			name: 'KlpComponentDefinition',
			source: 'KlpComponentDefinition<KlpNode>? forbidden;',
			code: 'undefined_class',
		),
		(name: 'KlpComponentCompiler', source: 'KlpComponentCompiler? forbidden;', code: 'undefined_class'),
		(name: 'KlpComponentAdapter', source: 'KlpComponentAdapter? forbidden;', code: 'undefined_class'),
		(name: 'KlpTreeRuntime', source: 'KlpTreeRuntime? forbidden;', code: 'undefined_class'),
		(name: 'KlpPrepareContext', source: 'KlpPrepareContext? forbidden;', code: 'undefined_class'),
		(
			name: 'KlpDefinition',
			source: 'KlpDefinition<KlpNode>? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpRegistry',
			source: 'KlpRegistry? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpTreeValidation',
			source: 'KlpTreeValidation? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpValidatedNode',
			source: 'KlpValidatedNode? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpValidatedSlot',
			source: 'KlpValidatedSlot? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpActionActivation',
			source: 'KlpActionActivation? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpActionHandler',
			source: 'KlpActionHandler? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpTemplate',
			source: 'KlpTemplate<KlpNode>? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpTextSemantics',
			source: 'KlpTextSemantics? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpStyleRef',
			source: 'KlpStyleRef<KlpColor>? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpSemanticKey',
			source: 'KlpSemanticKey<KlpColor>? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpSemanticSchema',
			source: 'KlpSemanticSchema? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpSemanticToken',
			source: 'KlpSemanticToken<KlpColor>? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpRail',
			source: 'KlpRail? forbidden;',
			code: 'undefined_class',
		),
		(
			name: 'KlpRailItem',
			source: 'KlpRailItem? forbidden;',
			code: 'undefined_class',
		),
	];
	final targetLine = '\n'.allMatches(_libraryOwnedApplication).length + 1;

	setUpAll(() async {
		fixture = await KlpExternalCompileFixture.create({
			'positive': _libraryOwnedApplication,
			for (final item in cases)
				item.name: '$_libraryOwnedApplication${item.source}\n',
		});
		addTearDown(fixture.dispose);
	});

	test('library-owned application declaration compiles', () async {
		final result = await fixture.resolve('positive');
		expect(
			result.diagnostics.where(
				(diagnostic) =>
					diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR,
			),
			isEmpty,
			reason: result.diagnostics.join('\n'),
		);
	});

	test('public barrel exports only consumer-owned module layers', () {
		final barrel = File('lib/kallopis_declarative.dart').readAsStringSync();
		final exportsByLevel = {
			for (var level = 0; level <= 7; level++) level: <String>[],
		};
		int? currentLevel;
		for (final line in barrel.split('\n')) {
			final levelMatch = RegExp(r'^// L([0-7])\b').firstMatch(line);
			if (levelMatch != null) {
				currentLevel = int.parse(levelMatch.group(1)!);
				continue;
			}
			final exportMatch = RegExp(r"^export '([^']+)'").firstMatch(line);
			if (exportMatch == null) continue;

			expect(currentLevel, isNotNull, reason: line);
			exportsByLevel[currentLevel]!.add(exportMatch.group(1)!);
		}
		final exports = [
			for (final level in exportsByLevel.values) ...level,
		];
		final paths = RegExp(
			r"^export 'src/([^']+)';",
			multiLine: true,
		).allMatches(barrel).map((match) => match.group(1)!).toList();
		const allowedRoots = {
			'kernel',
			'capabilities',
			'styling',
			'composition',
			'foundation',
			'features',
			'application',
		};
		const forbiddenPaths = {
			'capabilities/actions/klp_action_activation.dart',
			'capabilities/actions/klp_action_handler.dart',
			'composition/definitions/klp_definition.dart',
			'composition/registry/klp_registry.dart',
			'composition/validation/klp_tree_validation.dart',
			'composition/validation/klp_validated_node.dart',
			'composition/validation/klp_validated_slot.dart',
			'features/navigation/rail/contracts/klp_rail.dart',
			'features/navigation/rail/contracts/klp_rail_item.dart',
			'foundation/definitions/klp_component_definition.dart',
			'foundation/templates/klp_template.dart',
			'foundation/templates/klp_text_semantics.dart',
			'styling/references/klp_style_ref.dart',
			'styling/semantics/klp_semantic_key.dart',
			'styling/semantics/klp_semantic_schema.dart',
			'styling/semantics/klp_semantic_token.dart',
		};

		expect(paths, isNotEmpty);
		expect(exports.toSet().length, exports.length, reason: exports.join('\n'));
		bool belongsToLevel(int level, String path) => switch (level) {
			0 => path.startsWith('src/kernel/'),
			1 =>
				path.startsWith('src/capabilities/') ||
				path.startsWith('src/styling/'),
			2 => path.startsWith('src/composition/'),
			3 => path.startsWith('src/foundation/'),
			4 => false,
			5 =>
				path.startsWith('src/features/') ||
				path.startsWith('package:krepis_'),
			6 => false,
			7 => path.startsWith('src/application/'),
			_ => false,
		};
		for (final entry in exportsByLevel.entries) {
			expect(
				entry.value.where((path) => !belongsToLevel(entry.key, path)),
				isEmpty,
				reason: 'L${entry.key}: ${entry.value.join(', ')}',
			);
		}
		expect(exportsByLevel[4], isEmpty);
		expect(exportsByLevel[6], isEmpty);
		expect(
			paths.where(
				(path) => !allowedRoots.contains(path.split('/').first),
			),
			isEmpty,
			reason: paths.join('\n'),
		);
		expect(
			paths.where(
				(path) => path.startsWith('runtime/') || path.startsWith('rendering/'),
			),
			isEmpty,
			reason: paths.join('\n'),
		);
		expect(
			paths.where(forbiddenPaths.contains),
			isEmpty,
			reason: paths.join('\n'),
		);
	});

	for (final item in cases) {
		test('consumer cannot use ${item.name}', () async {
			final result = await fixture.resolve(item.name);
			final errors = result.diagnostics.where(
				(diagnostic) =>
					diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR,
			);
			// 合法控制組不能失敗，指定錯誤也必須落在額外加入的違規列。
			expect(
				errors.where(
					(error) =>
						result.lineInfo.getLocation(error.offset).lineNumber < targetLine,
				),
				isEmpty,
				reason: result.diagnostics.join('\n'),
			);
			expect(
				errors.where(
					(error) =>
						error.diagnosticCode.lowerCaseUniqueName == item.code &&
						result.lineInfo.getLocation(error.offset).lineNumber == targetLine,
				),
				isNotEmpty,
				reason:
					'${item.name}: ${item.code} at line $targetLine\n${result.diagnostics.join('\n')}',
			);
		});
	}
}

void _testFileSelectionClosure() {
	const current = "import 'package:kallopis/kallopis_declarative.dart';\nvoid receive(String path) {}\nconst action = KlpPickFileAction(acceptedExtensions: ['png'], onPicked: receive);\n";
	const legacy = "import 'package:kallopis/kallopis_legacy_file_picker.dart';\nvoid receive(String path) {}\nconst picker = KlpLocalFilePicker(acceptedExtensions: ['png'], onPicked: receive);\n";
	final sources = <String, String>{
		'current positive': '${current}final KlpAction intent = action;\nfinal block = KlpWorkspaceBlock(id: KlpId.parse("pick"), kind: KlpWorkspaceBlockKind.action, title: "Pick", action: action);\n',
		'legacy positive': '${legacy}Future<void> pick() => picker.pick();\n',
		'current legacy': '${current}KlpLocalFilePicker? forbidden;\n',
		'legacy action': '${legacy}KlpPickFileAction? forbidden;\n',
		'imperative action': '${current}void forbidden() => action.pick();\n',
		for (final name in ['KlpFileSelectionPort', 'KlpFileSelectionRequest', 'KlpFileSelectionResult', 'KlpFileSelectionAdapter', 'KlpEnvironmentSnapshot', 'XFile', 'FileSelectorPlatform']) 'private $name': '$current$name? forbidden;\n',
	};
	late KlpExternalCompileFixture fixture;
	group('HOST PORTS external authoring boundary', () {
		setUpAll(() async {
			fixture = await KlpExternalCompileFixture.create(sources);
			addTearDown(fixture.dispose);
		});
		for (final entry in sources.entries) {
			test(entry.key, () async {
				final result = await fixture.resolve(entry.key);
				final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR).toList();
				if (entry.key.endsWith('positive')) {
					expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
					return;
				}

				// 合法前三列必須通過；只允許第四列的指定不可見型別或不存在方法。
				final code = entry.key == 'imperative action' ? 'undefined_method' : 'undefined_class';
				expect(errors.map((error) => error.diagnosticCode.lowerCaseUniqueName), [code], reason: result.diagnostics.join('\n'));
				expect(result.lineInfo.getLocation(errors.single.offset).lineNumber, 4);
			});
		}
	});
}

void _testLayoutClosure() {
	const prelude = '''import 'package:kallopis/kallopis_declarative.dart';

final id = KlpId.parse('consumer');
final leaf = LayoutSpacer(id: KlpId.parse('leaf'));
final groups = KlpFrameGroups(id: KlpId.parse('groups'), groups: []);
''';
	const arguments = <String, String>{
		'KlpAppLayout': 'id: id, child: leaf',
		'LayoutRow': 'id: id, children: [leaf]',
		'LayoutColumn': 'id: id, children: [leaf]',
		'LayoutResizeHandle': 'id: id',
		'LayoutSpacer': 'id: id',
		'KlpLayoutPane': 'id: id, child: groups',
		'KlpAppFrame': 'id: id, child: groups',
	};
	final sources = <String, String>{};
	for (final entry in arguments.entries) {
		final type = entry.key;
		sources['construct $type'] = '${prelude}final instance = $type(${entry.value});\n';
		sources['extends $type'] = '${prelude}final class Consumer extends $type { Consumer() : super(${entry.value}); }\n';
		sources['implements $type'] = '${prelude}abstract final class Consumer implements $type {}\n';
	}
	sources['qualification'] = '''${prelude}final class Consumer implements KlpLayoutNode {
	@override
	KlpId get id => KlpId.parse('qualified');
	@override
	String get definitionId => LayoutSpacer.typeId;
	@override
	KlpChildren get children => KlpChildren([]);
}
''';
	late KlpExternalCompileFixture layoutFixture;
	group('external layout closure', () {
		setUpAll(() async {
			// 使用既有獨立套件分析器，正負向案例共享同一個合法公開入口。
			layoutFixture = await KlpExternalCompileFixture.create(sources);
			addTearDown(layoutFixture.dispose);
		});
		for (final type in arguments.keys) {
			test('construct $type remains legal', () async {
				final result = await layoutFixture.resolve('construct $type');
				final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR);
				expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
			});
			for (final operation in ['extends', 'implements']) {
				test('$operation $type is rejected by final class boundary', () async {
					final key = '$operation $type';
					final result = await layoutFixture.resolve(key);
					final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR).toList();
					final code = operation == 'extends' ? 'final_class_extended_outside_of_library' : 'final_class_implemented_outside_of_library';
					final targetOffset = sources[key]!.indexOf('$operation $type') + operation.length + 1;

					// 唯一錯誤必須指向被繼承的型別，不能以缺少建構子或其他語法錯誤冒充封閉。
					expect(errors.map((error) => error.diagnosticCode.lowerCaseUniqueName), [code], reason: '$key\n${result.diagnostics.join('\n')}');
					expect(errors.single.offset, targetOffset);
					expect(errors.single.length, type.length);
				});
			}
		}
		test('qualification can still be implemented outside the library', () async {
			final result = await layoutFixture.resolve('qualification');
			final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR);
			expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
		});
	});
}

void _testExplorerClosure() {
	const source = '''import 'package:kallopis/kallopis_declarative.dart';
final treeId = KlpId.root('tree');
final item = KlpExplorerNodeModel(id: KlpId.root('item'), row: KlpExplorerRowData(title: 'Item'), canHaveChildren: false);
final tree = KlpExplorerTreeData(id: treeId, items: [item]);
final scope = KlpExplorerSelectionScope(id: KlpId.root('scope'), treeIds: [treeId], mode: KlpExplorerSelectionMode.multiple);
final data = KlpExplorerData(trees: [tree], selectionScopes: [scope]);
final explorer = KlpExplorer(id: treeId, data: data);
''';
	const external = '''
final class ConsumerItem implements KlpExplorerItemModel {
	@override
	KlpId get id => KlpId.root('external');
	@override
	KlpExplorerRole get role => KlpExplorerRole.node;
	@override
	bool get canHaveChildren => false;
	@override
	KlpExplorerRowData get row => KlpExplorerRowData(title: 'External');
	@override
	KlpExplorerCapabilities get capabilities => const KlpExplorerCapabilities(selectable: true);
	@override
	List<KlpExplorerItemModel> get children => const [];
}
KlpExplorerNodeModel wrap(String title) => KlpExplorerNodeModel(id: KlpId.root(title), row: KlpExplorerRowData(title: title), canHaveChildren: false);
final bool hasChildren = ConsumerItem().hasChildren;
''';
	final cases = <String, String>{
		'positive': '$source$external',
		for (final name in ['KlpExplorerEntryNode', 'KlpExplorerSnapshot', 'KlpExplorerItem', 'KlpExplorerItemKind', 'KlpExplorerIcon', 'KlpExplorerDropPosition', 'KlpExplorerCommandPresentation']) 'private $name': '$source$name? forbidden;\n',
		for (final argument in ['allowNesting: false', 'selectedId: null', 'selectedIds: {}', 'expandedIds: {}', 'spacing: null', 'commandPresentation: null', 'onSelected: null', 'onMove: null', 'canMove: null', 'items: []']) 'removed $argument': '${source}final invalid = KlpExplorer(id: treeId, data: data, $argument);\n',
	};
	late KlpExternalCompileFixture fixture;
	group('Explorer external contract cutover', () {
		setUpAll(() async {
			fixture = await KlpExternalCompileFixture.create(cases);
			addTearDown(fixture.dispose);
		});
		for (final entry in cases.entries) {
			test(entry.key, () async {
				final result = await fixture.resolve(entry.key);
				final errors = result.diagnostics.where((diagnostic) => diagnostic.diagnosticCode.severity == DiagnosticSeverity.ERROR).toList();
				if (entry.key == 'positive') {
					expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
					return;
				}

				final code = entry.key.startsWith('private ') ? 'undefined_class' : 'undefined_named_parameter';
				expect(errors.map((error) => error.diagnosticCode.lowerCaseUniqueName), [code], reason: result.diagnostics.join('\n'));
				expect(result.lineInfo.getLocation(errors.single.offset).lineNumber, 8);
			});
		}
	});
}