part of '../klp_conditional_field_region.dart';

/// 將 Flutter 尺寸動畫限制在 Form Core 基礎原語邊界。
class _KlpConditionalFieldAnimation extends StatelessWidget {
	const _KlpConditionalFieldAnimation({
		required this.visible,
		required this.child,
	});

	final bool visible;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return AnimatedSize(
			duration: context.klp.motion.stateTransition,
			child: visible ? child : const KlpBox.shrink(),
		);
	}
}
