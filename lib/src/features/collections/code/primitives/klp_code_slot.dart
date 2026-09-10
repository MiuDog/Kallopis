part of '../klp_code_viewer.dart';

class _KlpCodeSlot extends StatelessWidget {
  const _KlpCodeSlot({required this.kind, required this.style, this.child});

  final _KlpCodeSlotKind kind;
  final _KlpCodeStyle style;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final width = switch (kind) {
      _KlpCodeSlotKind.lineNumber => style.lineNumberWidth,
      _KlpCodeSlotKind.gutterNumber => style.gutterNumberWidth,
      _KlpCodeSlotKind.marker => style.gutterMarkerWidth,
      _KlpCodeSlotKind.terminalDotGap => style.terminalDotGap,
    };

    return SizedBox(width: width, child: child);
  }
}
