import 'package:flutter/material.dart';

import '../controls/pln_button.dart';
import '../controls/pln_text_field.dart';
import '../data/pln_badge.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnEntityResultData {
  const PlnEntityResultData({
    required this.kind,
    required this.label,
    this.trailing,
    this.selected = false,
  });

  final String kind;
  final String label;
  final String? trailing;
  final bool selected;
}

class PlnEntityPicker extends StatelessWidget {
  const PlnEntityPicker({
    super.key,
    required this.title,
    required this.initialQuery,
    required this.results,
    required this.onQueryChanged,
    required this.onClear,
    required this.onApply,
    this.onResultSelected,
  });

  final String title;
  final String initialQuery;
  final List<PlnEntityResultData> results;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;
  final ValueChanged<int>? onResultSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(PlnSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlnText(title.toUpperCase(), role: PlnTextRole.label),
            const SizedBox(height: PlnSpace.sm),
            PlnTextField(initialValue: initialQuery, onChanged: onQueryChanged),
            const SizedBox(height: PlnSpace.sm),
            for (var index = 0; index < results.length; index++)
              _EntityResult(
                data: results[index],
                onPressed: onResultSelected == null
                    ? null
                    : () => onResultSelected!(index),
              ),
            const SizedBox(height: PlnSpace.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PlnButton(
                  label: 'Remove',
                  onPressed: onClear,
                  tone: PlnButtonTone.ghost,
                  compact: true,
                ),
                const SizedBox(width: PlnSpace.sm),
                PlnButton(
                  label: 'Apply',
                  onPressed: onApply,
                  tone: PlnButtonTone.primary,
                  compact: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EntityResult extends StatelessWidget {
  const _EntityResult({required this.data, required this.onPressed});

  final PlnEntityResultData data;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Material(
      color: data.selected ? tokens.surfaceMuted : const Color(0x00000000),
      borderRadius: BorderRadius.circular(PlnRadius.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PlnSpace.xs,
            vertical: PlnSpace.xs,
          ),
          child: Row(
            children: [
              PlnBadge(label: data.kind),
              const SizedBox(width: PlnSpace.xs),
              Expanded(child: PlnText(data.label)),
              if (data.trailing != null)
                PlnText(
                  data.trailing!,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.faint,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
