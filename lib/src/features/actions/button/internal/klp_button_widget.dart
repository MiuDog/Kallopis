part of '../klp_button.dart';

/// 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／dashed／danger），
/// `size` 支援五段緊湊尺寸階級（xs: 28px, sm: 32px, md: 36px, lg: 40px, xl: 48px），
/// 預設使用 sm，`compact` 使用 xs；`selected` 是由呼叫端持有的持續選取狀態。
/// 圓角、內距、高度、狀態 wash 與邊框皆由風格表解析目前 theme。
class KlpButton extends StatefulWidget {
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

  final String label;
  final VoidCallback? onPressed;
  final KlpButtonTone tone;
  final KlpControlSize? size;
  final Widget? leading;
  final Widget? trailing;
  final bool compact;
  final bool selected;
  final VoidCallback? onLongPress;

  @override
  State<KlpButton> createState() => _KlpButtonState();
}
