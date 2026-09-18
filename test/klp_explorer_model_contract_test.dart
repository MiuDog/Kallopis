import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_command.dart';
import 'package:kallopis/src/features/workspace/explorer/klp_explorer_model.dart';
import 'package:kallopis/src/features/workspace/explorer/klp_explorer_snapshot.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

const _selectable = KlpExplorerCapabilities(selectable: true);
const _draggable = KlpExplorerCapabilities(draggable: true);
const _branch = KlpExplorerCapabilities(selectable: true, collapsible: true);

KlpId _id(String name) => KlpId.root('explorer-contract').child(name);

Matcher _failsWith(String code) => throwsA(isA<KlpContractError>().having((error) => error.code, 'code', code));

KlpExplorerNodeModel _node(String name, {List<KlpExplorerItemModel> children = const [], bool canHaveChildren = true, KlpExplorerCapabilities capabilities = _selectable}) {

	return KlpExplorerNodeModel(id: _id(name), row: KlpExplorerRowData(title: name), canHaveChildren: canHaveChildren, children: children, capabilities: capabilities);
}

KlpExplorerSnapshot _capture(List<KlpExplorerItemModel> items, {Set<KlpId> expanded = const {}, Set<KlpId> selected = const {}}) {

	final tree = KlpExplorerTreeData(id: _id('tree'), items: items, expandedIds: expanded);
	final scope = KlpExplorerSelectionScope(id: _id('scope'), treeIds: [_id('tree')], mode: KlpExplorerSelectionMode.multiple, selectedIds: selected);
	return KlpExplorerSnapshot.capture(trees: [tree], selectionScopes: [scope]);
}

void main() {

	test('external item getters are sampled once and the complete snapshot stays immutable', () {
		// 用可變 consumer 物件與集合驗證快照不保留輸入別名。
		final command = KlpWorkspaceCommand(label: '開啟', onInvoke: (_) {});
		final inlineActions = <KlpWorkspaceCommand>[command];
		final contextActions = <KlpWorkspaceCommand>[command];
		final children = <KlpExplorerItemModel>[_node('child', canHaveChildren: false)];
		final item = _ConsumerItem(_id('parent'), children);
		item.dataRow = KlpExplorerRowData(title: '原始標題', inlineActions: inlineActions, contextActions: contextActions);
		item.dataCapabilities = _branch;
		final roots = <KlpExplorerItemModel>[item];
		final expanded = <KlpId>{_id('parent')};
		final selected = <KlpId>{_id('child')};
		final members = <KlpId>[_id('tree')];
		final trees = <KlpExplorerTreeData>[KlpExplorerTreeData(id: _id('tree'), items: roots, expandedIds: expanded)];
		final scopes = <KlpExplorerSelectionScope>[KlpExplorerSelectionScope(id: _id('scope'), treeIds: members, mode: KlpExplorerSelectionMode.multiple, selectedIds: selected)];
		final snapshot = KlpExplorerSnapshot.capture(trees: trees, selectionScopes: scopes);
		expect(item.reads, {'id': 1, 'role': 1, 'canHaveChildren': 1, 'row': 1, 'capabilities': 1, 'children': 1});

		// 原輸入全部改變後，已確認快照的資料與可見順序仍保持一致。
		item.dataId = _id('replacement');
		item.dataRole = KlpExplorerRole.category;
		item.dataRow = KlpExplorerRowData(title: '替換標題');
		item.dataCapabilities = const KlpExplorerCapabilities();
		children.clear();
		inlineActions.clear();
		contextActions.clear();
		roots.clear();
		expanded.clear();
		selected.clear();
		members.clear();
		trees.clear();
		scopes.clear();
		final parent = snapshot.items[_id('parent')]!;
		final tree = snapshot.trees[_id('tree')]!;
		final scope = snapshot.selectionScopes[_id('scope')]!;
		expect(parent.id, _id('parent'));
		expect(parent.role, KlpExplorerRole.node);
		expect(parent.canHaveChildren, isTrue);
		expect(parent.hasChildren, isTrue);
		expect(parent.row.title, '原始標題');
		expect(parent.row.inlineActions, [command]);
		expect(parent.row.contextActions, [command]);
		expect(parent.capabilities.collapsible, isTrue);
		expect(parent.childIds, [_id('child')]);
		expect(parent.parentId, isNull);
		expect(parent.treeId, _id('tree'));
		expect(snapshot.items[_id('child')]!.parentId, _id('parent'));
		expect(tree.rootIds, [_id('parent')]);
		expect(tree.expandedIds, {_id('parent')});
		expect(tree.visibleIds, [_id('parent'), _id('child')]);
		expect(scope.treeIds, [_id('tree')]);
		expect(scope.selectedIds, {_id('child')});
		expect(snapshot.scopeByTree, {_id('tree'): _id('scope')});

		// 對外所有集合均不能被修改，避免 renderer 或 consumer 建立第二份狀態。
		final mutations = <void Function()>[
			() => snapshot.items.clear(),
			() => snapshot.trees.clear(),
			() => snapshot.selectionScopes.clear(),
			() => snapshot.scopeByTree.clear(),
			() => parent.childIds.clear(),
			() => parent.row.inlineActions.clear(),
			() => parent.row.contextActions.clear(),
			() => tree.rootIds.clear(),
			() => tree.expandedIds.clear(),
			() => tree.visibleIds.clear(),
			() => scope.treeIds.clear(),
			() => scope.selectedIds.clear(),
			() => snapshot.visibleIdsForScope(_id('scope')).clear(),
			() => snapshot.selectableIdsForScope(_id('scope')).clear(),
		];
		for (final mutate in mutations) {
			expect(mutate, throwsUnsupportedError);
		}
	});

	test('mixed consumer types distinguish an empty capable node from a leaf', () {
		final leaf = _ConsumerLeaf(_id('leaf'));
		final empty = _ConsumerItem(_id('empty'), []);
		final category = KlpExplorerCategoryModel(id: _id('category'), row: KlpExplorerRowData(title: '分類'), children: [leaf, empty], capabilities: _selectable);
		expect(leaf.hasChildren, isFalse);
		expect(empty.hasChildren, isFalse);
		final snapshot = _capture([category, _node('root-node')], selected: {_id('category')});
		expect(snapshot.items[_id('leaf')]!.canHaveChildren, isFalse);
		expect(snapshot.items[_id('empty')]!.canHaveChildren, isTrue);
		expect(snapshot.items[_id('empty')]!.hasChildren, isFalse);
		expect(snapshot.trees[_id('tree')]!.visibleIds, [_id('category'), _id('leaf'), _id('empty'), _id('root-node')]);
		expect(snapshot.selectionScopes[_id('scope')]!.selectedIds, {_id('category')});
	});

	test('illegal child roles, unsupported children and contradictory actions are rejected', () {
		KlpExplorerCategoryModel category() => KlpExplorerCategoryModel(id: _id('nested-category'), row: KlpExplorerRowData(title: '分類'));
		expect(() => _capture([_node('node', children: [category()])]), _failsWith('explorer_invalid_role'));
		expect(() => _capture([KlpExplorerCategoryModel(id: _id('outer'), row: KlpExplorerRowData(title: '分類'), children: [category()])]), _failsWith('explorer_invalid_role'));
		expect(() => _capture([_node('leaf', canHaveChildren: false, children: [_node('child')])]), _failsWith('explorer_children_not_allowed'));
		expect(() => _capture([_node('action', capabilities: const KlpExplorerCapabilities(primaryAction: KlpExplorerPrimaryAction.toggleExpansion))]), _failsWith('explorer_invalid_primary_action'));
		expect(() => _capture([KlpExplorerNodeModel(id: _id('blank'), row: KlpExplorerRowData(title: '  '), canHaveChildren: false)]), _failsWith('explorer_invalid_title'));
	});

	test('forest identity rejects repeated occurrences and cycles without deriving parents from IDs', () {
		expect(() => _capture([_node('same'), _node('same')]), _failsWith('explorer_duplicate_id'));
		expect(() => _capture([_node('tree')]), _failsWith('explorer_duplicate_id'));
		final direct = _ConsumerItem(_id('direct'), []);
		direct.dataChildren.add(direct);
		expect(() => _capture([direct]), _failsWith('explorer_cycle'));
		final first = _ConsumerItem(_id('first'), []);
		final second = _ConsumerItem(_id('second'), [first]);
		first.dataChildren.add(second);
		expect(() => _capture([first]), _failsWith('explorer_cycle'));

		// ID 名稱中的階層與資料樹無關；明確 children 才決定父子。
		final nominalParent = _id('nominal');
		final nominalChild = nominalParent.child('child');
		final a = KlpExplorerNodeModel(id: nominalParent, row: KlpExplorerRowData(title: 'A'), canHaveChildren: false);
		final b = KlpExplorerNodeModel(id: nominalChild, row: KlpExplorerRowData(title: 'B'), canHaveChildren: false);
		final snapshot = _capture([a, b]);
		expect(snapshot.items[nominalChild]!.parentId, isNull);
		expect(snapshot.trees[_id('tree')]!.rootIds, [nominalParent, nominalChild]);
	});

	test('deep valid trees retain preorder without a product depth limit', () {
		const depth = 12000;
		KlpExplorerItemModel current = _node('deep-${depth - 1}', canHaveChildren: false);
		for (var index = depth - 2; index >= 0; index--) {
			current = _node('deep-$index', children: [current]);
		}
		final snapshot = _capture([current]);
		final expected = List<KlpId>.generate(depth, (index) => _id('deep-$index'));
		expect(snapshot.items, hasLength(depth));
		expect(snapshot.visibleIdsForScope(_id('scope')), expected);
		expect(snapshot.items[_id('deep-${depth - 1}')]!.parentId, _id('deep-${depth - 2}'));
	});

	test('throwing external getters fail capture instead of returning partial data', () {
		final item = _ConsumerItem(_id('throwing'), []);
		item.throwOnRow = true;
		expect(() => _capture([_node('valid'), item]), throwsStateError);
	});

	test('full selection and expansion must match the supplied data', () {
		final items = <KlpExplorerItemModel>[
			_node('branch', capabilities: _branch, children: [_node('hidden')]),
			_node('fixed', children: [_node('fixed-child')]),
			_node('empty', capabilities: _branch),
			_node('disabled', capabilities: const KlpExplorerCapabilities()),
		];
		final valid = _capture(items, selected: {_id('hidden')});
		expect(valid.visibleIdsForScope(_id('scope')), [_id('branch'), _id('fixed'), _id('fixed-child'), _id('empty'), _id('disabled')]);
		expect(valid.selectionScopes[_id('scope')]!.selectedIds, {_id('hidden')});
		for (final selected in [{_id('missing')}, {_id('disabled')}]) {
			expect(() => _capture(items, selected: selected), _failsWith('explorer_invalid_selection'));
		}
		for (final expanded in [{_id('missing')}, {_id('fixed')}, {_id('empty')}]) {
			expect(() => _capture(items, expanded: expanded), _failsWith('explorer_invalid_expansion'));
		}
		expect(() => _capture([_node('replacement')], selected: {_id('hidden')}), _failsWith('explorer_invalid_selection'));
		expect(() => _capture([_node('branch', capabilities: _branch)], expanded: {_id('branch')}), _failsWith('explorer_invalid_expansion'));
	});

	test('shared scope order follows declared tree order while independent scopes retain their state', () {
		final a = KlpExplorerTreeData(id: _id('a'), items: [_node('a-root', children: [_node('a-child')]), _node('a-disabled', capabilities: const KlpExplorerCapabilities())], expandedIds: {});
		final b = KlpExplorerTreeData(id: _id('b'), items: [_node('b-root', capabilities: _branch, children: [_node('b-hidden')])], expandedIds: {});
		final c = KlpExplorerTreeData(id: _id('c'), items: [_node('c-root')], expandedIds: {});
		final shared = KlpExplorerSelectionScope(id: _id('shared'), treeIds: [_id('b'), _id('a')], mode: KlpExplorerSelectionMode.multiple, selectedIds: {_id('b-hidden'), _id('a-child')});
		final independent = KlpExplorerSelectionScope(id: _id('independent'), treeIds: [_id('c')], mode: KlpExplorerSelectionMode.single, selectedIds: {_id('c-root')});
		final snapshot = KlpExplorerSnapshot.capture(trees: [a, b, c], selectionScopes: [shared, independent]);
		expect(snapshot.visibleIdsForScope(_id('shared')), [_id('b-root'), _id('a-root'), _id('a-child'), _id('a-disabled')]);
		expect(snapshot.selectableIdsForScope(_id('shared')), [_id('b-root'), _id('a-root'), _id('a-child')]);
		expect(snapshot.visibleIdsForScope(_id('independent')), [_id('c-root')]);
		expect(snapshot.selectionScopes[_id('shared')]!.selectedIds, {_id('b-hidden'), _id('a-child')});
		expect(snapshot.selectionScopes[_id('independent')]!.selectedIds, {_id('c-root')});
		expect(() => snapshot.visibleIdsForScope(_id('missing')), _failsWith('explorer_invalid_scope'));
		expect(() => snapshot.selectableIdsForScope(_id('missing')), _failsWith('explorer_invalid_scope'));
	});

	test('scope membership and selection modes reject inconsistent complete inputs', () {
		final a = KlpExplorerTreeData(id: _id('a'), items: [_node('a1'), _node('a2')], expandedIds: {});
		final b = KlpExplorerTreeData(id: _id('b'), items: [_node('b1')], expandedIds: {});
		KlpExplorerSelectionScope scope(String name, List<KlpId> members) => KlpExplorerSelectionScope(id: _id(name), treeIds: members, mode: KlpExplorerSelectionMode.none, selectedIds: {});
		final invalidScopes = <List<KlpExplorerSelectionScope>>[
			[],
			[scope('empty', [])],
			[scope('unknown', [_id('a'), _id('b'), _id('missing')])],
			[scope('repeated', [_id('a'), _id('a'), _id('b')])],
			[scope('one', [_id('a'), _id('b')]), scope('two', [_id('a')])],
			[scope('duplicate', [_id('a')]), scope('duplicate', [_id('b')])],
		];
		for (final scopes in invalidScopes) {
			expect(() => KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: scopes), _failsWith('explorer_invalid_scope'));
		}
		for (final mode in [KlpExplorerSelectionMode.none, KlpExplorerSelectionMode.single]) {
			final invalid = KlpExplorerSelectionScope(id: _id('invalid'), treeIds: [_id('a')], mode: mode, selectedIds: {_id('a1'), _id('a2')});
			expect(() => KlpExplorerSnapshot.capture(trees: [a], selectionScopes: [invalid]), _failsWith('explorer_invalid_selection'));
		}
		final wrongScope = KlpExplorerSelectionScope(id: _id('one'), treeIds: [_id('a')], mode: KlpExplorerSelectionMode.multiple, selectedIds: {_id('b1')});
		expect(() => KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: [wrongScope, scope('two', [_id('b')])]), _failsWith('explorer_invalid_selection'));
		expect(KlpExplorerSnapshot.capture(trees: [], selectionScopes: []).items, isEmpty);
		expect(() => KlpExplorerSnapshot.capture(trees: [], selectionScopes: [scope('empty', [])]), _failsWith('explorer_invalid_scope'));
	});

	test('duplicate tree or cross-tree item identities are rejected but scope IDs are independent', () {
		final a = KlpExplorerTreeData(id: _id('a'), items: [_node('same')], expandedIds: {});
		final b = KlpExplorerTreeData(id: _id('b'), items: [_node('same')], expandedIds: {});
		final shared = KlpExplorerSelectionScope(id: _id('shared'), treeIds: [_id('a'), _id('b')], mode: KlpExplorerSelectionMode.none, selectedIds: {});
		expect(() => KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: [shared]), _failsWith('explorer_duplicate_id'));
		final sameDomain = KlpExplorerSelectionScope(id: _id('a'), treeIds: [_id('a')], mode: KlpExplorerSelectionMode.none, selectedIds: {});
		expect(() => KlpExplorerSnapshot.capture(trees: [a, a], selectionScopes: [sameDomain]), _failsWith('explorer_duplicate_id'));
		expect(KlpExplorerSnapshot.capture(trees: [a], selectionScopes: [sameDomain]).scopeByTree, {_id('a'): _id('a')});
	});

	test('drop permission is denied by default, rechecked each call and never changes the tree', () {
		final snapshot = _capture([_node('source', capabilities: _draggable), _node('target')]);
		final request = KlpExplorerDropRequest(sourceIds: {_id('source')}, targetId: _id('target'), position: KlpExplorerDropPlacement.inside);
		var allowed = true;
		var calls = 0;
		bool permission(KlpExplorerDropRequest current) {
			calls++;
			expect(current.sourceIds, {_id('source')});
			expect(current.targetId, _id('target'));
			expect(current.position, KlpExplorerDropPlacement.inside);
			return allowed;
		}
		expect(snapshot.permitsDrop(request), isFalse);
		expect(snapshot.permitsDrop(request, permission: permission), isTrue);
		allowed = false;
		expect(snapshot.permitsDrop(request, permission: permission), isFalse);
		allowed = true;
		expect(snapshot.permitsDrop(request, permission: permission), isTrue);
		expect(calls, 3);
		expect(snapshot.trees[_id('tree')]!.rootIds, [_id('source'), _id('target')]);
		expect(snapshot.items[_id('target')]!.childIds, isEmpty);
	});

	test('drop structural checks cannot be bypassed by consumer permission', () {
		final category = KlpExplorerCategoryModel(id: _id('category'), row: KlpExplorerRowData(title: '分類'), children: [_node('nested', capabilities: _draggable)], capabilities: _draggable);
		final snapshot = _capture([category, _node('parent', capabilities: _draggable, children: [_node('descendant')]), _node('empty'), _node('leaf', canHaveChildren: false)]);
		bool allow(KlpExplorerDropRequest _) => true;
		bool drop(Set<KlpId> sources, String target, KlpExplorerDropPlacement placement) => snapshot.permitsDrop(KlpExplorerDropRequest(sourceIds: sources, targetId: _id(target), position: placement), permission: allow);
		expect(drop({}, 'empty', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('missing')}, 'empty', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('parent')}, 'missing', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('leaf')}, 'empty', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('parent'), _id('leaf')}, 'empty', KlpExplorerDropPlacement.inside), isFalse);
		for (final placement in KlpExplorerDropPlacement.values) {
			expect(drop({_id('parent')}, 'parent', placement), isFalse);
			expect(drop({_id('parent')}, 'descendant', placement), isFalse);
		}
		expect(drop({_id('parent')}, 'leaf', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('category')}, 'empty', KlpExplorerDropPlacement.inside), isFalse);
		expect(drop({_id('category')}, 'nested', KlpExplorerDropPlacement.before), isFalse);
		expect(drop({_id('category')}, 'descendant', KlpExplorerDropPlacement.after), isFalse);
		expect(drop({_id('category')}, 'empty', KlpExplorerDropPlacement.before), isTrue);
		expect(drop({_id('category')}, 'empty', KlpExplorerDropPlacement.after), isTrue);
		expect(drop({_id('parent')}, 'category', KlpExplorerDropPlacement.inside), isTrue);
		expect(drop({_id('nested')}, 'empty', KlpExplorerDropPlacement.inside), isTrue);
		expect(drop({_id('nested')}, 'leaf', KlpExplorerDropPlacement.before), isTrue);
		expect(drop({_id('nested')}, 'leaf', KlpExplorerDropPlacement.after), isTrue);
	});

	test('cross-tree node drops require permission and categories stay within their root tree', () {
		final category = KlpExplorerCategoryModel(id: _id('category'), row: KlpExplorerRowData(title: '分類'), capabilities: _draggable);
		final a = KlpExplorerTreeData(id: _id('a'), items: [category, _node('source', capabilities: _draggable)], expandedIds: {});
		final b = KlpExplorerTreeData(id: _id('b'), items: [_node('target')], expandedIds: {});
		final scope = KlpExplorerSelectionScope(id: _id('shared'), treeIds: [_id('a'), _id('b')], mode: KlpExplorerSelectionMode.none, selectedIds: {});
		final snapshot = KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: [scope]);
		for (final position in KlpExplorerDropPlacement.values) {
			final nodeRequest = KlpExplorerDropRequest(sourceIds: {_id('source')}, targetId: _id('target'), position: position);
			expect(snapshot.permitsDrop(nodeRequest), isFalse);
			expect(snapshot.permitsDrop(nodeRequest, permission: (_) => true), isTrue);
			final categoryRequest = KlpExplorerDropRequest(sourceIds: {_id('category')}, targetId: _id('target'), position: position);
			expect(snapshot.permitsDrop(categoryRequest, permission: (_) => true), isFalse);
		}
	});

	test('scope anchors belong to existing selectable members and may remain hidden', () {
		final parent = _node('parent', capabilities: _branch, children: [_node('hidden')]);
		final a = KlpExplorerTreeData(id: _id('a'), items: [parent, _node('disabled', capabilities: const KlpExplorerCapabilities())]);
		final b = KlpExplorerTreeData(id: _id('b'), items: [_node('other')]);
		final other = KlpExplorerSelectionScope(id: _id('other-scope'), treeIds: [_id('b')], mode: KlpExplorerSelectionMode.multiple);
		KlpExplorerSelectionScope scope(KlpId anchor) => KlpExplorerSelectionScope(id: _id('scope'), treeIds: [_id('a')], mode: KlpExplorerSelectionMode.multiple, anchorId: anchor);
		final snapshot = KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: [scope(_id('hidden')), other]);
		expect(snapshot.selectionScopes[_id('scope')]!.anchorId, _id('hidden'));
		for (final anchor in [_id('missing'), _id('disabled'), _id('other')]) {
			expect(() => KlpExplorerSnapshot.capture(trees: [a, b], selectionScopes: [scope(anchor), other]), _failsWith('explorer_invalid_selection'));
		}
	});
}

class _ConsumerItem implements KlpExplorerItemModel {

	KlpId dataId;
	KlpExplorerRole dataRole = KlpExplorerRole.node;
	KlpExplorerRowData dataRow = KlpExplorerRowData(title: 'Consumer item');
	KlpExplorerCapabilities dataCapabilities = const KlpExplorerCapabilities();
	final List<KlpExplorerItemModel> dataChildren;
	final Map<String, int> reads = {};
	bool throwOnRow = false;

	_ConsumerItem(this.dataId, this.dataChildren);

	T _read<T>(String name, T value) {
		reads.update(name, (count) => count + 1, ifAbsent: () => 1);
		return value;
	}

	@override
	KlpId get id => _read('id', dataId);

	@override
	KlpExplorerRole get role => _read('role', dataRole);

	@override
	bool get canHaveChildren => _read('canHaveChildren', true);

	@override
	KlpExplorerRowData get row {
		if (throwOnRow) throw StateError('consumer getter failed');

		return _read('row', dataRow);
	}

	@override
	KlpExplorerCapabilities get capabilities => _read('capabilities', dataCapabilities);

	@override
	List<KlpExplorerItemModel> get children => _read('children', dataChildren);
}

final class _ConsumerLeaf extends _ConsumerItem {

	_ConsumerLeaf(KlpId id) : super(id, []);

	@override
	bool get canHaveChildren => false;
}
