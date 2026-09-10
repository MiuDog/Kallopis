part of '../klp_filter_bar.dart';

/// 篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。
class KlpFilterBar extends StatelessWidget {
  const KlpFilterBar({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onSelected,
    this.onRemove,
    this.onAddFilter,
    this.onClearAll,
    this.addLabel = '+ Filter',
    this.clearAllLabel = 'Clear all',
    this.leading,
    this.trailing,
  });

  final List<KlpFilterOption> filters;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final ValueChanged<String>? onRemove;
  final VoidCallback? onAddFilter;
  final VoidCallback? onClearAll;
  final String addLabel;
  final String clearAllLabel;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return KlpWrap(
      spacingSize: KlpSpaceSize.contentInline,
      runSpacingSize: KlpSpaceSize.contentStack,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ?leading,
        for (final filter in filters)
          _KlpFilterChip(
            label: filter.label,
            value: filter.value,
            selected: filter.id == selectedId,
            onPressed: () => onSelected(filter.id),
            onRemove: filter.removable && onRemove != null
                ? () => onRemove!(filter.id)
                : null,
          ),
        if (onAddFilter != null)
          KlpDashedBorder(
            child: KlpActionRegion(
              label: addLabel,
              onPressed: onAddFilter,
              shape: KlpActionRegionShape.control,
              builder: (context, style) => KlpConstrainedBox(
                constraints: KlpBoxConstraints(
                  minHeight: context.klp.space.controlHeightSmall,
                ),
                child: KlpBox(
                  insets: KlpBoxInsets.directional(
                    start: context.klp.space.controlInset,
                    top: context.klp.space.hairline,
                    end: context.klp.space.controlInset,
                    bottom: context.klp.space.hairline,
                  ),
                  child: KlpCenter(
                    child: KlpText(
                      addLabel,
                      role: KlpTextRole.caption,
                      color: style.foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (onClearAll != null)
          KlpActionRegion(
            label: clearAllLabel,
            onPressed: onClearAll,
            shape: KlpActionRegionShape.control,
            builder: (context, style) => KlpBox(
              insets: KlpBoxInsets.directional(
                start: context.klp.space.controlInset,
                top: context.klp.space.hairline,
                end: context.klp.space.controlInset,
                bottom: context.klp.space.hairline,
              ),
              child: KlpText(
                clearAllLabel,
                role: KlpTextRole.caption,
                color: style.foreground,
              ),
            ),
          ),
        ?trailing,
      ],
    );
  }
}
