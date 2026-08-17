import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnSidebarSectionLabel extends StatelessWidget {
  const PlnSidebarSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: PlnSpace.xl,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: PlnSpace.xs),
          child: PlnText(
            label,
            role: PlnTextRole.label,
            tone: PlnTextTone.muted,
          ),
        ),
      ),
    );
  }
}

class PlnActionGroup extends StatelessWidget {
  const PlnActionGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: PlnSpace.xs,
      runSpacing: PlnSpace.xs,
      children: children,
    );
  }
}

class PlnPagination extends StatelessWidget {
  const PlnPagination({
    super.key,
    required this.page,
    required this.pageCount,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPageChanged,
  });

  final int page;
  final int pageCount;
  final String previousLabel;
  final String nextLabel;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlnButton(
          label: previousLabel,
          compact: true,
          onPressed: page <= 1 || onPageChanged == null
              ? null
              : () => onPageChanged!(page - 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: PlnSpace.sm),
          child: PlnText('$page / $pageCount', role: PlnTextRole.code),
        ),
        PlnButton(
          label: nextLabel,
          compact: true,
          onPressed: page >= pageCount || onPageChanged == null
              ? null
              : () => onPageChanged!(page + 1),
        ),
      ],
    );
  }
}

@immutable
class PlnViewOption {
  const PlnViewOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final Widget? icon;
}

class PlnViewSwitcher extends StatelessWidget {
  const PlnViewSwitcher({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<PlnViewOption> options;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.inset,
      radius: PlnRadius.control,
      padding: const EdgeInsets.all(PlnSpace.xxs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < options.length; index++) ...[
            _PlnViewChoice(
              option: options[index],
              selected: options[index].id == selectedId,
              onPressed: onSelected == null
                  ? null
                  : () => onSelected!(options[index].id),
            ),
            if (index < options.length - 1) const SizedBox(width: PlnSpace.xxs),
          ],
        ],
      ),
    );
  }
}

class _PlnViewChoice extends StatelessWidget {
  const _PlnViewChoice({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final PlnViewOption option;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: PlnSize.controlSmall),
        padding: const EdgeInsets.symmetric(horizontal: PlnSpace.sm),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : null,
          borderRadius: BorderRadius.circular(PlnRadius.control),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              option.icon!,
              const SizedBox(width: PlnSpace.xs),
            ],
            PlnText(
              option.label,
              role: PlnTextRole.caption,
              color: selected ? tokens.onSelection : tokens.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
