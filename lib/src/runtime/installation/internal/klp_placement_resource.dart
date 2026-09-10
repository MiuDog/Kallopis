import '../../../composition/validation/klp_validated_node.dart';

/// 本庫安裝器持有的放置資源，不是消費端可注入的功能工廠。
abstract interface class KlpPlacementResource {

	/// 先提交本地資料再通知；通知拋錯時已提交的資料不得退回。
	void update(KlpValidatedNode node);

	/// 必須使本地資源終止且可重複呼叫，完成清理後才可回報外部錯誤。
	void dispose();
}
