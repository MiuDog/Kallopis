import 'package:kallopis/src/composition/definitions/klp_definition.dart';
import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepare_context.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/composition/nodes/klp_adaptive.dart';
import 'package:kallopis/src/runtime/compilation/internal/klp_prepared_adaptive.dart';

/// 宣告式自適應節點適配器：註冊合約並編譯為準備節點。
final class KlpAdaptiveAdapter implements KlpNodeAdapter {

	@override
	KlpDefinition<KlpNode> get contract => KlpDefinition<KlpAdaptive>(KlpAdaptive.typeId, slots: [KlpAdaptive.fallbackSlot]);

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		return const KlpPreparedAdaptive();
	}
}
