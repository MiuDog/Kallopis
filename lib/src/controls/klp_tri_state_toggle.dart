import 'package:flutter/widgets.dart';

import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_sliding_selection.dart';

enum KlpTriState { off, mixed, on }

class KlpTriStateToggle extends StatelessWidget {
  const KlpTriStateToggle({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final KlpTriState value;
  final String label;
  final ValueChanged<KlpTriState>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpSlidingSelection(
          label: label,
          selectedIndex: value.index,
          options: [
            KlpSelectionOption(icon: KlpIcons.x, color: tokens.danger),
            KlpSelectionOption(icon: KlpIcons.minus, color: tokens.textMuted),
            KlpSelectionOption(icon: KlpIcons.check, color: tokens.success),
          ],
          onSelected: onChanged == null
              ? null
              : (index) => onChanged!(KlpTriState.values[index]),
        ),
        const SizedBox(width: KlpSpace.sm),
        KlpText(
          label,
          tone: onChanged == null ? KlpTextTone.faint : KlpTextTone.primary,
        ),
      ],
    );
  }
}
