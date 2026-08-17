import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnToggle extends StatelessWidget {
  const PlnToggle({
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
    final enabled = onChanged != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          enabled: enabled,
          label: label,
          toggled: value,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(PlnRadius.full),
            child: InkWell(
              onTap: enabled ? () => onChanged!(!value) : null,
              borderRadius: BorderRadius.circular(PlnRadius.full),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              child: PlnToggleIndicator(value: value, enabled: enabled),
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: PlnSpace.sm),
          PlnText(
            label,
            tone: enabled ? PlnTextTone.primary : PlnTextTone.faint,
          ),
        ],
      ],
    );
  }
}

class PlnToggleIndicator extends StatelessWidget {
  const PlnToggleIndicator({
    super.key,
    required this.value,
    this.enabled = true,
  });

  final bool value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final trackColor = !enabled
        ? tokens.component
        : value
        ? tokens.selection
        : tokens.surfaceMuted;
    final thumbColor = !enabled
        ? tokens.textFaint
        : value
        ? tokens.onSelection
        : tokens.textMuted;

    return ExcludeSemantics(
      child: SizedBox(
        width: PlnFormMetrics.toggleWidth,
        height: PlnFormMetrics.toggleHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(PlnRadius.full),
          ),
          child: Padding(
            padding: const EdgeInsets.all(PlnFormMetrics.toggleInset),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox.square(
                  dimension: PlnFormMetrics.toggleThumb,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
