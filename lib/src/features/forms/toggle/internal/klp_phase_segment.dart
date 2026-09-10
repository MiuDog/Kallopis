part of '../klp_phase_toggle.dart';

class _KlpPhaseSegment<T> extends StatelessWidget {
  const _KlpPhaseSegment({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.style,
    required this.onTap,
  });

  final KlpPhaseOption<T> option;
  final bool selected;
  final bool enabled;
  final _KlpPhaseToggleStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = style.foregroundFor(
      option.activeTone,
      selected: selected,
      enabled: enabled,
    );
    Widget content = KlpText(
      option.label ?? '',
      role: KlpTextRole.code,
      color: foreground,
    );
    if (option.icon != null) {
      content = KlpIcon(
        option.icon!,
        size: context.klp.space.iconSmall,
        color: foreground,
      );
    }
    return _KlpPhaseSegmentFrame(
      label: option.label,
      selected: selected,
      enabled: enabled,
      onTap: onTap,
      style: style,
      child: content,
    );
  }
}
