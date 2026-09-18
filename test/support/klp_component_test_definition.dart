import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';

import 'klp_component_test_item.dart';

/// Rail／frame 測試的固定葉節點；不接受模板、selector 或外部定義。
final class KlpComponentTestAdapter implements KlpNodeAdapter {

	@override
	final contract = KlpDefinition<KlpComponentTestItem>('fixture');

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) => const _PreparedItem();
}

final class _PreparedItem implements KlpPreparedNode {

	const _PreparedItem();

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => _ItemResource();

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) => KlpBoundLinear(KlpAxis.vertical, KlpDistance(0), const []);
}

final class _ItemResource implements KlpPlacementResource {

	@override
	void update(KlpValidatedNode node) {}

	@override
	void dispose() {}
}
