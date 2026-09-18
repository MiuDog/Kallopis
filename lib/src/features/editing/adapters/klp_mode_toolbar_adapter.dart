import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/diagnostics/klp_contract_error.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_content.dart';
import 'package:kallopis/src/features/editing/contracts/klp_mode_toolbar.dart';

/// 工具列子節點只建立 sentinel；父節點負責唯一來源能力注入。
final class KlpModeToolbarAdapter implements KlpNodeAdapter {
	@override
	KlpDefinition<KlpNode> get contract => KlpDefinition<KlpModeToolbar>(KlpModeToolbar.typeId);

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final parents = context.nodes.values.where((candidate) => candidate.childrenPlacements.contains(snapshot.placementId)).toList();
		if (parents.length != 1 || parents.single.definitionId != KlpEditingContent.typeId) {
			throw const KlpContractError('orphan_mode_toolbar', 'Mode toolbar must occupy an editing content slot.');
		}
		return _KlpPreparedModeToolbar(snapshot.id);
	}
}

final class _KlpPreparedModeToolbar implements KlpPreparedNode {
	final String id;
	const _KlpPreparedModeToolbar(this.id);
	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);
	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundModeToolbarSlot(id);
}
