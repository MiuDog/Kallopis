part of '../klp_status_indicator.dart';

/// 將狀態圓點的 Flutter 繪製限制在 feedback 基礎原語邊界。
class _KlpStatusDot extends StatelessWidget {
	const _KlpStatusDot({required this.color});

	final Color color;

	@override
	Widget build(BuildContext context) {
		return SizedBox.square(
			dimension: context.klp.space.indicatorDot,
			child: DecoratedBox(decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
		);
	}
}
