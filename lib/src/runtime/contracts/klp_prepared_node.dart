import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';

/// 本庫 adapter 已完成資料及風格檢查後的安裝描述，非外部擴充介面。
abstract interface class KlpPreparedNode {
	KlpPlacementResource createResource(KlpValidatedNode node);
	KlpBoundTemplate materialize(
		KlpPlacementResource resource,
		List<KlpBoundTemplate> children,
		KlpFrameLease lease,
	);
}
