import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_declarative.dart' as klp;
import 'package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart';
import 'package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart';
import 'package:kallopis/src/runtime/compilation/klp_tree_runtime.dart';
import 'package:kallopis/src/styling/presets/klp_workspace_preset.dart';

/// Catalog 專用宿主，直接展示正式 renderer；不是提供給 consumer 的 Widget。
final class ExplorerPreview extends StatefulWidget {

	final List<klp.KlpExplorerItemModel> items;
	final Set<klp.KlpId>? selectedIds;
	final ValueChanged<klp.KlpId>? onActivate;
	final bool dark;
	final bool allowDrop;
	final bool collapseDescendants;
	final bool framed;
	final ScrollController? scrollController;
	final ValueChanged<String>? onEvent;

	const ExplorerPreview({required this.items, this.selectedIds, this.onActivate, this.dark = false, this.allowDrop = false, this.collapseDescendants = false, this.framed = false, this.scrollController, this.onEvent, super.key});

	@override
	State<ExplorerPreview> createState() => _ExplorerPreviewState();
}

final class _ExplorerPreviewState extends State<ExplorerPreview> {

	final _runtime = KlpTreeRuntime();
	final _treeId = klp.KlpId.root('catalog-explorer');
	Set<klp.KlpId> _expanded = {};
	Set<klp.KlpId> _selected = {};
	klp.KlpId? _anchor;

	@override
	void initState() {
		super.initState();
		_expanded = {for (final item in _walk()) if (item.capabilities.collapsible && (item.role == klp.KlpExplorerRole.category || item.hasChildren)) item.id};
	}

	@override
	void dispose() {
		_runtime.dispose();
		super.dispose();
	}

	Iterable<klp.KlpExplorerItemModel> _walk() sync* {
		final stack = widget.items.reversed.toList();
		while (stack.isNotEmpty) {
			final item = stack.removeLast();
			yield item;
			stack.addAll(item.children.reversed);
		}
	}

	List<klp.KlpExplorerDropAcceptance> _acceptedDrops() {
		if (!widget.allowDrop) return const [];

		final items = <klp.KlpId, klp.KlpExplorerItemModel>{};
		final parents = <klp.KlpId, klp.KlpId?>{};
		final pending = <(klp.KlpExplorerItemModel, klp.KlpId?)>[
			for (final item in widget.items.reversed) (item, null),
		];
		while (pending.isNotEmpty) {
			final (item, parentId) = pending.removeLast();
			items[item.id] = item;
			parents[item.id] = parentId;
			pending.addAll([for (final child in item.children.reversed) (child, item.id)]);
		}

		bool containsTarget(klp.KlpId sourceId, klp.KlpId targetId) {
			klp.KlpId? current = targetId;
			while (current != null) {
				if (current == sourceId) return true;

				current = parents[current];
			}
			return false;
		}

		return [
			for (final source in items.values)
				if (source.capabilities.draggable)
					for (final target in items.values)
						if (!containsTarget(source.id, target.id))
							for (final position in klp.KlpExplorerDropPlacement.values)
								if (source.role != klp.KlpExplorerRole.category || position != klp.KlpExplorerDropPlacement.inside && parents[target.id] == null)
									if (position != klp.KlpExplorerDropPlacement.inside || target.canHaveChildren)
										klp.KlpExplorerDropAcceptance(sourceIds: {source.id}, targetId: target.id, position: position),
		];
	}

	@override
	Widget build(BuildContext context) {
		final items = _walk().toList();
		final selectable = {for (final item in items) if (item.capabilities.selectable) item.id};
		final expandable = {for (final item in items) if (item.capabilities.collapsible && (item.role == klp.KlpExplorerRole.category || item.hasChildren)) item.id};
		final tree = klp.KlpExplorerTreeData(id: _treeId, items: widget.items, expandedIds: _expanded.intersection(expandable));
		final scope = klp.KlpExplorerSelectionScope(
			id: _treeId / 'selection',
			treeIds: [_treeId],
			mode: klp.KlpExplorerSelectionMode.multiple,
			selectedIds: (widget.selectedIds ?? _selected).intersection(selectable),
			anchorId: selectable.contains(_anchor) ? _anchor : null,
		);
		final data = klp.KlpExplorerData(trees: [tree], selectionScopes: [scope], acceptedDrops: _acceptedDrops());
		final explorer = klp.KlpExplorer(
			id: _treeId,
			data: data,
			onIntent: (intent) {
				switch (intent) {
					case klp.KlpExplorerSelectionRequested(:final selectedIds, :final anchorId):
						setState(() {
							_selected = selectedIds;
							_anchor = anchorId;
							widget.onEvent?.call('selection: ${selectedIds.join(', ')}');
						});
					case klp.KlpExplorerActivationRequested(:final itemId):
						widget.onActivate?.call(itemId);
						widget.onEvent?.call('activate: $itemId');
					case klp.KlpExplorerExpansionRequested(:final itemId, :final expanded):
						setState(() {
							_expanded = data.expandedIdsAfter(itemId, expanded, collapseDescendants: widget.collapseDescendants);
							widget.onEvent?.call('expanded: $itemId = $expanded；遞迴收合：${widget.collapseDescendants}');
						});
					case klp.KlpExplorerDropRequested(:final targetId, :final position):
						widget.onEvent?.call('drop: ${position.name} $targetId');
					case klp.KlpExplorerCommandRequested(:final itemId, :final commandId, :final input):
						widget.onEvent?.call('command: $itemId / $commandId / ${input ?? '-'}');
				}
			},
		);

		// 這是庫內 Catalog harness，原始 runtime 僅用來展示真正的 Explorer。
		final root = widget.framed ? klp.KlpScreen(id: _treeId / 'screen', accessibilityLabel: 'Explorer Catalog', child: klp.KlpAppLayout(id: _treeId / 'layout', child: klp.KlpAppFrame(id: _treeId / 'frame', child: klp.KlpFrameGroups(id: _treeId / 'groups', groups: [klp.KlpFrameGroup(id: _treeId / 'group', content: [explorer])])))) : explorer;
		_runtime.update(root: root, adapters: klpApplicationAdapters(), primitives: widget.dark ? KlpWorkspacePreset.dark() : KlpWorkspacePreset.light());
		final rendered = KlpFlutterRenderer(content: _runtime.frame!.content);
		return widget.framed ? rendered : SingleChildScrollView(controller: widget.scrollController, child: rendered);
	}
}
