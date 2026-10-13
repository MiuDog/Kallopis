part of '../klp_code_viewer.dart';

class _KlpCodeActionFrame extends StatefulWidget {
  const _KlpCodeActionFrame({
    required this.kind,
    required this.label,
    required this.onPressed,
    required this.style,
    required this.builder,
    this.selected = false,
  });

  final _KlpCodeActionKind kind;
  final String label;
  final ValueChanged<BuildContext>? onPressed;
  final _KlpCodeStyle style;
  final Widget Function(BuildContext context, Color foreground) builder;
  final bool selected;

  @override
  State<_KlpCodeActionFrame> createState() => _KlpCodeActionFrameState();
}
