part of '../klp_editor_action_bars.dart';

/// 編輯器動作的原生互動與表面邊界。
class _KlpEditorActionFrame extends StatelessWidget {
  const _KlpEditorActionFrame({
    required this.selected,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Material(
      color: selected ? tokens.surfaceMuted : tokens.surfaceInset,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.klp.space.controlInset,
            vertical: context.klp.space.tight,
          ),
          child: child,
        ),
      ),
    );
  }
}
