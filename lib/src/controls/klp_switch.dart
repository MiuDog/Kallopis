import 'package:flutter/widgets.dart';

import 'klp_toggle.dart';

import '../foundation/klp_metrics.dart';
import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';

class KlpCompactSwitch extends StatelessWidget {
  const KlpCompactSwitch({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final enabled = onChanged != null;

    return Semantics(
      button: true,
      checked: value,
      enabled: enabled,
      label: label,
      child: KlpPressable(
        onPressed: enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(KlpRadius.full),
        child: SizedBox(
          width: 36,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: value ? tokens.selectionBackground : tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(KlpRadius.full),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: value
                        ? tokens.selectionForeground
                        : tokens.textFaint,
                    shape: BoxShape.circle,
                  ),
                  child: const SizedBox.square(dimension: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef KlpSwitch = KlpToggle;
