import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_source.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_source.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/features/editing/presentation/klp_bound_editing_style.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_resource_policy.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'klp_editing_placement.dart';

/// 準備完成的編輯內容只保留來源借用與已解析風格。
final class KlpPreparedEditing implements KlpPreparedNode, KlpPreparedResourcePolicy {
	final KlpEditingSource source;
	final KlpEditingDrawing drawing;
	final KlpBoundEditingStyle style;

	const KlpPreparedEditing(this.source, this.drawing, this.style);

	@override
	bool canReuse(KlpPlacementResource resource) => resource is KlpEditingPlacement && resource.matches(source);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpEditingPlacement(source, drawing);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		final placement = resource as KlpEditingPlacement;
		final slots = children.map((child) => child is KlpBoundPlacement ? child.content : child).toList();
		if (slots.any((child) => child is! KlpBoundBlockControlsSlot && child is! KlpBoundAnchoredCommandsSlot && child is! KlpBoundModeToolbarSlot)) {
			throw StateError('Editing block control slot was not materialized by its registered adapter.');
		}
		final blockSlot = slots.whereType<KlpBoundBlockControlsSlot>().firstOrNull;
		final commandSlot = slots.whereType<KlpBoundAnchoredCommandsSlot>().firstOrNull;
		final modeSlot = slots.whereType<KlpBoundModeToolbarSlot>().firstOrNull;
		return KlpBoundEditing(
			placement.drawing,
			style,
			source is KlpEditingLayoutSource ? placement : null,
			source is KlpEditableSource ? placement : null,
			blockSlot == null ? null : KlpBoundBlockControls(blockSlot.id, placement),
			commandSlot == null ? null : KlpBoundAnchoredCommands(commandSlot.id, placement),
			modeSlot == null ? null : KlpBoundModeToolbar(modeSlot.id, placement),
			source is KlpEditingSaveSource ? placement : null,
		);
	}
}
