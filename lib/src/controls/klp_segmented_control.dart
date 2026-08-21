import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpSegmentedControl extends StatelessWidget {
  const KlpSegmentedControl({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
    this.icons,
    this.itemKeys,
    this.expanded = false,
    this.dense = false,
  }) : assert(icons == null || icons.length == items.length),
       assert(itemKeys == null || itemKeys.length == items.length);

  final List<String> items;
  final int selected;
  final ValueChanged<int> onSelected;
  final List<String>? icons;
  final List<Key?>? itemKeys;
  final bool expanded;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Container(
      height: dense ? context.klp.geometry.control.segmentedDenseHeight : null,
      padding: EdgeInsets.all(
        dense
            ? context.klp.geometry.control.segmentedDenseInset
            : context.klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++)
            if (expanded)
              Expanded(
                child: _KlpSegment(
                  key: itemKeys?[index],
                  label: items[index],
                  icon: icons?[index],
                  selected: index == selected,
                  dense: dense,
                  onPressed: () => onSelected(index),
                ),
              )
            else
              _KlpSegment(
                key: itemKeys?[index],
                label: items[index],
                icon: icons?[index],
                selected: index == selected,
                dense: dense,
                onPressed: () => onSelected(index),
              ),
        ],
      ),
    );
  }
}

class _KlpSegment extends StatefulWidget {
  const _KlpSegment({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.dense,
    required this.onPressed,
  });

  final String label;
  final String? icon;
  final bool selected;
  final bool dense;
  final VoidCallback onPressed;

  @override
  State<_KlpSegment> createState() => _KlpSegmentState();
}

class _KlpSegmentState extends State<_KlpSegment> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final isHighlighted = widget.selected || _hovered;

    Widget segment = Material(
      color: klp.color.clear,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        overlayColor: WidgetStatePropertyAll(klp.color.clear),
        borderRadius: BorderRadius.circular(klp.shape.control),
        child: SizedBox(
          height: widget.dense
              ? klp.geometry.control.segmentedDenseItemHeight
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: klp.space.base,
              vertical: widget.dense ? 0 : klp.space.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  KlpIcon(
                    widget.icon!,
                    size: widget.dense ? klp.space.iconSmall : klp.space.icon,
                    color: widget.selected ? tokens.text : tokens.textMuted,
                  ),
                  SizedBox(width: klp.space.compact),
                ],
                Flexible(
                  child: KlpText(
                    widget.label,
                    role: widget.dense ? KlpTextRole.caption : KlpTextRole.body,
                    tone: widget.selected
                        ? KlpTextTone.primary
                        : KlpTextTone.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (isHighlighted) {
      segment = KlpDashedBorder(
        color: widget.selected ? tokens.textMuted : klp.hoverBorder,
        radius: klp.shape.control,
        child: segment,
      );
    }

    return Semantics(button: true, selected: widget.selected, child: segment);
  }
}
