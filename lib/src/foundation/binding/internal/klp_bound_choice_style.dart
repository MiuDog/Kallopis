import '../../../styling/primitives/klp_style_value.dart';

/// 選擇操作原語所需的已解析規則，狀態呈現由本庫負責。
final class KlpBoundChoiceStyle {

	final KlpColor background;
	final KlpColor selectedBackground;
	final KlpColor focusColor;
	final KlpDistance extent;
	final KlpRadius radius;
	final KlpStrokeWidth focusWidth;

	const KlpBoundChoiceStyle({
		required this.background,
		required this.selectedBackground,
		required this.focusColor,
		required this.extent,
		required this.radius,
		required this.focusWidth,
	});
}
