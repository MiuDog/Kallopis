import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../controls/klp_text_field.dart';
import '../data/klp_badge.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

@immutable
class KlpEntityResultData {
  const KlpEntityResultData({
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

class KlpEntityPicker extends StatelessWidget {
  const KlpEntityPicker({
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
  final List<KlpEntityResultData> results;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;
  final ValueChanged<int>? onResultSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.klp.space.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpText(title.toUpperCase(), role: KlpTextRole.label),
            SizedBox(height: context.klp.space.compact),
            KlpTextField(initialValue: initialQuery, onChanged: onQueryChanged),
            SizedBox(height: context.klp.space.compact),
            for (var index = 0; index < results.length; index++)
              _EntityResult(
                data: results[index],
                onPressed: onResultSelected == null
                    ? null
                    : () => onResultSelected!(index),
              ),
            SizedBox(height: context.klp.space.compact),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KlpButton(
                  label: 'Remove',
                  onPressed: onClear,
                  tone: KlpButtonTone.ghost,
                  compact: true,
                ),
                SizedBox(width: context.klp.space.compact),
                KlpButton(
                  label: 'Apply',
                  onPressed: onApply,
                  tone: KlpButtonTone.primary,
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

  final KlpEntityResultData data;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Material(
      color: data.selected ? tokens.surfaceMuted : KlpPalette.transparent,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.klp.space.tight,
            vertical: context.klp.space.tight,
          ),
          child: Row(
            children: [
              KlpBadge(label: data.kind),
              SizedBox(width: context.klp.space.tight),
              Expanded(child: KlpText(data.label)),
              if (data.trailing != null)
                KlpText(
                  data.trailing!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
