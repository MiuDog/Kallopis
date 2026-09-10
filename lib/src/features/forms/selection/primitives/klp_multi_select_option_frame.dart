part of '../klp_multi_select_field.dart';

/// Multi-select 單一選項的互動與表面 primitive。
class _KlpMultiSelectOptionFrame extends StatelessWidget {
  const _KlpMultiSelectOptionFrame({
    required this.label,
    required this.selected,
    required this.visuallyEnabled,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final bool visuallyEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Material(
      color: selected ? klp.color.selection : klp.color.surfaceInset,
      borderRadius: BorderRadius.circular(klp.shape.pill),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        overlayColor: WidgetStatePropertyAll(klp.color.interactionSoft),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: klp.space.controlInset,
            vertical: klp.space.tight,
          ),
          child: KlpText(
            label,
            role: KlpTextRole.caption,
            color: !visuallyEnabled
                ? klp.color.textFaint
                : selected
                ? klp.color.onSelection
                : klp.color.text,
          ),
        ),
      ),
    );
  }
}
