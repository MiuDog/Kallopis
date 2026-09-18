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

/// Consumer 預先宣告的精確放置許可；renderer 不在手勢期間查詢產品邏輯。
final class KlpExplorerDropAcceptance {

	final Set<KlpId> sourceIds;
	final KlpId targetId;
	final KlpExplorerDropPlacement position;

	KlpExplorerDropAcceptance({required Set<KlpId> sourceIds, required this.targetId, required this.position}) : sourceIds = Set.unmodifiable(sourceIds);

	bool matches(KlpExplorerDropRequest request) => targetId == request.targetId && position == request.position && sourceIds.length == request.sourceIds.length && sourceIds.containsAll(request.sourceIds);
}
