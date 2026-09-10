part of '../klp_phase_toggle.dart';

class _KlpPhaseSegmentFrame extends StatelessWidget {
  const _KlpPhaseSegmentFrame({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
    required this.style,
    required this.child,
  });

  final String? label;
  final bool selected;
  final bool enabled;
  final VoidCallback? onTap;
  final _KlpPhaseToggleStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox.square(
          dimension: style.segmentExtent,
          child: Center(child: child),
        ),
      ),
    );
  }
}
