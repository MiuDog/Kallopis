import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnFilterOption {
  const PlnFilterOption({required this.id, required this.label});

  final String id;
  final String label;
}

class PlnFilterBar extends StatelessWidget {
  const PlnFilterBar({
    super.key,
    required this.filters,
    required this.selectedId,
    required this.onSelected,
    this.leading,
    this.trailing,
  });

  final List<PlnFilterOption> filters;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PlnSpace.xs,
      runSpacing: PlnSpace.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ?leading,
        for (final filter in filters)
          _PlnFilterChip(
            label: filter.label,
            selected: filter.id == selectedId,
            onPressed: () => onSelected(filter.id),
          ),
        ?trailing,
      ],
    );
  }
}

class _PlnFilterChip extends StatelessWidget {
  const _PlnFilterChip({
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
        duration: PlnMotion.styleTransition,
        constraints: const BoxConstraints(minHeight: PlnSize.controlSmall),
        padding: const EdgeInsets.symmetric(horizontal: PlnSpace.sm),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : tokens.surfaceInset,
          borderRadius: BorderRadius.circular(PlnRadius.control),
        ),
        alignment: Alignment.center,
        child: PlnText(
          label,
          role: PlnTextRole.caption,
          color: selected ? tokens.onSelection : tokens.textMuted,
        ),
      ),
    );
  }
}

@immutable
class PlnSelectionAction {
  const PlnSelectionAction({
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

class PlnSelectionToolbar extends StatelessWidget {
  const PlnSelectionToolbar({
    super.key,
    required this.count,
    required this.countLabel,
    required this.actions,
    this.onClear,
    this.clearLabel,
  });

  final int count;
  final String countLabel;
  final List<PlnSelectionAction> actions;
  final VoidCallback? onClear;
  final String? clearLabel;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.sm),
      child: Wrap(
        spacing: PlnSpace.xs,
        runSpacing: PlnSpace.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          PlnText(countLabel, role: PlnTextRole.bodyStrong),
          for (final action in actions)
            PlnButton(
              label: action.label,
              compact: true,
              tone: action.danger
                  ? PlnButtonTone.danger
                  : PlnButtonTone.secondary,
              onPressed: action.onPressed,
            ),
          if (onClear != null && clearLabel != null)
            PlnButton(
              label: clearLabel!,
              compact: true,
              tone: PlnButtonTone.ghost,
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}

class PlnShortcutHint extends StatelessWidget {
  const PlnShortcutHint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.muted,
      radius: PlnRadius.control,
      padding: const EdgeInsets.symmetric(
        horizontal: PlnSpace.xs,
        vertical: PlnSpace.xxs,
      ),
      child: PlnText(label, role: PlnTextRole.code, tone: PlnTextTone.muted),
    );
  }
}

class PlnPresenceIndicator extends StatelessWidget {
  const PlnPresenceIndicator({
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
          width: PlnSpace.sm,
          height: PlnSpace.sm,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(PlnRadius.full),
          ),
        ),
        const SizedBox(width: PlnSpace.xs),
        PlnText(label, role: PlnTextRole.caption, color: color),
      ],
    );
  }
}
