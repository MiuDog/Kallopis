part of '../klp_tooltip.dart';

/// 將 Flutter tooltip 行為封裝在 overlay primitive 邊界內。
class KlpTooltip extends StatelessWidget {
	const KlpTooltip({super.key, required this.message, required this.child});

	final String message;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Tooltip(message: message, excludeFromSemantics: true, child: child);
	}
}
