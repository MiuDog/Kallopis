import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';

import 'support/klp_runtime_fixture.dart';

const _featurePath = 'lib/src/features/catalog/component-ownership.json';
const _applicationPath = 'lib/src/application/bootstrap/internal/klp_application_catalog.json';
const _assemblyPath = 'lib/src/application/bootstrap/internal/klp_application_adapters.dart';
final _units = <String, CompilationUnit>{};

void main() {
	_testClosureCatalog();
	test('catalog factories are deterministic complete unique and source owned', () {
		final first = klpApplicationAdapters();
		final second = klpApplicationAdapters();
		expect(first.map((adapter) => adapter.contract.id), second.map((adapter) => adapter.contract.id));
		expect(first.map((adapter) => adapter.runtimeType), second.map((adapter) => adapter.runtimeType));
		_validate(_read(_featurePath), _read(_applicationPath), first);
	});

	for (final mutation in ['duplicate', 'missing', 'extra', 'owner']) {
		test('manifest copy rejects $mutation identity metadata', () {
			final features = _read(_featurePath);
			final application = _read(_applicationPath);
			final components = features['components'] as List<dynamic>;
			final copy = Map<String, dynamic>.from(components.first as Map);
			switch (mutation) {
				case 'duplicate':
					components.add(copy);
				case 'missing':
					components.removeAt(0);
				case 'extra':
					copy['definition_id'] = 'unregistered.extra';
					components.add(copy);
				case 'owner':
					(components.first as Map)['owner_module'] = 'runtime';
			}
			final expected = switch (mutation) {
				'duplicate' => 'duplicate identity:',
				'missing' || 'extra' => 'catalog identity mismatch',
				_ => 'incorrect owner:',
			};
			expect(() => _validate(features, application, klpApplicationAdapters()), throwsA(isA<StateError>().having((error) => error.message, 'specific failure', startsWith(expected))));
		});
	}

	test('real catalog commits built-in tree and rejects unknown nodes before resources', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final adapters = klpApplicationAdapters();
		final root = KlpScreen(
			id: KlpId.parse('screen'),
			accessibilityLabel: 'Screen',
			child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: KlpFrameGroups(id: KlpId.parse('groups'), groups: [KlpFrameGroup(id: KlpId.parse('group'), content: [KlpWorkspaceBlock(id: KlpId.parse('paper'), kind: KlpWorkspaceBlockKind.paper, title: 'Content')])]))),
		);
		runtime.update(root: root, adapters: adapters, primitives: KlpWorkspacePreset.light());
		final oldFrame = runtime.frame!;
		final oldResources = Map.of(runtime.resources);
		expect(oldResources, isNotEmpty);
		final probe = KlpRuntimeFixture();
		final invalid = KlpRuntimeNode('probe', [_UnknownNode()]);
		expect(() => runtime.update(root: invalid, adapters: [...adapters, probe], primitives: KlpWorkspacePreset.dark()), throwsA(isA<KlpContractError>().having((error) => error.code, 'unknown definition', 'unknown_definition')));
		expect(probe.events, isEmpty);
		expect(runtime.frame, same(oldFrame));
		expect(runtime.resources.keys, oldResources.keys);
		for (final entry in oldResources.entries) {
			expect(runtime.resources[entry.key], same(entry.value));
		}
		var calls = 0;
		oldFrame.lease.run(() => calls++);
		expect(calls, 1);
	});
}

void _testClosureCatalog() {
	test('anchored popup has exactly the accepted export ownership slot and assembly delta', () {
		validatePopupCatalogDelta(_read(_featurePath), _read(_applicationPath));
	});

	test('accepted catalog retains 26 features 30 identities and exactly 88 feature exports', () {
		final features = _read(_featurePath);
		final application = _read(_applicationPath);
		final components = _rows(features['components']);
		expect(components, hasLength(26));
		expect(components.where((row) => row['visibility'] == 'public'), hasLength(24));
		expect(components.where((row) => row['visibility'] == 'internal').map((row) => row['declaration_symbol']), unorderedEquals(['KlpRail', 'KlpExplorerEntryNode']));
		expect([...components, ..._rows(application['structural_components'])], hasLength(30));
		expect(klpApplicationAdapters(), hasLength(30));
		expect(_rows(features['exports']), hasLength(88));
		expect(_rows(features['exports']).map((row) => row['symbol']), isNot(contains('KlpLocalFilePicker')));
		expect(_rows(features['exports']).map((row) => row['symbol']), isNot(contains('KlpPickFileAction')));
		final current = _librarySymbols('lib/kallopis_declarative.dart');
		for (final symbol in ['KlpAnchoredPopup', 'KlpAnchoredPopupItem', 'KlpAnchoredPopupState', 'KlpAnchoredPopupChangeReason']) {
			expect(current[symbol], 'lib/src/features/workspace/components/klp_anchored_popup.dart', reason: symbol);
		}
		expect(current['KlpPickFileAction'], 'lib/src/capabilities/actions/klp_pick_file_action.dart');
		expect(current, isNot(contains('KlpLocalFilePicker')));

		// 補回既存工具列對齊資料的清冊證據，並維持 enum 屬於 data 的分類契約。
		const toolbarPath = 'lib/src/features/workspace/components/klp_workspace_block.dart';
		expect(current['KlpWorkspaceToolbarAlignment'], toolbarPath);
		expect(_declaration(toolbarPath, 'KlpWorkspaceToolbarAlignment'), isA<EnumDeclaration>());
		final alignment = _rows(features['exports']).singleWhere((row) => row['symbol'] == 'KlpWorkspaceToolbarAlignment');
		expect(alignment['source_path'], toolbarPath);
		expect(alignment['kind'], 'data');
		expect(alignment['definition_ids'], isEmpty);
	});

	test('CM-01 owns exactly one public menu identity and its closed item data', () {
		final features = _read(_featurePath);
		final components = _rows(features['components']);
		final exports = _rows(features['exports']);
		final publicSymbols = _librarySymbols('lib/kallopis_declarative.dart');
		const menuPath = 'lib/src/features/overlays/declarative/klp_menu.dart';
		const itemPath = 'lib/src/features/overlays/declarative/klp_menu_item.dart';

		// 精確交叉核對符號、正式來源及 runtime 身分，新增數量不能由別的宣告補足。
		expect(publicSymbols['KlpMenu'], menuPath);
		expect(publicSymbols['KlpMenuItem'], itemPath);
		expect((_declaration(menuPath, 'KlpMenu') as ClassDeclaration).finalKeyword, isNotNull);
		expect((_declaration(itemPath, 'KlpMenuItem') as ClassDeclaration).finalKeyword, isNotNull);
		expect(KlpMenu.typeId, 'kallopis.menu');
		final menu = components.singleWhere((row) => row['declaration_symbol'] == 'KlpMenu');
		expect(menu['definition_id'], 'kallopis.menu');
		expect(menu['declaration_path'], menuPath);
		expect(menu['owner_module'], 'features');
		expect(menu['visibility'], 'public');
		expect(components.where((row) => row['declaration_symbol'] == 'KlpMenuItem'), isEmpty);
		final adapter = klpApplicationAdapters().singleWhere((adapter) => adapter.contract.id == 'kallopis.menu');
		expect(adapter.contract.runtimeType.toString(), 'KlpDefinition<KlpMenu>');
		expect(adapter.contract.slots, isEmpty);

		// 純資料項目沒有獨立節點 identity；兩個公開 export 都必須來自新版路徑。
		final menuExport = exports.singleWhere((row) => row['symbol'] == 'KlpMenu');
		expect(menuExport['source_path'], menuPath);
		expect(menuExport['kind'], 'node');
		expect(menuExport['definition_ids'], ['kallopis.menu']);
		final itemExport = exports.singleWhere((row) => row['symbol'] == 'KlpMenuItem');
		expect(itemExport['source_path'], itemPath);
		expect(itemExport['kind'], 'data');
		expect(itemExport['definition_ids'], isEmpty);
	});

	test('every public catalog component class closes external subtyping', () {
		final components = [..._rows(_read(_featurePath)['components']), ..._rows(_read(_applicationPath)['structural_components'])];
		final publicSymbols = _librarySymbols('lib/kallopis_declarative.dart');
		final open = <String>[];
		for (final row in components) {
			final symbol = _string(row, 'declaration_symbol');
			final path = _string(row, 'declaration_path');
			if (publicSymbols[symbol] != path) continue;

			final declaration = _declaration(path, symbol) as ClassDeclaration;
			if (declaration.finalKeyword == null) open.add(symbol);
		}
		expect(open, isEmpty, reason: 'Public component identities must be library-owned: $open');
	});

	test('compatibility preserves WindowControls P9 gate while retired Explorer is absent', () {
		final features = _read(_featurePath);
		final components = _rows(features['components']);
		_validateCompatibility(features, components);
		const gate = 'P9：下游使用端完成遷移，沒有受支援的使用端匯入退役入口，且相容性證據與發布說明允許破壞性移除。';
		const legacyPaths = {
			'KlpExplorer': 'lib/src/features/navigation/widgets/explorer/klp_explorer.dart',
			'KlpWindowControls': 'lib/src/features/workspace/shell/window/klp_window_controls.dart',
		};
		final stable = _librarySymbols('lib/kallopis_foundation.dart');
		expect(stable, isNot(contains('KlpExplorer')));
		expect(File('lib/src/features/navigation/widgets/explorer/klp_explorer.dart').existsSync(), isFalse);
		for (final row in _rows(features['compatibility'])) {
			final symbol = _string(row, 'legacy_symbol');
			expect(row['removal_gate'], gate, reason: symbol);
			expect(row['legacy_path'], legacyPaths[symbol], reason: symbol);
			expect(stable[symbol], legacyPaths[symbol], reason: 'Stable still exports $symbol');
			expect(row['canonical_path'], 'lib/src/features/workspace/components/klp_window_controls.dart');
		}
	});

	test('real catalog rejects qualified known identity impostors and retains committed resources', () {
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final adapters = klpApplicationAdapters();
		final root = KlpScreen(
			id: KlpId.parse('screen'),
			accessibilityLabel: 'Screen',
			child: KlpAppLayout(id: KlpId.parse('layout'), child: KlpAppFrame(id: KlpId.parse('frame'), child: KlpFrameGroups(id: KlpId.parse('groups'), groups: [KlpFrameGroup(id: KlpId.parse('group'), content: [KlpWorkspaceBlock(id: KlpId.parse('paper'), kind: KlpWorkspaceBlockKind.paper, title: 'Content')])]))),
		);
		runtime.update(root: root, adapters: adapters, primitives: KlpWorkspacePreset.light());
		final frame = runtime.frame!;
		final resources = Map.of(runtime.resources);
		expect(resources, isNotEmpty);
		final probe = KlpRuntimeFixture();
		final ids = [KlpAppLayout.typeId, LayoutRow.typeId, LayoutColumn.typeId, LayoutResizeHandle.typeId, LayoutSpacer.typeId, KlpLayoutPane.typeId, KlpAppFrame.typeId];
		for (final id in ids) {
			final impostor = _QualifiedLayoutImpostor(id);
			expect(impostor, isA<KlpLayoutNode>());
			final invalid = KlpRuntimeNode('probe', [impostor]);
			expect(() => runtime.update(root: invalid, adapters: [...adapters, probe], primitives: KlpWorkspacePreset.dark()), throwsA(isA<KlpContractError>().having((error) => error.code, 'known identity $id rejects its runtime type', 'node_type_mismatch')));
			expect(probe.events, isEmpty);
			expect(runtime.frame, same(frame));
			expect(runtime.resources.keys, resources.keys);
			for (final entry in resources.entries) {
				expect(runtime.resources[entry.key], same(entry.value));
			}
			var calls = 0;
			frame.lease.run(() => calls++);
			expect(calls, 1);
		}
	});
}

void validatePopupCatalogDelta(Map<String, dynamic> features, Map<String, dynamic> application) {
	const path = 'lib/src/features/workspace/components/klp_anchored_popup.dart';
	const adapterPath = 'lib/src/features/workspace/components/adapters/klp_anchored_popup_adapter.dart';
	const id = 'kallopis.anchored_popup';
	const symbols = ['KlpAnchoredPopup', 'KlpAnchoredPopupChangeReason', 'KlpAnchoredPopupItem', 'KlpAnchoredPopupState'];
	final exports = _rows(features['exports']);
	final popupExports = exports.where((row) => symbols.contains(row['symbol'])).toList();
	expect(popupExports, [
		for (final symbol in symbols) {'symbol': symbol, 'source_path': path, 'kind': symbol == 'KlpAnchoredPopup' ? 'node' : 'data', 'definition_ids': symbol == 'KlpAnchoredPopup' ? [id] : <String>[]},
	]);
	expect(exports.indexOf(popupExports.first), exports.indexWhere((row) => row['symbol'] == 'KlpAnchoredCommands') + 1);
	expect(exports.sublist(exports.indexOf(popupExports.first), exports.indexOf(popupExports.first) + 4), popupExports);
	final components = _rows(features['components']);
	final popupComponents = components.where((row) => row['definition_id'] == id).toList();
	expect(popupComponents, [
		{
			'definition_id': id,
			'declaration_symbol': 'KlpAnchoredPopup',
			'declaration_path': path,
			'owner_module': 'features',
			'level': 'L5',
			'visibility': 'public',
			'semantic_owner': id,
			'qualifications': ['KlpCompositeNode'],
			'slots': [{'name': 'trigger', 'owner': id, 'child_type': 'KlpWorkspaceBlock', 'min': 1, 'max': 1}],
			'adapter': {'symbol': 'KlpAnchoredPopupAdapter', 'source_path': adapterPath, 'factory': 'KlpAnchoredPopupAdapter()', 'variant': null},
		},
	]);
	expect(components.indexOf(popupComponents.single), components.indexWhere((row) => row['definition_id'] == 'kallopis.anchored-commands') + 1);
	final assembly = _rows(application['assembly']);
	final popupAssembly = assembly.where((row) => row['adapter_symbol'] == 'KlpAnchoredPopupAdapter').toList();
	expect(popupAssembly, [{'adapter_symbol': 'KlpAnchoredPopupAdapter', 'adapter_path': adapterPath, 'factory': 'KlpAnchoredPopupAdapter()', 'definition_ids': [id]}]);
	expect(assembly.indexOf(popupAssembly.single), assembly.indexWhere((row) => row['adapter_symbol'] == 'KlpWorkspaceBlockAdapter') + 1);
}

final class _QualifiedLayoutImpostor implements KlpLayoutNode {

	@override
	final String definitionId;

	_QualifiedLayoutImpostor(this.definitionId);

	@override
	KlpId get id => KlpId.parse('impostor');
	@override
	KlpChildren get children => KlpChildren(const []);
}

void _validate(Map<String, dynamic> features, Map<String, dynamic> application, List<KlpNodeAdapter> adapters) {
	// 步驟 1：先檢查陣列重複，避免轉成集合後遮蔽缺漏。
	_fields(features, ['schema_version', 'exports', 'components', 'compatibility']);
	_fields(application, ['schema_version', 'feature_manifest', 'structural_components', 'assembly']);
	_check(features['schema_version'] == 1 && application['schema_version'] == 1, 'schema_version');
	_check(application['feature_manifest'] == _featurePath, 'feature_manifest');
	final featureRows = _rows(features['components']);
	final structuralRows = _rows(application['structural_components']);
	final rows = [...featureRows, ...structuralRows];
	final ids = rows.map((row) => _string(row, 'definition_id')).toList();
	_unique(ids, 'identity');
	final actualIds = adapters.map((adapter) => adapter.contract.id).toList();
	_unique(actualIds, 'actual identity');
	_check(_sameSet(ids, actualIds), 'catalog identity mismatch: recorded=$ids actual=$actualIds');
	final actual = {for (final adapter in adapters) adapter.contract.id: adapter};

	// 步驟 2：以實際 contract 與宣告 AST 交叉檢查每個身分的來源和插槽。
	final publicSymbols = _librarySymbols('lib/kallopis_declarative.dart');
	for (final row in rows) {
		_fields(row, ['definition_id', 'declaration_symbol', 'declaration_path', 'owner_module', 'level', 'visibility', 'semantic_owner', 'qualifications', 'slots', 'adapter']);
		final id = _string(row, 'definition_id');
		final path = _string(row, 'declaration_path');
		final symbol = _string(row, 'declaration_symbol');
		final owner = path.split('/')[2];
		final levels = {'composition': 'L2', 'runtime': 'L4', 'features': 'L5', 'application': 'L7'};
		_check(row['owner_module'] == owner && row['level'] == levels[owner], 'incorrect owner: $id');
		_check(!featureRows.contains(row) || owner == 'features', 'incorrect owner: $id');
		final declaration = _declaration(path, symbol) as ClassDeclaration;
		final contract = actual[id]!.contract;
		_check(contract.runtimeType.toString() == 'KlpDefinition<$symbol>', 'declaration type: $id');
		final typeId = (declaration.body as BlockClassBody).members.whereType<FieldDeclaration>().expand((field) => field.fields.variables).singleWhere((field) => field.name.lexeme == 'typeId');
		_check((typeId.initializer as StringLiteral).stringValue == id, 'declaration identity: $id');
		_check(row['semantic_owner'] is String && row['semantic_owner'] == contract.semantics.owner, 'semantic owner: $id');
		final qualifications = _strings(row['qualifications']);
		_unique(qualifications, 'qualification');
		_check(_sameSet(qualifications, declaration.implementsClause?.interfaces.map((type) => type.toSource()) ?? []), 'qualifications: $id');
		final slots = _rows(row['slots']);
		_unique(slots.map((slot) => _string(slot, 'name')).toList(), 'slot');
		_check(slots.length == contract.slots.length, 'slot count: $id');
		for (var index = 0; index < slots.length; index++) {
			final slot = slots[index];
			_fields(slot, ['name', 'owner', 'child_type', 'min', 'max']);
			final observed = contract.slots[index];
			_check(slot['name'] is String && slot['name'] == observed.name && slot['owner'] is String && slot['owner'] == observed.owner, 'slot identity: $id');
			_check(slot['min'] is int && slot['min'] == observed.min && (slot['max'] == null || slot['max'] is int) && slot['max'] == observed.max, 'slot cardinality: $id');
			_check(slot['child_type'] is String && observed.runtimeType.toString() == 'KlpSlot<${slot['child_type']}>', 'slot child type: $id');
		}
		final adapter = row['adapter'] as Map<String, dynamic>;
		_fields(adapter, ['symbol', 'source_path', 'factory', 'variant']);
		final adapterSymbol = _string(adapter, 'symbol');
		_declaration(_string(adapter, 'source_path'), adapterSymbol);
		_check(actual[id]!.runtimeType.toString() == adapterSymbol, 'adapter type: $id');
		final factory = _string(adapter, 'factory');
		_check(factory == '$adapterSymbol()' || factory == '$adapterSymbol.createAll()', 'adapter factory: $id');
		_check(adapter['variant'] == (factory.endsWith('.createAll()') ? id : null), 'adapter variant: $id');
		_check(row['visibility'] == (publicSymbols[symbol] == path ? 'public' : 'internal'), 'visibility: $id');
	}

	// 步驟 3：組裝 AST 的順序及 factory 對應，必須等於實際展開結果。
	final assembly = _rows(application['assembly']);
	final sourceAssembly = _assembly();
	_check(assembly.length == sourceAssembly.length, 'assembly length');
	final expanded = <String>[];
	for (var index = 0; index < assembly.length; index++) {
		final item = assembly[index];
		_fields(item, ['adapter_symbol', 'adapter_path', 'factory', 'definition_ids']);
		final symbol = _string(item, 'adapter_symbol');
		final path = _string(item, 'adapter_path');
		final factory = _string(item, 'factory');
		_check(factory == sourceAssembly[index].$1 && path == sourceAssembly[index].$2, 'assembly source: $index');
		final configured = rows.where((row) {
			final adapter = row['adapter'] as Map;
			return adapter['symbol'] == symbol && adapter['source_path'] == path && adapter['factory'] == factory;
		}).map((row) => row['definition_id'] as String).toList();
		final listed = _strings(item['definition_ids']);
		_unique(listed, 'assembly identity');
		_check(_sameSet(listed, configured), 'assembly configuration: $symbol');
		expanded.addAll(listed);
	}
	_unique(expanded, 'assembled identity');
	_check(_sameList(expanded, actualIds), 'assembly order');
	_validateExports(features, featureRows);
	_validateCompatibility(features, featureRows);
}

void _validateExports(Map<String, dynamic> features, List<Map<String, dynamic>> components) {
	final exports = _rows(features['exports']);
	_unique(exports.map((row) => _string(row, 'symbol')).toList(), 'export');
	final observed = <String, String>{};
	for (final directive in _unit('lib/kallopis_declarative.dart').directives.whereType<ExportDirective>()) {
		final uri = directive.uri.stringValue!;
		if (uri.startsWith('src/features/') || uri.startsWith('package:krepis_')) {
			observed.addAll(_exported('lib/kallopis_declarative.dart', directive));
		}
	}
	_check(_sameSet(exports.map((row) => row['symbol'] as String), observed.keys), 'public export completeness: recorded=${exports.map((row) => row['symbol']).toList()} actual=${observed.keys.toList()}');
	for (final row in exports) {
		_fields(row, ['symbol', 'source_path', 'kind', 'definition_ids']);
		final symbol = _string(row, 'symbol');
		final path = _string(row, 'source_path');
		_check(observed[symbol] == path, 'public export source: $symbol');
		final ids = _strings(row['definition_ids']);
		_unique(ids, 'export identity');
		final kind = _string(row, 'kind');
		_check(['node', 'qualification', 'data', 'event', 'utility', 'reexport'].contains(kind), 'export kind: $symbol');
		if (path.startsWith('package:')) {
			_check(kind == 'reexport' && ids.isEmpty, 'reexport identity: $symbol');
			continue;
		}
		var declaration = _declaration(path, symbol);
		var canonical = symbol;
		if (declaration is GenericTypeAlias && declaration.type is NamedType) {
			canonical = declaration.type.toSource();
			declaration = _declaration(path, canonical);
		}
		final owned = components.where((component) => component['declaration_symbol'] == canonical).toList();
		_check(_sameSet(ids, owned.map((component) => component['definition_id'] as String)), 'export identities: $symbol');
		if (owned.isNotEmpty) {
			_check(kind == 'node', 'node classification: $symbol');
		}
		else if (declaration is ClassDeclaration && declaration.interfaceKeyword != null && _isNodeType(canonical, _librarySymbols('lib/kallopis_declarative.dart'), {})) {
			_check(kind == 'qualification', 'qualification classification: $symbol');
		}
		else if (declaration is GenericTypeAlias && declaration.type is GenericFunctionType) {
			_check(kind == 'event', 'event classification: $symbol');
		}
		else {
			_check(kind == 'data', 'value classification: $symbol');
		}
	}
	for (final component in components) {
		final symbol = component['declaration_symbol'] as String;
		_check(component['visibility'] == (observed.containsKey(symbol) ? 'public' : 'internal'), 'export visibility: $symbol');
	}
}

bool _isNodeType(String symbol, Map<String, String> sources, Set<String> seen) {
	if (symbol == 'KlpNode') return true;
	if (!seen.add(symbol) || !sources.containsKey(symbol)) return false;

	// 依公開繼承關係判定結構資格，純資料 interface 不取得插槽資格。
	final declaration = _declaration(sources[symbol]!, symbol);
	if (declaration is! ClassDeclaration) return false;

	final parents = [
		if (declaration.extendsClause != null) declaration.extendsClause!.superclass,
		...?declaration.implementsClause?.interfaces,
	];
	return parents.any((parent) => _isNodeType(parent.name.lexeme, sources, seen));
}
void _validateCompatibility(Map<String, dynamic> features, List<Map<String, dynamic>> components) {
	final rows = _rows(features['compatibility']);
	_unique(rows.map((row) => _string(row, 'legacy_symbol')).toList(), 'legacy symbol');
	_check(_sameSet(rows.map((row) => row['legacy_symbol'] as String), ['KlpWindowControls']), 'compatibility completeness');
	for (final row in rows) {
		_fields(row, ['legacy_symbol', 'legacy_path', 'canonical_symbol', 'canonical_path', 'removal_owner', 'removal_gate']);
		final symbol = _string(row, 'legacy_symbol');
		final legacy = _string(row, 'legacy_path');
		final canonical = _string(row, 'canonical_path');
		_declaration(legacy, symbol);
		_declaration(canonical, _string(row, 'canonical_symbol'));
		_check(legacy != canonical && row['canonical_symbol'] == symbol, 'compatibility collision: $symbol');
		_check(row['removal_owner'] == 'features' && _string(row, 'removal_gate').contains('P9'), 'compatibility removal: $symbol');
		_check(components.any((component) => component['declaration_symbol'] == symbol && component['declaration_path'] == canonical), 'compatibility canonical: $symbol');
		_check(components.every((component) => component['declaration_path'] != legacy), 'legacy in active catalog: $symbol');
	}
}

List<(String, String)> _assembly() {
	final unit = _unit(_assemblyPath);
	final imports = <String, String>{};
	for (final directive in unit.directives.whereType<ImportDirective>()) {
		final path = _path(_assemblyPath, directive.uri.stringValue!);
		for (final declaration in _unit(path).declarations) {
			imports[_symbol(declaration)] = path;
		}
	}
	final function = unit.declarations.whereType<FunctionDeclaration>().singleWhere((declaration) => declaration.name.lexeme == 'klpApplicationAdapters');
	final body = function.functionExpression.body as BlockFunctionBody;
	final returned = body.block.statements.whereType<ReturnStatement>().single.expression as ListLiteral;
	return [for (final element in returned.elements) _factory(element is SpreadElement ? element.expression : element as Expression, imports)];
}

(String, String) _factory(Expression expression, Map<String, String> imports) {
	final factory = expression.toSource().replaceAll('const ', '').replaceAll(' ', '');
	final symbol = factory.split(RegExp(r'[.(]')).first;
	return (factory, imports[symbol]!);
}

Map<String, String> _exported(String owner, ExportDirective directive) {
	final path = _path(owner, directive.uri.stringValue!);
	final shown = directive.combinators.whereType<ShowCombinator>().expand((show) => show.shownNames.map((name) => name.name)).toSet();
	final hidden = directive.combinators.whereType<HideCombinator>().expand((hide) => hide.hiddenNames.map((name) => name.name)).toSet();
	final symbols = path.startsWith('package:') ? {for (final symbol in shown) symbol: path} : _librarySymbols(path);
	return {for (final entry in symbols.entries) if (!entry.key.startsWith('_') && !hidden.contains(entry.key) && (shown.isEmpty || shown.contains(entry.key))) entry.key: entry.value};
}

Map<String, String> _librarySymbols(String path) {
	final unit = _unit(path);
	final result = {for (final declaration in unit.declarations) _symbol(declaration): path};
	for (final directive in unit.directives) {
		if (directive is PartDirective) result.addAll(_librarySymbols(_path(path, directive.uri.stringValue!)));
		if (directive is ExportDirective) result.addAll(_exported(path, directive));
	}
	return result;
}

String _symbol(CompilationUnitMember declaration) => switch (declaration) {
	ClassDeclaration() => declaration.namePart.typeName.lexeme,
	EnumDeclaration() => declaration.namePart.typeName.lexeme,
	ExtensionTypeDeclaration() => declaration.primaryConstructor.typeName.lexeme,
	TypeAlias() => declaration.name.lexeme,
	FunctionDeclaration() => declaration.name.lexeme,
	MixinDeclaration() => declaration.name.lexeme,
	ExtensionDeclaration() => declaration.name?.lexeme ?? '_unnamedExtension',
	TopLevelVariableDeclaration() => declaration.variables.variables.single.name.lexeme,
	_ => throw StateError('Unsupported declaration: ${declaration.runtimeType}'),
};

CompilationUnitMember _declaration(String path, String symbol) => _unit(path).declarations.singleWhere((declaration) => _symbol(declaration) == symbol, orElse: () => throw StateError('Missing declaration: $path::$symbol'));

CompilationUnit _unit(String path) {
	_check(path.startsWith('lib/') && !path.contains('..'), 'source path: $path');
	// 從正式來源解析 AST，清冊不作為編譯或登錄權威。
	return _units.putIfAbsent(path, () => parseString(content: File(path).readAsStringSync(), throwIfDiagnostics: true).unit);
}

String _path(String owner, String uri) {
	if (uri.startsWith('package:kallopis/')) return uri.replaceFirst('package:kallopis/', 'lib/');
	if (uri.startsWith('package:')) return uri;

	return Uri.parse(owner).resolve(uri).path;
}

Map<String, dynamic> _read(String path) {
	// 負向測試每次重新讀取獨立副本，不寫入產品清冊。
	return jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
}

List<Map<String, dynamic>> _rows(Object? value) => (value as List<dynamic>).cast<Map<String, dynamic>>();
List<String> _strings(Object? value) => (value as List<dynamic>).cast<String>();
String _string(Map<String, dynamic> row, String name) {
	final value = row[name];
	_check(value is String && value.isNotEmpty, 'string field: $name');
	return value as String;
}

void _unique(Iterable<String> values, String label) {
	final seen = <String>{};
	for (final value in values) {
		_check(seen.add(value), 'duplicate $label: $value');
	}
}

bool _sameSet(Iterable<String> left, Iterable<String> right) => left.toSet().length == right.toSet().length && left.toSet().containsAll(right);
bool _sameList(List<String> left, List<String> right) => left.length == right.length && List.generate(left.length, (index) => left[index] == right[index]).every((value) => value);
void _check(bool condition, String message) {
	if (!condition) throw StateError(message);
}

final class _UnknownNode implements KlpNode {

	@override
	KlpId get id => KlpId.parse('unknown');
	@override
	String get definitionId => 'consumer.unknown';
	@override
	Iterable<KlpNode> get children => const [];
}

void _fields(Map<String, dynamic> row, List<String> names) {
	_check(names.every(row.containsKey), 'required fields: $names');
}
