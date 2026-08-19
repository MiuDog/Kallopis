import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../interaction/klp_pressable.dart';
import '../surface/klp_dashed_border.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 篩選列選項。
@immutable
class KlpFilterOption {
  const KlpFilterOption({
    required this.id,
    required this.label,
    this.value,
    this.removable = false,
  });

  final String id;
  final String label;
  final String? value;
  final bool removable;
}

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
      spacing: klp.space.compact,
      runSpacing: klp.space.compact,
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
                  horizontal: klp.space.compact,
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
                horizontal: klp.space.compact,
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
          horizontal: klp.space.compact,
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
                  fontWeight: FontWeight.w700,
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

/// 選取工具列之操作動作。
@immutable
class KlpSelectionAction {
  const KlpSelectionAction({
    required this.id,
    required this.label,
    required this.onPressed,
    this.danger = false,
  });

  final String id;
  final String label;
  final VoidCallback? onPressed;
  final bool danger;
}

/// 批次選取浮動/固定操作列。
class KlpSelectionToolbar extends StatelessWidget {
  const KlpSelectionToolbar({
    super.key,
    required this.count,
    required this.countLabel,
    required this.actions,
    this.onClear,
    this.clearLabel = 'Clear',
    this.dashed = true,
  });

  final int count;
  final String countLabel;
  final List<KlpSelectionAction> actions;
  final VoidCallback? onClear;
  final String? clearLabel;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    Widget content = KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.base,
        vertical: klp.space.compact,
      ),
      child: Row(
        children: [
          KlpText(
            countLabel,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
          SizedBox(width: klp.space.base),
          for (final action in actions) ...[
            KlpButton(
              label: action.label,
              compact: true,
              tone: action.danger ? KlpButtonTone.danger : KlpButtonTone.ghost,
              onPressed: action.onPressed,
            ),
            SizedBox(width: klp.space.compact),
          ],
          const Spacer(),
          if (onClear != null && clearLabel != null)
            KlpPressable(
              onPressed: onClear,
              borderRadius: BorderRadius.circular(klp.shape.control),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: klp.space.compact,
                  vertical: klp.space.hairline,
                ),
                child: KlpText(
                  clearLabel!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ),
            ),
        ],
      ),
    );

    if (dashed) {
      content = KlpDashedBorder(radius: klp.shape.card, child: content);
    }

    return content;
  }
}

/// 鍵盤快捷鍵提示標籤。
class KlpShortcutHint extends StatelessWidget {
  const KlpShortcutHint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.muted,
      radius: context.klp.shape.control,
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.tight,
        vertical: context.klp.space.hairline,
      ),
      child: KlpText(label, role: KlpTextRole.code, tone: KlpTextTone.muted),
    );
  }
}

/// 協作者在線/連線狀態標記。
class KlpPresenceIndicator extends StatelessWidget {
  const KlpPresenceIndicator({
    super.key,
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active
        ? context.klpColors.success
        : context.klpColors.textFaint;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.klp.space.compact,
          height: context.klp.space.compact,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(context.klp.shape.pill),
          ),
        ),
        SizedBox(width: context.klp.space.tight),
        KlpText(label, role: KlpTextRole.caption, color: color),
      ],
    );
  }
}
