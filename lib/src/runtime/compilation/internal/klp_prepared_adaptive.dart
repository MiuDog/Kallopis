import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';

/// 平台策略已在樹捕捉期收斂為單一子樹，這裡只保留受控資料邊界。
final class KlpPreparedAdaptive implements KlpPreparedNode {

	const KlpPreparedAdaptive();

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		if (children.length != 1) {
			throw StateError('KlpAdaptive requires exactly one selected child.');
		}
		return children.single;
	}
}
