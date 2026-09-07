import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundation/klp_icon.dart';
import '../../interaction/klp_pressable.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

/// 導覽項目圖示格的識別鍵。
///
/// 圖示格與字形各有自己的 semantic token；版面測試可用此鍵分別量測兩者。
const String klpNavigationIconBoxKey = 'klp-navigation-icon-box';

/// Primary Sidebar 內的全寬導覽按鈕。
///
/// 消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、
/// hover 與選取色全部由 Kallopis theme 決定。
class KlpSidebarNavigationButton extends StatefulWidget {
	const KlpSidebarNavigationButton({
		super.key,
		required this.icon,
		required this.label,
		required this.onPressed,
		this.selected = false,
	});

	final KlpIconData icon;
	final String label;
	final VoidCallback? onPressed;
	final bool selected;

	@override
	State<KlpSidebarNavigationButton> createState() =>
		_KlpSidebarNavigationButtonState();
}

class _KlpSidebarNavigationButtonState
	extends State<KlpSidebarNavigationButton> {
	bool _hovered = false;
	bool _focused = false;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final disabled = widget.onPressed == null;
		final active = !disabled && (_hovered || _focused);
		final background = widget.selected || active
			? klp.selectionWash
			: tokens.clear;
		final textColor = disabled ? tokens.textFaint : tokens.text;
		final iconColor = disabled
			? tokens.textFaint
			: widget.selected
				? tokens.text
				: tokens.textMuted;
		final radius = BorderRadius.circular(klp.shape.control);

		return Semantics(
			button: true,
			selected: widget.selected,
			enabled: !disabled,
			label: widget.label,
			excludeSemantics: true,
			child: KlpPressable(
				onPressed: widget.onPressed,
				onHover: (value) => setState(() => _hovered = value),
				onFocusChange: (value) => setState(() => _focused = value),
				hoverHighlight: false,
				borderRadius: radius,
				child: Container(
					height: klp.space.controlHeightXSmall,
					padding: EdgeInsets.symmetric(horizontal: klp.space.navigationItemInset),
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
												widget.icon,
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
												widget.label,
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
