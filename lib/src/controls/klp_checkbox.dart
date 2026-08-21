import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
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
    final activeColor = enabled ? tokens.text : tokens.textMuted;
    final inactiveBorderColor = enabled ? tokens.textMuted : tokens.textFaint;

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
              color: tokens.clear,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
              child: InkWell(
                onTap: enabled ? () => onChanged!(!value) : null,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
                child: AnimatedContainer(
                  duration: context.klp.motion.styleTransition,
                  width: context.klp.geometry.control.selectionControl,
                  height: context.klp.geometry.control.selectionControl,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: value ? activeColor : null,
                    border: Border.all(
                      color: value ? activeColor : inactiveBorderColor,
                      width: context.klp.shape.stroke,
                    ),
                    borderRadius: BorderRadius.circular(context.klp.shape.sm),
                  ),
                  child: value
                      ? KlpIcon(
                          KlpIcons.check,
                          size: context.klp.geometry.control.selectionIcon,
                          color: tokens.stageSurface,
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
