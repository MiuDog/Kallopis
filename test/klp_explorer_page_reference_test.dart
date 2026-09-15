import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:krepis_block_note/krepis_block_note.dart' as krepis;

void main() {
	test('absent mappings preserve the existing constructor and do not infer page IDs from labels', () {
		final page = KlpExplorerItem(id: KlpId.root('page'), label: 'project-A/page', kind: KlpExplorerItemKind.file);
		final explorer = KlpExplorer(id: KlpId.root('explorer'), items: [page]);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final bound = _prepare(runtime, explorer);
		expect(explorer.pageReferences, isEmpty);
		expect(bound.pageReferences, isEmpty);
		expect(bound.items.single.sourceId, page.id);
	});

	test('mapping snapshots nested selectable nodes with complete cross-project identities', () {
		final firstId = KlpId.root('first');
		final secondId = KlpId.root('second');
		final first = krepis.KrepisPageReference(projectId: 'A', documentId: 'same');
		final second = krepis.KrepisPageReference(projectId: 'B', documentId: 'same');
		final mapping = {firstId: first, secondId: second};
		final branch = KlpExplorerItem(id: firstId, label: '同名', kind: KlpExplorerItemKind.branch, children: [KlpExplorerItem(id: secondId, label: '同名', kind: KlpExplorerItemKind.file)]);
		final explorer = KlpExplorer(id: KlpId.root('explorer'), items: [branch], pageReferences: mapping);
		mapping.clear();
		expect(explorer.pageReferences, {firstId: first, secondId: second});
		expect(() => explorer.pageReferences.clear(), throwsUnsupportedError);
		final runtime = KlpTreeRuntime();
		addTearDown(runtime.dispose);
		final bound = _prepare(runtime, explorer);
		expect(bound.pageReferences[firstId], same(first));
		expect(bound.pageReferences[secondId], same(second));
		expect(bound.pageReferences[firstId], isNot(bound.pageReferences[secondId]));
		expect(() => bound.pageReferences.clear(), throwsUnsupportedError);
		final replacement = _prepare(runtime, KlpExplorer(id: explorer.id, items: [branch], pageReferences: {secondId: second}));
		expect(replacement.pageReferences, {secondId: second});
		expect(bound.pageReferences, {firstId: first, secondId: second});
	});

	test('mapping rejects missing, category and unselectable keys without changing item roles', () {
		final page = krepis.KrepisPageReference(projectId: 'A', documentId: 'page');
		final leaf = KlpExplorerItem(id: KlpId.root('leaf'), label: 'Leaf', kind: KlpExplorerItemKind.file);
		final category = KlpExplorerItem(id: KlpId.root('category'), label: 'Category', kind: KlpExplorerItemKind.category, selectable: true, children: [leaf]);
		final structure = KlpExplorerItem(id: KlpId.root('structure'), label: 'Structure', kind: KlpExplorerItemKind.branch, selectable: false);
		for (final invalid in [KlpId.root('missing'), category.id, structure.id]) {
			expect(() => KlpExplorer(id: KlpId.root('explorer'), items: [category, structure], pageReferences: {invalid: page}), throwsArgumentError);
		}
		expect(KlpExplorer(id: KlpId.root('explorer'), items: [category, structure], pageReferences: {leaf.id: page}).pageReferences, {leaf.id: page});
		expect(category.kind, KlpExplorerItemKind.category);
		expect(structure.selectable, isFalse);
	});

	for (final withReferences in [false, true]) {
		test('prepared Explorer keeps the whole multi-selection move when mapping=$withReferences', () {
			final a = KlpId.root('a');
			final b = KlpId.root('b');
			final target = KlpId.root('target');
			final selected = {a, b};
			final checked = <(Set<KlpId>, KlpId, KlpExplorerDropPosition)>[];
			final moved = <(Set<KlpId>, KlpId, KlpExplorerDropPosition)>[];
			final mapping = <KlpId, krepis.KrepisPageReference>{};
			if (withReferences) {
				mapping[a] = krepis.KrepisPageReference(projectId: 'A', documentId: 'same');
				mapping[b] = krepis.KrepisPageReference(projectId: 'B', documentId: 'same');
			}
			final explorer = KlpExplorer(
				id: KlpId.root('explorer'),
				items: [KlpExplorerItem(id: a, label: 'A', kind: KlpExplorerItemKind.file), KlpExplorerItem(id: b, label: 'B', kind: KlpExplorerItemKind.file), KlpExplorerItem(id: target, label: 'Target', kind: KlpExplorerItemKind.folder)],
				selectedIds: selected,
				pageReferences: mapping,
				canMove: (ids, destination, position) { checked.add((Set.of(ids), destination, position)); return true; },
				onMove: (ids, destination, position) { moved.add((Set.of(ids), destination, position)); },
			);
			final runtime = KlpTreeRuntime();
			addTearDown(runtime.dispose);
			final bound = _prepare(runtime, explorer);
			expect(checked, isEmpty);
			expect(moved, isEmpty);
			final targetPlacement = bound.items.singleWhere((item) => item.sourceId == target).id;
			expect(bound.canMove!(selected, targetPlacement, KlpExplorerDropPosition.inside.index), isTrue);
			bound.onMove!(selected, targetPlacement, KlpExplorerDropPosition.inside.index);
			expect(checked, hasLength(1));
			expect(checked.single.$1, selected);
			expect(checked.single.$2, target);
			expect(checked.single.$3, KlpExplorerDropPosition.inside);
			expect(moved, hasLength(1));
			expect(moved.single.$1, selected);
			expect(moved.single.$2, target);
			expect(moved.single.$3, KlpExplorerDropPosition.inside);
			expect(bound.items.where((item) => item.selected).map((item) => item.sourceId).toSet(), selected);
		});
	}
}

KlpBoundExplorer _prepare(KlpTreeRuntime runtime, KlpExplorer explorer) {
	// 穿過現行 Explorer adapter 的 prepare/materialize，保留來源與 placement 的正式轉換。
	runtime.update(root: explorer, adapters: KlpWorkspaceComponentsAdapter.createAll(), primitives: KlpWorkspacePreset.light());
	return (runtime.frame!.content as KlpBoundPlacement).content as KlpBoundExplorer;
}
