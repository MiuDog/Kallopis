import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpSidebarSectionLabel extends StatelessWidget {
  const KlpSidebarSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.loose,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: context.klp.space.tight),
          child: KlpText(
            label,
            role: KlpTextRole.label,
            tone: KlpTextTone.muted,
          ),
        ),
      ),
    );
  }
}

class KlpActionGroup extends StatelessWidget {
  const KlpActionGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.klp.space.tight,
      runSpacing: context.klp.space.tight,
      children: children,
    );
  }
}

class KlpPagination extends StatelessWidget {
  const KlpPagination({
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
        KlpButton(
          label: previousLabel,
          compact: true,
          onPressed: page <= 1 || onPageChanged == null
              ? null
              : () => onPageChanged!(page - 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
          child: KlpText('$page / $pageCount', role: KlpTextRole.code),
        ),
        KlpButton(
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
class KlpViewOption {
  const KlpViewOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final Widget? icon;
}

class KlpViewSwitcher extends StatelessWidget {
  const KlpViewSwitcher({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<KlpViewOption> options;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.inset,
      radius: context.klp.shape.control,
      padding: EdgeInsets.all(context.klp.space.hairline),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < options.length; index++) ...[
            _KlpViewChoice(
              option: options[index],
              selected: options[index].id == selectedId,
              onPressed: onSelected == null
                  ? null
                  : () => onSelected!(options[index].id),
            ),
            if (index < options.length - 1) SizedBox(width: context.klp.space.hairline),
          ],
        ],
      ),
    );
  }
}

class _KlpViewChoice extends StatelessWidget {
  const _KlpViewChoice({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final KlpViewOption option;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(minHeight: context.klp.space.controlHeightSmall),
        padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : null,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              option.icon!,
              SizedBox(width: context.klp.space.tight),
            ],
            KlpText(
              option.label,
              role: KlpTextRole.caption,
              color: selected ? tokens.onSelection : tokens.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
