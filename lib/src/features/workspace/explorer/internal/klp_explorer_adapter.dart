import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_index.dart';
import 'package:kallopis/src/styling/primitives/klp_style_kind.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/references/klp_style_ref.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_key.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'package:kallopis/src/styling/semantics/klp_semantic_token.dart';
import '../klp_explorer.dart';
import 'klp_explorer_entry_node.dart';

/// Explorer 唯一 adapter；樣式用途獨立，且不辨識任何產品種類。
final class KlpExplorerAdapter implements KlpNodeAdapter {

	static const _owner = KlpExplorer.typeId;
	static final surface = KlpSemanticKey(_owner, 'commandSurface', KlpStyleKind.color);
	static final foreground = KlpSemanticKey(_owner, 'foreground', KlpStyleKind.color);
	static final muted = KlpSemanticKey(_owner, 'mutedForeground', KlpStyleKind.color);
	static final selected = KlpSemanticKey(_owner, 'selectedBackground', KlpStyleKind.color);
	static final focus = KlpSemanticKey(_owner, 'focusColor', KlpStyleKind.color);
	static final nodeExtent = KlpSemanticKey(_owner, 'nodeExtent', KlpStyleKind.distance);
	static final categoryExtent = KlpSemanticKey(_owner, 'categoryExtent', KlpStyleKind.distance);
	static final iconExtent = KlpSemanticKey(_owner, 'iconExtent', KlpStyleKind.distance);
	static final disclosureIconExtent = KlpSemanticKey(_owner, 'disclosureIconExtent', KlpStyleKind.distance);
	static final indent = KlpSemanticKey(_owner, 'indent', KlpStyleKind.distance);
	static final inset = KlpSemanticKey(_owner, 'inset', KlpStyleKind.distance);
	static final gap = KlpSemanticKey(_owner, 'gap', KlpStyleKind.distance);
	static final disclosureExtent = KlpSemanticKey(_owner, 'disclosureExtent', KlpStyleKind.distance);
	static final actionExtent = KlpSemanticKey(_owner, 'actionExtent', KlpStyleKind.distance);
	static final categoryFontSize = KlpSemanticKey(_owner, 'categoryFontSize', KlpStyleKind.fontSize);
	static final radius = KlpSemanticKey(_owner, 'radius', KlpStyleKind.radius);
	static final focusWidth = KlpSemanticKey(_owner, 'focusWidth', KlpStyleKind.strokeWidth);
	static final fontFamily = KlpSemanticKey(_owner, 'fontFamily', KlpStyleKind.fontFamily);
	static final fontSize = KlpSemanticKey(_owner, 'fontSize', KlpStyleKind.fontSize);
	static final fontWeight = KlpSemanticKey(_owner, 'fontWeight', KlpStyleKind.fontWeight);
	static final lineHeight = KlpSemanticKey(_owner, 'lineHeight', KlpStyleKind.lineHeight);
	static final letterSpacing = KlpSemanticKey(_owner, 'letterSpacing', KlpStyleKind.letterSpacing);
	final KlpDefinition<KlpNode> _contract;

	KlpExplorerAdapter._(this._contract);

	@override
	KlpDefinition<KlpNode> get contract => _contract;

	static List<KlpNodeAdapter> createAll() => [
		KlpExplorerAdapter._(KlpDefinition<KlpExplorer>(_owner, semantics: _schema(), slots: [KlpExplorer.itemSlot])),
		KlpExplorerAdapter._(KlpDefinition<KlpExplorerEntryNode>(KlpExplorerEntryNode.typeId, slots: [KlpExplorerEntryNode.childSlot])),
	];

	static KlpSemanticSchema _schema() {
		KlpSemanticToken<T> token<T extends KlpStyleValue>(KlpSemanticKey<T> key, KlpPrimitiveIndex index) => KlpSemanticToken(key, KlpPrimitiveRef(key.kind, index));
		return KlpSemanticSchema(_owner, [
			token(surface, KlpPrimitiveIndex.i3), token(foreground, KlpPrimitiveIndex.i1), token(muted, KlpPrimitiveIndex.i4), token(selected, KlpPrimitiveIndex.i5), token(focus, KlpPrimitiveIndex.i7),
			token(nodeExtent, KlpPrimitiveIndex.i5), token(categoryExtent, KlpPrimitiveIndex.i5), token(iconExtent, KlpPrimitiveIndex.i4), token(disclosureIconExtent, KlpPrimitiveIndex.i3), token(indent, KlpPrimitiveIndex.i2), token(inset, KlpPrimitiveIndex.i2), token(gap, KlpPrimitiveIndex.i1), token(disclosureExtent, KlpPrimitiveIndex.i4), token(actionExtent, KlpPrimitiveIndex.i5),
			token(categoryFontSize, KlpPrimitiveIndex.i1), token(radius, KlpPrimitiveIndex.i1), token(focusWidth, KlpPrimitiveIndex.i1), token(fontFamily, KlpPrimitiveIndex.i0), token(fontSize, KlpPrimitiveIndex.i2), token(fontWeight, KlpPrimitiveIndex.i3), token(lineHeight, KlpPrimitiveIndex.i4), token(letterSpacing, KlpPrimitiveIndex.i3),
		]);
	}

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		if (node is! KlpExplorer) return const _PreparedEntry();

		// 共用範圍只能計入同一結構中實際掛載且使用同份資料的樹。
		final mounted = {for (final source in context.sources.values.whereType<KlpExplorer>()) source.id: source};
		for (final id in node.data.snapshot.trees.keys) {
			if (!identical(mounted[id]?.data, node.data)) {
				throw KlpContractError('explorer_invalid_scope', '森林成員必須在同一結構掛載並共享資料宣告：$id。');
			}
		}

		return _PreparedExplorer(node, context.style);
	}
}

final class _PreparedExplorer implements KlpPreparedNode {

	final KlpExplorer explorer;
	final KlpSemanticResolution style;

	const _PreparedExplorer(this.explorer, this.style);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		final snapshot = explorer.data.snapshot;

		// 列高各自校準密度，不與 padding、圖示或另一種列高建立相依。
		final nodeExtent = KlpDistance(style.read(KlpExplorerAdapter.nodeExtent).value * 7 / 8);
		final categoryExtent = KlpDistance(style.read(KlpExplorerAdapter.categoryExtent).value * 7 / 8);
		return KlpBoundExplorer(
			treeId: explorer.id, snapshot: snapshot, actionsLabel: explorer.actionsLabel, expandLabel: explorer.expandLabel, collapseLabel: explorer.collapseLabel,
			onSelectionChanged: explorer.onSelectionChanged == null ? null : (change) => lease.run(() => explorer.onSelectionChanged!(change)),
			onActivate: explorer.onActivate == null ? null : (id) => lease.run(() => explorer.onActivate!(id)),
			onExpandedChanged: explorer.onExpandedChanged == null ? null : (id, value) => lease.run(() => explorer.onExpandedChanged!(id, value)),
			canDrop: (request) => lease.isActive && snapshot.permitsDrop(request, permission: explorer.canDrop),
			onDrop: explorer.onDrop == null ? null : (request) { if (lease.isActive && snapshot.permitsDrop(request, permission: explorer.canDrop)) explorer.onDrop!(request); },
			isActive: () => lease.isActive,
			surface: style.read(KlpExplorerAdapter.surface), foreground: style.read(KlpExplorerAdapter.foreground), mutedForeground: style.read(KlpExplorerAdapter.muted), selectedBackground: style.read(KlpExplorerAdapter.selected), focusColor: style.read(KlpExplorerAdapter.focus),
			nodeExtent: nodeExtent, categoryExtent: categoryExtent, iconExtent: style.read(KlpExplorerAdapter.iconExtent), disclosureIconExtent: style.read(KlpExplorerAdapter.disclosureIconExtent), categoryFontSize: style.read(KlpExplorerAdapter.categoryFontSize), indent: style.read(KlpExplorerAdapter.indent), inset: style.read(KlpExplorerAdapter.inset), gap: style.read(KlpExplorerAdapter.gap), disclosureExtent: style.read(KlpExplorerAdapter.disclosureExtent), actionExtent: style.read(KlpExplorerAdapter.actionExtent), radius: style.read(KlpExplorerAdapter.radius), focusWidth: style.read(KlpExplorerAdapter.focusWidth),
			textStyle: KlpBoundTextStyle(color: style.read(KlpExplorerAdapter.foreground), fontFamily: style.read(KlpExplorerAdapter.fontFamily), fontSize: style.read(KlpExplorerAdapter.fontSize), fontWeight: style.read(KlpExplorerAdapter.fontWeight), lineHeight: style.read(KlpExplorerAdapter.lineHeight), letterSpacing: style.read(KlpExplorerAdapter.letterSpacing)),
		);
	}
}

final class _PreparedEntry implements KlpPreparedNode {

	const _PreparedEntry();

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => const KlpBoundWorkspaceData();
}
