part of '../klp_view_switcher.dart';

class _KlpViewChoiceFrame extends StatelessWidget {
  const _KlpViewChoiceFrame({required this.selected, required this.child});

  final bool selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;
    Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.navigationItemInset,
      ),
      child: child,
    );

    if (selected) {
      content = KlpTokenOverride(
        colors: colors.onBackground(colors.selection),
        child: content,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: context.klp.space.controlHeightSmall,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? colors.selection : null,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
        child: content,
      ),
    );
  }
}
