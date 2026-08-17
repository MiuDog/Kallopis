import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpFilterOption {
  const KlpFilterOption({required this.id, required this.label});

  final String id;
  final String label;
}

class KlpFilterBar extends StatelessWidget {
  const KlpFilterBar({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onSelected,
    this.leading,
    this.trailing,
  });

  final List<KlpFilterOption> filters;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: KlpSpace.xs,
      runSpacing: KlpSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ?leading,
        for (final filter in filters)
          _KlpFilterChip(
            label: filter.label,
            selected: filter.id == selectedId,
            onPressed: () => onSelected(filter.id),
          ),
        ?trailing,
      ],
    );
  }
}

class _KlpFilterChip extends StatelessWidget {
  const _KlpFilterChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: KlpMotion.styleTransition,
        constraints: const BoxConstraints(minHeight: KlpSize.controlSmall),
        padding: const EdgeInsets.symmetric(horizontal: KlpSpace.sm),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : tokens.surfaceInset,
          borderRadius: BorderRadius.circular(KlpRadius.control),
        ),
        alignment: Alignment.center,
        child: KlpText(
          label,
          role: KlpTextRole.caption,
          color: selected ? tokens.onSelection : tokens.textMuted,
        ),
      ),
    );
  }
}

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

class KlpSelectionToolbar extends StatelessWidget {
  const KlpSelectionToolbar({
    super.key,
    required this.count,
    required this.countLabel,
    required this.actions,
    this.onClear,
    this.clearLabel,
  });

  final int count;
  final String countLabel;
  final List<KlpSelectionAction> actions;
  final VoidCallback? onClear;
  final String? clearLabel;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.sm),
      child: Wrap(
        spacing: KlpSpace.xs,
        runSpacing: KlpSpace.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          KlpText(countLabel, role: KlpTextRole.bodyStrong),
          for (final action in actions)
            KlpButton(
              label: action.label,
              compact: true,
              tone: action.danger
                  ? KlpButtonTone.danger
                  : KlpButtonTone.secondary,
              onPressed: action.onPressed,
            ),
          if (onClear != null && clearLabel != null)
            KlpButton(
              label: clearLabel!,
              compact: true,
              tone: KlpButtonTone.ghost,
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}

class KlpShortcutHint extends StatelessWidget {
  const KlpShortcutHint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.muted,
      radius: KlpRadius.control,
      padding: const EdgeInsets.symmetric(
        horizontal: KlpSpace.xs,
        vertical: KlpSpace.xxs,
      ),
      child: KlpText(label, role: KlpTextRole.code, tone: KlpTextTone.muted),
    );
  }
}

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
        ? context.plnTheme.success
        : context.plnTheme.textFaint;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: KlpSpace.sm,
          height: KlpSpace.sm,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(KlpRadius.full),
          ),
        ),
        const SizedBox(width: KlpSpace.xs),
        KlpText(label, role: KlpTextRole.caption, color: color),
      ],
    );
  }
}
