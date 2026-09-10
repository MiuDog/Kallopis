import '../../../composition/validation/klp_validated_node.dart';
import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../installation/internal/klp_placement_resource.dart';

/// 本庫 adapter 已完成資料及風格檢查後的安裝描述，非外部擴充介面。
abstract interface class KlpPreparedNode {

	KlpPlacementResource createResource(KlpValidatedNode node);
	KlpBoundTemplate materialize(KlpPlacementResource resource, List<KlpBoundTemplate> children, KlpFrameLease lease);
}
