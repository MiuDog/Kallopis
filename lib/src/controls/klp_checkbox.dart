import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpCheckbox extends StatelessWidget {
  const KlpCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.showLabel = true,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final enabled = onChanged != null;
    final borderColor = enabled ? tokens.textMuted : tokens.textFaint;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
      child: Row(
        mainAxisSize: showLabel ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Semantics(
            checked: value,
            enabled: enabled,
            label: label,
            child: Material(
              color: const Color(0x00000000),
              borderRadius: BorderRadius.circular(KlpRadius.control),
              child: InkWell(
                onTap: enabled ? () => onChanged!(!value) : null,
                borderRadius: BorderRadius.circular(KlpRadius.control),
                child: AnimatedContainer(
                  duration: KlpMotion.styleTransition,
                  width: KlpFormMetrics.selectionControl,
                  height: KlpFormMetrics.selectionControl,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? tokens.selection : null,
                    border: value
                        ? null
                        : Border.all(color: borderColor, width: KlpLine.width),
                    borderRadius: BorderRadius.circular(KlpRadius.control),
                  ),
                  child: value
                      ? KlpIcon(
                          KlpIcons.check,
                          size: KlpFormMetrics.selectionIcon,
                          color: tokens.onSelection,
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: KlpSpace.sm),
            Expanded(
              child: KlpText(
                label,
                tone: enabled ? KlpTextTone.primary : KlpTextTone.faint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
