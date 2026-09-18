import 'package:analyzer/error/error.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/klp_external_compile_fixture.dart';

const _prelude = '''import 'package:kallopis/kallopis_declarative.dart';

final destination = KlpDestination<int, void>(KlpId.parse('home'));
final screen = KlpScreen(
	id: KlpId.parse('screen'),
	accessibilityLabel: 'Home',
	child: KlpAppLayout(
		id: KlpId.parse('layout'),
		child: KlpAppFrame(
			id: KlpId.parse('frame'),
			child: KlpFrameGroups(id: KlpId.parse('groups'), groups: const []),
		),
	),
);
final router = KlpRouter(
	id: KlpId.parse('router'),
	initial: destination.location(0),
	routes: [KlpRoute(destination, screen: (_) => screen)],
);
final application = KlpApplication(title: 'App', router: router);

final explorerTreeId = KlpId.parse('explorer.tree');
final explorerItemId = KlpId.parse('explorer.item');
final explorerItem = KlpExplorerNodeModel(
	id: explorerItemId,
	row: KlpExplorerRowData(title: 'Item'),
	canHaveChildren: false,
	capabilities: const KlpExplorerCapabilities(selectable: true),
);
final explorerData = KlpExplorerData(
	trees: [KlpExplorerTreeData(id: explorerTreeId, items: [explorerItem])],
	selectionScopes: [
		KlpExplorerSelectionScope(
			id: KlpId.parse('explorer.scope'),
			treeIds: [explorerTreeId],
			mode: KlpExplorerSelectionMode.single,
		),
	],
);
final explorerController = KlpExplorerController();
final explorer = KlpExplorer(
	id: KlpId.parse('explorer'),
	data: explorerData,
	controller: explorerController,
	onIntent: (KlpExplorerIntent intent) {},
);

final tabId = KlpId.parse('tab');
final tabsData = KlpDocumentTabsData(
	tabs: [
		KlpDocumentTabData(
			id: tabId,
			label: 'Document',
			closable: true,
			pinnable: true,
		),
	],
	selectedId: tabId,
);
final tabs = KlpDocumentTabs(
	id: KlpId.parse('tabs'),
	data: tabsData,
	onIntent: (KlpDocumentTabsIntent intent) {},
);
''';

void main() {
	group('semantic feature consumer contract', () {
		late KlpExternalCompileFixture fixture;
		final cases = <String, ({String source, String? code})>{
			'positive': (source: _prelude, code: null),
			'no application primitives': (
				source: '$_prelude\nfinal invalid = KlpApplication(title: \'App\', router: router, primitives: Object());\n',
				code: 'undefined_named_parameter',
			),
			'no Explorer legacy selection callback': (
				source: '$_prelude\nfinal invalid = KlpExplorer(id: KlpId.parse(\'legacy.explorer\'), data: explorerData, onSelectionChanged: (_) {});\n',
				code: 'undefined_named_parameter',
			),
			'no Explorer consumer drop query': (
				source: '$_prelude\nfinal invalid = KlpExplorer(id: KlpId.parse(\'legacy.drop\'), data: explorerData, canDrop: (_) => true);\n',
				code: 'undefined_named_parameter',
			),
			'no Document Tabs legacy callback': (
				source: '$_prelude\nfinal invalid = KlpDocumentTabs(id: KlpId.parse(\'legacy.tabs\'), data: tabsData, onSelected: (_) {});\n',
				code: 'undefined_named_parameter',
			),
			for (final type in [
				'KlpPrimitiveIndex',
				'KlpPrimitiveSet',
				'KlpStyleKind',
				'KlpStyleValue',
				'KlpWorkspacePreset',
				'KlpCallbackAction',
				'KlpDocumentTab',
			])
				'no $type': (
					source: '$_prelude\n$type? forbidden;\n',
					code: 'undefined_class',
				),
		};

		setUpAll(() async {
			fixture = await KlpExternalCompileFixture.create({
				for (final entry in cases.entries) entry.key: entry.value.source,
			});
			addTearDown(fixture.dispose);
		});

		for (final entry in cases.entries) {
			test(entry.key, () async {
				final result = await fixture.resolve(entry.key);
				final errors = result.diagnostics
						.where(
							(diagnostic) =>
								diagnostic.diagnosticCode.severity ==
								DiagnosticSeverity.ERROR,
						)
						.toList();
				final code = entry.value.code;
				if (code == null) {
					expect(errors, isEmpty, reason: result.diagnostics.join('\n'));
					return;
				}

				final targetLine = '\n'.allMatches(_prelude).length + 2;
				expect(
					errors.where(
						(error) =>
							error.diagnosticCode.lowerCaseUniqueName == code &&
							result.lineInfo.getLocation(error.offset).lineNumber ==
								targetLine,
					),
					isNotEmpty,
					reason:
						'${entry.key}: $code at line $targetLine\n${result.diagnostics.join('\n')}',
				);
			});
		}
	});
}
