import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../foundation/definitions/klp_component_definition.dart';
import '../../../foundation/binding/internal/klp_prepared_component.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../installation/internal/klp_default_placement.dart';
import '../../installation/internal/klp_placement_resource.dart';
import 'klp_node_adapter.dart';
import 'klp_prepare_context.dart';
import 'klp_prepared_node.dart';

/// 外部元件一律由受限模板展開，不能註冊自訂 runtime 或 renderer。
final class KlpComponentAdapter implements KlpNodeAdapter {

	@override
	final KlpDefinition<KlpNode> contract;

	KlpComponentAdapter(KlpComponentDefinition<KlpNode> definition) : contract = definition.contract;

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final prepared = context.components.prepareCaptured(node, snapshot, context.primitives, resolved: context.style);
		return _PreparedComponent(prepared);
	}
}

final class _PreparedComponent implements KlpPreparedNode {

	final KlpPreparedComponent component;

	const _PreparedComponent(this.component);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(
		KlpPlacementResource resource,
		List<KlpBoundTemplate> children,
		KlpFrameLease lease,
	) {
		final bound = component.materialize(children);
		final label = bound.accessibilityLabel;
		if (label == null) {
			return bound.content;
		}
		return KlpBoundAccessibility(label: label, child: bound.content);
	}
}
