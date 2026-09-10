import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/internal/klp_scope_boundary.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../installation/internal/klp_default_placement.dart';
import '../../installation/internal/klp_placement_resource.dart';
import 'klp_node_adapter.dart';
import 'klp_prepare_context.dart';
import 'klp_prepared_node.dart';
import 'klp_prepared_activation_policy.dart';

/// 作用域只隔離識別，不另建 runtime 或改寫子節點資料。
final class KlpScopeBoundaryAdapter implements KlpNodeAdapter {

	const KlpScopeBoundaryAdapter();

	@override
	KlpDefinition<KlpNode> get contract => KlpScopeBoundary.contract;

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) => _PreparedBoundary((node as KlpScopeBoundary).active);
}

final class _PreparedBoundary implements KlpPreparedNode, KlpPreparedActivationPolicy {

	@override
	final bool descendantsActive;

	const _PreparedBoundary(this.descendantsActive);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => children.single;
}
