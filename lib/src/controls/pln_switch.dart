import 'package:flutter/widgets.dart';

import 'pln_toggle.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';

class PlnCompactSwitch extends StatelessWidget {
  const PlnCompactSwitch({
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
      child: PlnPressable(
        onPressed: enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(PlnRadius.full),
        child: SizedBox(
          width: 36,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: value ? tokens.selectionBackground : tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(PlnRadius.full),
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

typedef PlnSwitch = PlnToggle;
