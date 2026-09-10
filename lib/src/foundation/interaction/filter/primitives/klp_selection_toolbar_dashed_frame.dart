part of '../klp_selection_toolbar.dart';

class _KlpSelectionToolbarDashedFrame extends StatelessWidget {
  const _KlpSelectionToolbarDashedFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KlpDashedBorder(radius: context.klp.shape.card, child: child);
  }
}
