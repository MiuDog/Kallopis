import 'package:flutter/widgets.dart';

import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'pln_sliding_selection.dart';

enum PlnTriState { off, mixed, on }

class PlnTriStateToggle extends StatelessWidget {
  const PlnTriStateToggle({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final PlnTriState value;
  final String label;
  final ValueChanged<PlnTriState>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlnSlidingSelection(
          label: label,
          selectedIndex: value.index,
          options: [
            PlnSelectionOption(icon: PlnIcons.x, color: tokens.danger),
            PlnSelectionOption(icon: PlnIcons.minus, color: tokens.textMuted),
            PlnSelectionOption(icon: PlnIcons.check, color: tokens.success),
          ],
          onSelected: onChanged == null
              ? null
              : (index) => onChanged!(PlnTriState.values[index]),
        ),
        const SizedBox(width: PlnSpace.sm),
        PlnText(
          label,
          tone: onChanged == null ? PlnTextTone.faint : PlnTextTone.primary,
        ),
      ],
    );
  }
}
