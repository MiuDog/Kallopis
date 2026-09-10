part of 'klp_bound_template.dart';

/// 已擷取文字及完整風格，不再保存消費端資料 selector。
final class KlpBoundText extends KlpBoundTemplate {

	final String text;
	final KlpBoundTextStyle style;

	const KlpBoundText(this.text, this.style);
}
