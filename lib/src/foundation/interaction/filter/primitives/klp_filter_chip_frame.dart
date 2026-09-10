part of '../klp_filter_bar.dart';

class _KlpFilterChipFrame extends StatelessWidget {
  const _KlpFilterChipFrame({
    required this.selected,
    required this.onPressed,
    required this.builder,
  });

  final bool selected;
  final VoidCallback onPressed;
  final Widget Function(BuildContext context, _KlpFilterChipStyle style)
  builder;

  @override
  Widget build(BuildContext context) {
    final colors = context.klpColors;
    final theme = context.klp;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: theme.motion.styleTransition,
        constraints: BoxConstraints(minHeight: theme.space.controlHeightSmall),
        padding: EdgeInsets.symmetric(
          horizontal: theme.space.controlInset,
          vertical: theme.space.hairline,
        ),
        decoration: BoxDecoration(
          color: selected ? colors.selection : colors.surfaceInset,
          borderRadius: BorderRadius.circular(theme.shape.control),
          border: Border.all(
            color: colors.divider,
            width: theme.shape.hairline,
          ),
        ),
        alignment: Alignment.center,
        child: builder(
          context,
          _KlpFilterChipStyle(
            label: selected ? colors.onSelection : colors.textMuted,
            value: selected ? colors.onSelection : colors.text,
            remove: selected ? colors.onSelection : colors.textMuted,
          ),
        ),
      ),
    );
  }
}
