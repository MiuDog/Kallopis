part of '../klp_icon_button.dart';

/// 只有圖示的按鈕；`label` 必填並作為無障礙標註。
class KlpIconButton extends StatefulWidget {
	const KlpIconButton({
		super.key,
		required this.icon,
		required this.label,
		required this.onPressed,
		this.selected = false,
		this.quarterTurns = 0,
		this.tone = KlpIconButtonTone.standalone,
		this.size = KlpIconButtonSize.standard,
	});

	final KlpIconData icon;
	final String label;
	final VoidCallback? onPressed;
	final bool selected;
	final int quarterTurns;
	final KlpIconButtonSize size;
	final KlpIconButtonTone tone;

	@override
	State<KlpIconButton> createState() => _KlpIconButtonState();
}
