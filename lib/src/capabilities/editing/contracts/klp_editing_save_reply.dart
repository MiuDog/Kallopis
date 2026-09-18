import 'klp_editing_save_projection.dart';

/// 來源對保存請求的裁決，包含結果未明；不允許畫面推定保存成功。
enum KlpEditingSaveDecision { saved, rejected, unknown }

/// 保存裁決與同一來源狀態投影的回覆；不持有文件內容或執行 I/O。
final class KlpEditingSaveReply {
	final KlpEditingSaveDecision decision;
	final KlpEditingSaveProjection projection;
	const KlpEditingSaveReply(this.decision, this.projection);
}
