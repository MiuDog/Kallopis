import 'package:flutter/widgets.dart';

import '../../foundation/klp_icon.dart';
import '../../foundation/klp_icons.dart';
import '../../interaction/klp_pressable.dart';
import '../../surface/klp_dashed_border.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';
import 'klp_filter_models.dart';

export 'klp_filter_models.dart';
export 'klp_presence_indicator.dart';
export 'klp_selection_toolbar.dart';
export 'klp_shortcut_hint.dart';

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
    final klp = context.klp;

    return Wrap(
      spacing: klp.space.contentInlineGap,
      runSpacing: klp.space.contentStackGap,
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
            radius: klp.shape.control,
            child: KlpPressable(
              onPressed: onAddFilter,
              borderRadius: BorderRadius.circular(klp.shape.control),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: klp.space.controlHeightSmall,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: klp.space.controlInset,
                  vertical: klp.space.hairline,
                ),
                alignment: Alignment.center,
                child: KlpText(
                  addLabel,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ),
            ),
          ),
        if (onClearAll != null)
          KlpPressable(
            onPressed: onClearAll,
            borderRadius: BorderRadius.circular(klp.shape.control),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: klp.space.controlInset,
                vertical: klp.space.hairline,
              ),
              child: KlpText(
                clearAllLabel,
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
            ),
          ),
        ?trailing,
      ],
    );
  }
}

class _KlpFilterChip extends StatelessWidget {
  const _KlpFilterChip({
    required this.label,
    this.value,
    required this.selected,
    required this.onPressed,
    this.onRemove,
  });

  final String label;
  final String? value;
  final bool selected;
  final VoidCallback onPressed;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: klp.motion.styleTransition,
        constraints: BoxConstraints(minHeight: klp.space.controlHeightSmall),
        padding: EdgeInsets.symmetric(
          horizontal: klp.space.controlInset,
          vertical: klp.space.hairline,
        ),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : tokens.surfaceInset,
          borderRadius: BorderRadius.circular(klp.shape.control),
          border: Border.all(color: tokens.divider, width: klp.shape.hairline),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpText(
              label,
              role: KlpTextRole.caption,
              color: selected ? tokens.onSelection : tokens.textMuted,
            ),
            if (value != null) ...[
              SizedBox(width: klp.space.tight),
              Text(
                value!,
                style: TextStyle(
                  fontFamily: klp.type.codeFamily,
                  fontFamilyFallback: klp.type.fallbackFor(klp.type.codeFamily),
                  fontWeight: context.klp.type.bold,
                  fontSize: klp.type.caption,
                  color: selected ? tokens.onSelection : tokens.text,
                ),
              ),
            ],
            if (onRemove != null) ...[
              SizedBox(width: klp.space.tight),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: KlpIcon(
                  KlpIcons.close,
                  size: klp.space.iconSmall,
                  color: selected ? tokens.onSelection : tokens.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
