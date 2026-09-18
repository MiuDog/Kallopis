import 'klp_editing_projection.dart';

/// 舊正文來源對編輯請求的裁決；畫面依回覆呈現而不重做交易。
enum KlpEditingDecision { accepted, rejected, cancelled }

/// 每次明確結果附帶權威投影；accepted 僅代表編輯，不代表保存成功。
final class KlpEditingReply {

	final KlpEditingDecision decision;
	final KlpEditingProjection projection;

	const KlpEditingReply(this.decision, this.projection);
}
