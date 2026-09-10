import '../../../composition/definitions/klp_definition.dart';
import '../../../composition/nodes/klp_node.dart';
import '../../../composition/validation/klp_validated_node.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../kernel/identity/klp_placement_id.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../../runtime/compilation/internal/klp_node_adapter.dart';
import '../../../runtime/compilation/internal/klp_prepare_context.dart';
import '../../../runtime/compilation/internal/klp_prepared_node.dart';
import '../../../runtime/installation/internal/klp_default_placement.dart';
import '../../../runtime/installation/internal/klp_placement_resource.dart';
import '../../structure/internal/klp_retained_screens.dart';

/// 保留頁在同一準備階段決定目前身份，提交後不重新讀取消費端資料。
final class KlpRetainedScreensAdapter implements KlpNodeAdapter {

	const KlpRetainedScreensAdapter();

	@override
	KlpDefinition<KlpNode> get contract => KlpRetainedScreens.contract;

	@override
	KlpPreparedNode prepare(KlpNode node, KlpValidatedNode snapshot, KlpPrepareContext context) {
		final active = (node as KlpRetainedScreens).activeEntry;
		return _PreparedRetainedScreens(snapshot.childrenPlacements.singleWhere((id) => id.localId == active));
	}
}

final class _PreparedRetainedScreens implements KlpPreparedNode {

	final KlpPlacementId activeId;

	const _PreparedRetainedScreens(this.activeId);

	@override
	KlpPlacementResource createResource(KlpValidatedNode node) => KlpDefaultPlacement(node);

	@override
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease) {
		return KlpBoundRetainedStack(pages: children.cast<KlpBoundPlacement>(), activeId: activeId);
	}
}
