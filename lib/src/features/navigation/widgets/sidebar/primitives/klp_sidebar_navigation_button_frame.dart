part of '../klp_sidebar_navigation_button.dart';

/// Sidebar 導覽按鈕對 Flutter 語意、裝飾與排版的 primitive 邊界。
class _KlpSidebarNavigationButtonFrame extends StatelessWidget {
	const _KlpSidebarNavigationButtonFrame({
		required this.icon,
		required this.label,
		required this.onPressed,
		required this.selected,
		required this.hovered,
		required this.focused,
		required this.onHover,
		required this.onFocusChange,
	});

	final KlpIconData icon;
	final String label;
	final VoidCallback? onPressed;
	final bool selected;
	final bool hovered;
	final bool focused;
	final ValueChanged<bool> onHover;
	final ValueChanged<bool> onFocusChange;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final disabled = onPressed == null;
		final active = !disabled && (hovered || focused);
		final background = selected || active
				? klp.selectionWash
				: tokens.clear;
		final textColor = disabled ? tokens.textFaint : tokens.text;
		final iconColor = disabled
				? tokens.textFaint
				: selected
						? tokens.text
						: tokens.textMuted;
		final radius = BorderRadius.circular(klp.shape.control);

		return Semantics(
			button: true,
			selected: selected,
			enabled: !disabled,
			label: label,
			excludeSemantics: true,
			child: KlpPressable(
				onPressed: onPressed,
				onHover: onHover,
				onFocusChange: onFocusChange,
				hoverHighlight: false,
				borderRadius: radius,
				child: Container(
					height: klp.space.controlHeightXSmall,
					padding: EdgeInsets.symmetric(
						horizontal: klp.space.navigationItemInset,
					),
					decoration: BoxDecoration(
						color: background,
						borderRadius: radius,
					),
					child: LayoutBuilder(
						builder: (context, constraints) {
							final showLabel = constraints.maxWidth >=
									klp.space.iconSmall * 2 + klp.space.itemGap;

							return Row(
								children: [
									SizedBox.square(
										key: const ValueKey(klpNavigationIconBoxKey),
										dimension: klp.space.iconSmall,
										child: Center(
											child: KlpIcon(
												icon,
												size: math.min(
													klp.space.iconGlyph,
													klp.space.iconSmall,
												),
												color: iconColor,
											),
										),
									),
									if (showLabel) ...[
										SizedBox(width: klp.space.itemGap),
										Expanded(
											child: KlpText(
												label,
												role: KlpTextRole.code,
												color: textColor,
												maxLines: 1,
												overflow: TextOverflow.ellipsis,
											),
										),
									],
								],
							);
						},
					),
				),
			),
		);
	}
}
