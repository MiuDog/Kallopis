import 'package:flutter/material.dart';

import '../internal/klp_button_style.dart';
import 'klp_button_types.dart';
import '../klp_control_size.dart';
import '../../interaction/klp_pressable.dart';
import '../../surface/klp_dashed_border.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

export 'klp_button_types.dart';

/// 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／dashed／danger），
/// `size` 支援五段緊湊尺寸階級（xs: 28px, sm: 32px, md: 36px, lg: 40px, xl: 48px），
/// 預設使用 sm，`compact` 使用 xs；`selected` 是由呼叫端持有的持續選取狀態。
/// 圓角、內距、高度、狀態 wash 與邊框皆由風格表解析目前 theme。
class KlpButton extends StatefulWidget {

	final String label;
	final VoidCallback? onPressed;
	final KlpButtonTone tone;
	final KlpControlSize? size;
	final Widget? leading;
	final Widget? trailing;
	final bool compact;
	final bool selected;
	final VoidCallback? onLongPress;

	const KlpButton({
		super.key,
		required this.label,
		required this.onPressed,
		this.tone = KlpButtonTone.primary,
		this.size,
		this.leading,
		this.trailing,
		this.compact = false,
		this.selected = false,
		this.onLongPress,
	});

	@override
	State<KlpButton> createState() => _KlpButtonState();
}

class _KlpButtonState extends State<KlpButton> {

	bool _hovered = false;
	bool _focused = false;

	void _setHovered(bool value) => setState(() => _hovered = value);

	void _setFocused(bool value) => setState(() => _focused = value);

	@override
	Widget build(BuildContext context) {
		// 每次建構依目前 scope 解析，保留主題切換與局部色彩覆寫的繼承。
		final style = KlpButtonStyle.resolve(
			klp: context.klp,
			tone: widget.tone,
			size: widget.size ?? (widget.compact ? KlpControlSize.xs : KlpControlSize.sm),
			disabled: widget.onPressed == null,
			active: _hovered || _focused,
			selected: widget.selected,
		);

		// 組合內容與插槽，所有可變視覺值由風格表供應。
		Widget content = Container(
			height: style.height,
			padding: style.insets,
			decoration: BoxDecoration(
				color: style.background,
				borderRadius: BorderRadius.circular(style.radius),
				border: style.border,
			),
			child: DefaultTextStyle.merge(style: TextStyle(color: style.foreground), child: _buildContent(style)),
		);
		if (style.dashed) {
			content = KlpDashedBorder(radius: style.radius, child: content);
		}

		// 保持長按、焦點、懸停與可及性狀態的既有事件所有權。
		final pressable = KlpPressable(
			onPressed: widget.onPressed,
			onLongPress: widget.onLongPress,
			longPressProgressColor: style.progressColor,
			onHover: _setHovered,
			onFocusChange: _setFocused,
			hoverHighlight: false,
			borderRadius: BorderRadius.circular(style.radius),
			child: content,
		);
		final material = Material(color: style.materialColor, child: pressable);
		return Semantics(selected: widget.selected, child: material);
	}

	Widget _buildContent(KlpButtonStyle style) {
		// 圖文排列沿用最小寬度、置中與單行省略，不改變插槽繼承。
		return Row(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				if (widget.leading != null) ...[
					widget.leading!,
					SizedBox(width: style.contentGap),
				],
				Flexible(child: _buildLabel(style)),
				if (widget.trailing != null) ...[
					SizedBox(width: style.contentGap),
					widget.trailing!,
				],
			],
		);
	}

	Widget _buildLabel(KlpButtonStyle style) {
		return KlpText(
			widget.label,
			role: style.labelRole,
			color: style.foreground,
			maxLines: 1,
			overflow: TextOverflow.ellipsis,
		);
	}
}
