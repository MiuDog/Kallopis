part of '../klp_button.dart';

/// 按鈕專用的底層繪製與互動框；只接受已解析的風格介面。
class _KlpButtonFrame extends StatelessWidget {
  const _KlpButtonFrame({
    required this.style,
    required this.selected,
    required this.onPressed,
    required this.onLongPress,
    required this.onHover,
    required this.onFocusChange,
    required this.child,
  });

  final KlpButtonStyle style;
  final bool selected;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocusChange;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      height: style.height,
      padding: style.insets,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(style.radius),
        border: style.border,
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: style.foreground),
        child: child,
      ),
    );
    final pressable = KlpPressable(
      onPressed: onPressed,
      onLongPress: onLongPress,
      longPressProgressColor: style.progressColor,
      onHover: onHover,
      onFocusChange: onFocusChange,
      hoverHighlight: false,
      borderRadius: BorderRadius.circular(style.radius),
      child: content,
    );
    return Semantics(
      selected: selected,
      child: Material(color: style.materialColor, child: pressable),
    );
  }
}
