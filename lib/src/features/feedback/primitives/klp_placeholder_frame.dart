part of '../klp_region_placeholder.dart';

/// 將 Placeholder 的 Flutter 裁切與繪製限制在 feedback 基礎原語邊界。
class _KlpPlaceholderFrame extends StatelessWidget {
	const _KlpPlaceholderFrame({
		required this.radius,
		required this.borderColor,
		required this.borderWidth,
		required this.fillColor,
		required this.hatchColor,
		required this.hatched,
		required this.hatchBand,
		required this.hatchGap,
		required this.child,
	});

	final double radius;
	final Color borderColor;
	final double borderWidth;
	final Color fillColor;
	final Color hatchColor;
	final bool hatched;
	final double hatchBand;
	final double hatchGap;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return DecoratedBox(
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(radius),
				border: Border.all(color: borderColor, width: borderWidth),
			),
			child: ClipRRect(
				borderRadius: BorderRadius.circular(radius),
				child: CustomPaint(
					painter: _KlpPlaceholderFillPainter(
						fillColor: fillColor,
						hatchColor: hatchColor,
						hatched: hatched,
						hatchBand: hatchBand,
						hatchGap: hatchGap,
					),
					child: child,
				),
			),
		);
	}
}
