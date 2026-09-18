import 'package:kallopis/src/composition/nodes/klp_node.dart';
import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/styling/primitives/klp_primitive_set.dart';
import 'package:kallopis/src/styling/resolution/klp_semantic_resolution.dart';
import 'package:kallopis/src/capabilities/actions/klp_action_handler.dart';

/// 單次準備使用的快照；renderer 不會取得外部節點物件。
final class KlpPrepareContext {

	final Map<KlpPlacementId, KlpNode> sources;
	final Map<KlpPlacementId, KlpValidatedNode> nodes;
	final KlpPrimitiveSet primitives;
	final KlpSemanticResolution style;
	final KlpActionHandler? actionHandler;

	KlpPrepareContext({
		required Map<KlpPlacementId, KlpNode> sources,
		required Map<KlpPlacementId, KlpValidatedNode> nodes,
		required this.primitives,
		required this.style,
		this.actionHandler,
	}) : sources = Map.unmodifiable(sources),
		nodes = Map.unmodifiable(nodes);
}
