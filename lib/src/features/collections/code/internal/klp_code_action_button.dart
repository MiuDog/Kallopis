part of '../klp_code_viewer.dart';

class _KlpCodeActionButton extends StatelessWidget {
  const _KlpCodeActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.style,
    this.selected = false,
  });

  final KlpIconData icon;
  final String label;
  final ValueChanged<BuildContext>? onPressed;
  final _KlpCodeStyle style;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return KlpTooltip(
      message: label,
      child: _KlpCodeActionFrame(
        kind: _KlpCodeActionKind.icon,
        label: label,
        selected: selected,
        onPressed: onPressed,
        style: style,
        builder: (context, foreground) {
          return KlpCenter(
            child: KlpIcon(icon, size: style.iconSmall, color: foreground),
          );
        },
      ),
    );
  }
}
