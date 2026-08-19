import 'package:flutter/widgets.dart';

import 'klp_toggle.dart';

import '../interaction/klp_pressable.dart';
import '../theme/klp_theme.dart';
import '../theme/klp_theme_scope.dart';

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
    final tokens = context.klpColors;
    final enabled = onChanged != null;

    return Semantics(
      button: true,
      checked: value,
      enabled: enabled,
      label: label,
      child: KlpPressable(
        onPressed: enabled ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(context.klp.shape.pill),
        child: SizedBox(
          width: context.klp.space.switchTrackWidth,
          height: context.klp.space.switchTrackHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: value ? tokens.selectionBackground : tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(context.klp.shape.pill),
            ),
            child: AnimatedAlign(
              duration: context.klp.motion.stateTransition,
              curve: Curves.easeOut,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(context.klp.space.space0_5),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: value
                        ? tokens.selectionForeground
                        : tokens.textFaint,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: context.klp.space.switchThumb,
                  ),
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
