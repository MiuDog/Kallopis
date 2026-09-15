import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import 'package:kallopis/src/features/workspace/components/klp_document_tabs.dart';
import 'package:kallopis/src/features/workspace/components/klp_explorer.dart';
import 'package:kallopis/src/features/workspace/components/klp_window_controls.dart';
import 'package:kallopis/src/features/workspace/components/klp_workspace_command.dart';

/// 內建 Explorer、分頁、視窗控制與工作區資料的封閉轉接器目錄；不接受使用端元件定義。
final class KlpWorkspaceComponentsAdapter implements KlpNodeAdapter {
	final KlpDefinition<KlpNode> _contract;
	KlpWorkspaceComponentsAdapter._(this._contract);
	@override
	KlpDefinition<KlpNode> get contract => _contract;

	static List<KlpNodeAdapter> createAll() => [
		KlpWorkspaceComponentsAdapter._(KlpDefinition<KlpExplorer>(KlpExplorer.typeId, semantics: _KlpWorkspaceSemantics.schema(KlpExplorer.typeId), slots: [KlpExplorer.itemSlot])),
		KlpWorkspaceComponentsAdapter._(KlpDefinition<KlpExplorerItem>(KlpExplorerItem.typeId, slots: [KlpExplorerItem.childSlot])),
		KlpWorkspaceComponentsAdapter._(KlpDefinition<KlpDocumentTabs>(KlpDocumentTabs.typeId, semantics: _KlpWorkspaceSemantics.schema(KlpDocumentTabs.typeId), slots: [KlpDocumentTabs.tabSlot])),
		KlpWorkspaceComponentsAdapter._(KlpDefinition<KlpDocumentTab>(KlpDocumentTab.typeId)),
		KlpWorkspaceComponentsAdapter._(KlpDefinition<KlpWindowControls>(KlpWindowControls.typeId, semantics: _KlpWorkspaceSemantics.schema(KlpWindowControls.typeId))),
	];

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		if (node is KlpExplorer) return _prepareExplorer(node, snapshot, context);
		if (node is KlpDocumentTabs) return _prepareTabs(node, snapshot, context);
		if (node is KlpWindowControls) return _prepareWindow(node, context);
		return const _KlpPreparedWorkspaceData();
	}

	KlpPreparedNode _prepareExplorer(KlpExplorer explorer, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final ids = <KlpPlacementId, KlpId>{};
		KlpBoundExplorerItemData itemData(KlpValidatedNode node) {
			final item = context.sources[node.placementId]! as KlpExplorerItem;
			ids[node.placementId] = item.id;
			return KlpBoundExplorerItemData(id: node.placementId, sourceId: item.id, label: item.label, folder: item.kind == KlpExplorerItemKind.folder, branch: item.kind == KlpExplorerItemKind.branch, category: item.kind == KlpExplorerItemKind.category, collapsible: item.collapsible, selectable: item.selectable, icon: item.icon == null ? null : const ['file-text', 'folder', 'image', 'music', 'layout-dashboard'][item.icon!.index], badge: item.badge, selected: item.selectable && (explorer.selectedIds.contains(item.id) || explorer.selectedIds.isEmpty && explorer.selectedId == item.id), expanded: explorer.expandedIds.contains(item.id), actions: item.actions.map(_command).toList(growable: false), children: [for (final child in node.childrenPlacements) itemData(context.nodes[child]!)]);
		}
		final style = context.style;
		return _KlpPreparedExplorer(
			actionsLabel: explorer.actionsLabel, expandLabel: explorer.expandLabel, collapseLabel: explorer.collapseLabel, allowNesting: explorer.allowNesting, showCommandButtons: explorer.commandPresentation == KlpExplorerCommandPresentation.buttonAndContextMenu, spacing: explorer.spacing.index,
			items: [for (final child in snapshot.childrenPlacements) itemData(context.nodes[child]!)],
			onSelected: explorer.onSelected == null ? null : (placement) => explorer.onSelected!(ids[placement]!),
			onSelectionChanged: explorer.onSelectionChanged == null ? null : (placements) => explorer.onSelectionChanged!({for (final placement in placements) ids[placement]!}),
			onExpandedChanged: explorer.onExpandedChanged == null ? null : (placement, expanded) => explorer.onExpandedChanged!(ids[placement]!, expanded),
			canMove: explorer.canMove == null ? null : (sourceIds, target, position) => explorer.canMove!(sourceIds, ids[target]!, KlpExplorerDropPosition.values[position]),
			onMove: explorer.onMove == null ? null : (sourceIds, target, position) => explorer.onMove!(sourceIds, ids[target]!, KlpExplorerDropPosition.values[position]),
			style: _KlpWorkspaceStyle.read(style, KlpExplorer.typeId),
		);
	}

	KlpPreparedNode _prepareTabs(KlpDocumentTabs tabs, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final style = context.style;
		final ids = <KlpPlacementId, KlpId>{for (final placement in snapshot.childrenPlacements) placement: context.sources[placement]!.id};
		return _KlpPreparedTabs(
			tabs: [for (final placement in snapshot.childrenPlacements) _tabData(context.sources[placement]! as KlpDocumentTab, placement, tabs.selectedId)],
			onSelected: tabs.onSelected == null ? null : (placement) => tabs.onSelected!(ids[placement]!),
			onClose: tabs.onClose == null ? null : (placement) => tabs.onClose!(ids[placement]!),
			onPinnedChanged: tabs.onPinnedChanged == null ? null : (placement, pinned) => tabs.onPinnedChanged!(ids[placement]!, pinned),
			style: _KlpWorkspaceStyle.read(style, KlpDocumentTabs.typeId),
		);
	}

	KlpBoundDocumentTabData _tabData(KlpDocumentTab tab, KlpPlacementId placement, KlpId? selectedId) => KlpBoundDocumentTabData(id: placement, label: tab.label, dirty: tab.dirty, closable: tab.closable, pinned: tab.pinned, selected: selectedId == tab.id);

	KlpPreparedNode _prepareWindow(KlpWindowControls controls, KlpPrepareContext context) => _KlpPreparedWindow(controls: controls, style: _KlpWorkspaceStyle.read(context.style, KlpWindowControls.typeId));
}

KlpBoundWorkspaceCommand _command(KlpWorkspaceCommand command) => KlpBoundWorkspaceCommand(label: command.label, enabled: command.enabled, destructive: command.destructive, inputLabel: command.inputLabel, initialValue: command.initialValue, confirmation: command.confirmation, submitLabel: command.submitLabel, cancelLabel: command.cancelLabel, shortcut: command.shortcut?.index, onInvoke: command.onInvoke);

final class _KlpWorkspaceSemantics {
	static KlpSemanticKey<T> key<T extends KlpStyleValue>(String owner, String name, KlpStyleKind<T> kind) => KlpSemanticKey(owner, name, kind);
	static KlpSemanticSchema schema(String owner) {
		final keys = _KlpWorkspaceKeys(owner);
		KlpSemanticToken<T> token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken(key, KlpPrimitiveRef(key.kind, index));
		return KlpSemanticSchema(owner, [
			token(keys.background, owner == KlpExplorer.typeId ? KlpPrimitiveIndex.i2 : KlpPrimitiveIndex.i3), token(keys.foreground, KlpPrimitiveIndex.i1), token(keys.selectedBackground, KlpPrimitiveIndex.i5), token(keys.mutedForeground, KlpPrimitiveIndex.i4), token(keys.focusColor, KlpPrimitiveIndex.i7), token(keys.closeHover, KlpPrimitiveIndex.i5),
			token(keys.extent, KlpPrimitiveIndex.i5), token(keys.indent, KlpPrimitiveIndex.i4), token(keys.inset, KlpPrimitiveIndex.i2), token(keys.gap, KlpPrimitiveIndex.i1), token(keys.radius, KlpPrimitiveIndex.i1), token(keys.focusWidth, KlpPrimitiveIndex.i1),
			token(keys.fontFamily, KlpPrimitiveIndex.i0), token(keys.fontSize, KlpPrimitiveIndex.i2), token(keys.fontWeight, KlpPrimitiveIndex.i3), token(keys.lineHeight, KlpPrimitiveIndex.i4), token(keys.letterSpacing, KlpPrimitiveIndex.i3),
		]);
	}
}

final class _KlpWorkspaceKeys {
	final String owner;
	late final background = _KlpWorkspaceSemantics.key(owner, 'background', KlpStyleKind.color);
	late final foreground = _KlpWorkspaceSemantics.key(owner, 'foreground', KlpStyleKind.color);
	late final selectedBackground = _KlpWorkspaceSemantics.key(owner, 'selectedBackground', KlpStyleKind.color);
	late final mutedForeground = _KlpWorkspaceSemantics.key(owner, 'mutedForeground', KlpStyleKind.color);
	late final focusColor = _KlpWorkspaceSemantics.key(owner, 'focusColor', KlpStyleKind.color);
	late final closeHover = _KlpWorkspaceSemantics.key(owner, 'closeHover', KlpStyleKind.color);
	late final extent = _KlpWorkspaceSemantics.key(owner, 'extent', KlpStyleKind.distance);
	late final indent = _KlpWorkspaceSemantics.key(owner, 'indent', KlpStyleKind.distance);
	late final inset = _KlpWorkspaceSemantics.key(owner, 'inset', KlpStyleKind.distance);
	late final gap = _KlpWorkspaceSemantics.key(owner, 'gap', KlpStyleKind.distance);
	late final radius = _KlpWorkspaceSemantics.key(owner, 'radius', KlpStyleKind.radius);
	late final focusWidth = _KlpWorkspaceSemantics.key(owner, 'focusWidth', KlpStyleKind.strokeWidth);
	late final fontFamily = _KlpWorkspaceSemantics.key(owner, 'fontFamily', KlpStyleKind.fontFamily);
	late final fontSize = _KlpWorkspaceSemantics.key(owner, 'fontSize', KlpStyleKind.fontSize);
	late final fontWeight = _KlpWorkspaceSemantics.key(owner, 'fontWeight', KlpStyleKind.fontWeight);
	late final lineHeight = _KlpWorkspaceSemantics.key(owner, 'lineHeight', KlpStyleKind.lineHeight);
	late final letterSpacing = _KlpWorkspaceSemantics.key(owner, 'letterSpacing', KlpStyleKind.letterSpacing);
	_KlpWorkspaceKeys(this.owner);
}

final class _KlpWorkspaceStyle {
	final KlpColor background, foreground, selectedBackground, mutedForeground, focusColor, closeHover;
	final KlpDistance extent, indent, inset, gap;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;
	final KlpBoundTextStyle text;
	const _KlpWorkspaceStyle({required this.background, required this.foreground, required this.selectedBackground, required this.mutedForeground, required this.focusColor, required this.closeHover, required this.extent, required this.indent, required this.inset, required this.gap, required this.radius, required this.focusWidth, required this.text});
	static _KlpWorkspaceStyle read(KlpSemanticResolution style, String owner) {
		final keys = _KlpWorkspaceKeys(owner);
		return _KlpWorkspaceStyle(
			background: style.read(keys.background), foreground: style.read(keys.foreground), selectedBackground: style.read(keys.selectedBackground), mutedForeground: style.read(keys.mutedForeground), focusColor: style.read(keys.focusColor), closeHover: style.read(keys.closeHover),
			extent: style.read(keys.extent), indent: style.read(keys.indent), inset: style.read(keys.inset), gap: style.read(keys.gap), radius: style.read(keys.radius), focusWidth: style.read(keys.focusWidth),
			text: KlpBoundTextStyle(color: style.read(keys.foreground), fontFamily: style.read(keys.fontFamily), fontSize: style.read(keys.fontSize), fontWeight: style.read(keys.fontWeight), lineHeight: style.read(keys.lineHeight), letterSpacing: style.read(keys.letterSpacing)),
		);
	}
}

final class _KlpPreparedExplorer implements KlpPreparedNode {
	final bool allowNesting;
	final bool showCommandButtons;
	final String actionsLabel, expandLabel, collapseLabel;
	final int spacing;
	final List<KlpBoundExplorerItemData> items;
	final void Function(KlpPlacementId)? onSelected;
	final void Function(KlpPlacementId, bool)? onExpandedChanged;
	final void Function(Set<KlpPlacementId>)? onSelectionChanged;
	final bool Function(Set<KlpId>, KlpPlacementId, int)? canMove;
	final void Function(Set<KlpId>, KlpPlacementId, int)? onMove;
	final _KlpWorkspaceStyle style;
	const _KlpPreparedExplorer({required this.actionsLabel, required this.expandLabel, required this.collapseLabel, required this.allowNesting, required this.showCommandButtons, required this.spacing, required this.items, required this.onSelected, required this.onExpandedChanged, required this.onSelectionChanged, required this.canMove, required this.onMove, required this.style});
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundExplorer(actionsLabel: actionsLabel, expandLabel: expandLabel, collapseLabel: collapseLabel, allowNesting: allowNesting, showCommandButtons: showCommandButtons, spacing: spacing, items: items, onSelected: onSelected, onExpandedChanged: onExpandedChanged, onSelectionChanged: onSelectionChanged, canMove: canMove, onMove: onMove, background: style.background, foreground: style.foreground, selectedBackground: style.selectedBackground, mutedForeground: style.mutedForeground, focusColor: style.focusColor, gap: style.gap, rowExtent: style.extent, indent: style.indent, inset: style.inset, radius: style.radius, focusWidth: style.focusWidth, textStyle: style.text);
}

final class _KlpPreparedTabs implements KlpPreparedNode {
	final List<KlpBoundDocumentTabData> tabs;
	final void Function(KlpPlacementId)? onSelected;
	final void Function(KlpPlacementId)? onClose;
	final void Function(KlpPlacementId, bool)? onPinnedChanged;
	final _KlpWorkspaceStyle style;
	const _KlpPreparedTabs({required this.tabs, required this.onSelected, required this.onClose, required this.onPinnedChanged, required this.style});
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundDocumentTabs(tabs: tabs, onSelected: onSelected, onClose: onClose, onPinnedChanged: onPinnedChanged, background: style.background, foreground: style.foreground, selectedBackground: style.selectedBackground, mutedForeground: style.mutedForeground, focusColor: style.focusColor, extent: style.extent, inset: style.inset, gap: style.gap, radius: style.radius, focusWidth: style.focusWidth, textStyle: style.text);
}

final class _KlpPreparedWindow implements KlpPreparedNode {
	final KlpWindowControls controls;
	final _KlpWorkspaceStyle style;
	const _KlpPreparedWindow({required this.controls, required this.style});
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundWindowControls(isMaximized: controls.isMaximized, onMinimize: controls.commands.minimize, onToggleMaximize: controls.commands.toggleMaximize, onClose: controls.commands.close, background: style.background, foreground: style.foreground, closeHover: style.closeHover, focusColor: style.focusColor, extent: style.extent, buttonExtent: style.extent, gap: style.gap, radius: style.radius, focusWidth: style.focusWidth);
}

final class _KlpPreparedWorkspaceData implements KlpPreparedNode {
	const _KlpPreparedWorkspaceData();
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => const KlpBoundWorkspaceData();
}
