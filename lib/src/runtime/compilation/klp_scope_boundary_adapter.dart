import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_scope_boundary.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_activation_policy.dart';

/// 作用域只隔離識別，不另建 runtime 或改寫子節點資料。
final class KlpScopeBoundaryAdapter implements KlpNodeAdapter {
	const KlpScopeBoundaryAdapter();

	@override
	KlpDefinition<KlpNode> get contract => KlpScopeBoundary.contract;

	@override
	KlpPreparedNode prepare(
		KlpNode node,
		KlpValidatedNode snapshot,
		KlpPrepareContext context,
	) => _PreparedBoundary((node as KlpScopeBoundary).active);
}

final class _PreparedBoundary
		implements KlpPreparedNode, KlpPreparedActivationPolicy {
	@override
	final bool descendantsActive;

	const _PreparedBoundary(this.descendantsActive);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) =>
			KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(
		KlpPlacementResource resource,
		List<KlpBoundTemplate> children,
		KlpFrameLease lease,
	) => children.single;
}
