import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';

/// 只有持有外部借用的 prepared node 需要縮窄通用放置資源重用規則。
abstract interface class KlpPreparedResourcePolicy {
	bool canReuse(KlpPlacementResource resource);
}
