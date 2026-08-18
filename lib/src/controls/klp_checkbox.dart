import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import '../foundation/klp_palette.dart';

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
      padding: EdgeInsets.symmetric(vertical: context.klp.space.tight),
      child: Row(
        mainAxisSize: showLabel ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Semantics(
            checked: value,
            enabled: enabled,
            label: label,
            child: Material(
              color: KlpPalette.transparent,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
              child: InkWell(
                onTap: enabled ? () => onChanged!(!value) : null,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
                child: AnimatedContainer(
                  duration: context.klp.motion.styleTransition,
                  width: KlpFormMetrics.selectionControl,
                  height: KlpFormMetrics.selectionControl,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? tokens.selection : null,
                    border: value
                        ? null
                        : Border.all(color: borderColor, width: context.klp.shape.stroke),
                    borderRadius: BorderRadius.circular(context.klp.shape.control),
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
            SizedBox(width: context.klp.space.compact),
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
