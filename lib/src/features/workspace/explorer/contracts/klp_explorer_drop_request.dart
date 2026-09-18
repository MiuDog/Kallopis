import 'package:kallopis/src/kernel/identity/klp_id.dart';

enum KlpExplorerDropPlacement { before, inside, after }

/// 手勢的不可變語意資料，不決定移動、引用或持久化。
final class KlpExplorerDropRequest {

	final Set<KlpId> sourceIds;
	final KlpId targetId;
	final KlpExplorerDropPlacement position;

	KlpExplorerDropRequest({required Set<KlpId> sourceIds, required this.targetId, required this.position})
		: sourceIds = Set.unmodifiable(sourceIds);
}

typedef KlpExplorerDropPermission = bool Function(KlpExplorerDropRequest request);
