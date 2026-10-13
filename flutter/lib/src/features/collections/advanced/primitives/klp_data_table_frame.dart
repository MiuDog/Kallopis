part of '../klp_advanced_data.dart';

class _KlpDataTableFrame extends StatelessWidget {
  const _KlpDataTableFrame({required this.style, required this.child});

  final _KlpAdvancedStyle style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(style.cardRadius),
      child: KlpSurface(
        tone: KlpSurfaceTone.component,
        border: Border.all(color: style.divider, width: style.strokeWidth),
        child: child,
      ),
    );
  }
}
