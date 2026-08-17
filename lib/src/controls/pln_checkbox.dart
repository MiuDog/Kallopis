import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnCheckbox extends StatelessWidget {
  const PlnCheckbox({
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
    final tokens = context.plnTheme;
    final enabled = onChanged != null;
    final borderColor = enabled ? tokens.textMuted : tokens.textFaint;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
      child: Row(
        mainAxisSize: showLabel ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Semantics(
            checked: value,
            enabled: enabled,
            label: label,
            child: Material(
              color: const Color(0x00000000),
              borderRadius: BorderRadius.circular(PlnRadius.control),
              child: InkWell(
                onTap: enabled ? () => onChanged!(!value) : null,
                borderRadius: BorderRadius.circular(PlnRadius.control),
                child: AnimatedContainer(
                  duration: PlnMotion.styleTransition,
                  width: PlnFormMetrics.selectionControl,
                  height: PlnFormMetrics.selectionControl,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? tokens.selection : null,
                    border: value
                        ? null
                        : Border.all(color: borderColor, width: PlnLine.width),
                    borderRadius: BorderRadius.circular(PlnRadius.control),
                  ),
                  child: value
                      ? PlnIcon(
                          PlnIcons.check,
                          size: PlnFormMetrics.selectionIcon,
                          color: tokens.onSelection,
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: PlnSpace.sm),
            Expanded(
              child: PlnText(
                label,
                tone: enabled ? PlnTextTone.primary : PlnTextTone.faint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
