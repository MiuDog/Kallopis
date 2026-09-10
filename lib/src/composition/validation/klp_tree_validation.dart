import '../../kernel/identity/klp_placement_id.dart';
import 'klp_validated_node.dart';

/// 不可變的前序結構快照。
final class KlpTreeValidation {

	final KlpPlacementId rootPlacement;
	final List<KlpValidatedNode> nodes;

	KlpTreeValidation(String rootId, Iterable<KlpValidatedNode> nodes) : this.scoped(KlpPlacementId(localId: rootId), nodes);

	KlpTreeValidation.scoped(this.rootPlacement, Iterable<KlpValidatedNode> nodes) : nodes = List.unmodifiable(nodes);

	String get rootId => rootPlacement.localId;
}
