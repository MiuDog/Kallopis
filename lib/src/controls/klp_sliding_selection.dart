import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';

@immutable
class KlpSelectionOption {
  const KlpSelectionOption({required this.icon, required this.color});

  final String icon;
  final Color color;
}

class KlpSlidingSelection extends StatelessWidget {
  const KlpSlidingSelection({
    super.key,
    required this.label,
    required this.selectedIndex,
    required this.options,
    required this.onSelected,
  }) : assert(options.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < options.length);

  static const Duration animationDuration = Duration(milliseconds: 140);

  final String label;
  final int selectedIndex;
  final List<KlpSelectionOption> options;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final totalWidth = KlpFormMetrics.selectionControl * options.length;

    return Semantics(
      label: label,
      enabled: onSelected != null,
      child: SizedBox(
        width: totalWidth,
        height: KlpFormMetrics.selectionControl,
        child: Stack(
          children: [
            AnimatedPositioned(
              key: ValueKey('pln-selection-indicator-$label'),
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              left:
                  selectedIndex * KlpFormMetrics.selectionControl +
                  KlpFormMetrics.selectionIndicatorInset,
              top: KlpFormMetrics.selectionIndicatorInset,
              width: KlpFormMetrics.selectionIndicator,
              height: KlpFormMetrics.selectionIndicator,
              child: AnimatedContainer(
                duration: KlpMotion.styleTransition,
                decoration: BoxDecoration(
                  color: options[selectedIndex].color,
                  borderRadius: BorderRadius.circular(KlpRadius.sm - 1),
                ),
              ),
            ),
            Row(
              children: [
                for (var index = 0; index < options.length; index++)
                  SizedBox.square(
                    dimension: KlpFormMetrics.selectionControl,
                    child: Center(
                      child: KlpIcon(
                        options[index].icon,
                        size: KlpSize.iconSmall,
                        color: index == selectedIndex
                            ? KlpThemeContrast.foregroundFor(
                                options[selectedIndex].color,
                              )
                            : tokens.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                for (var index = 0; index < options.length; index++)
                  Material(
                    color: const Color(0x00000000),
                    borderRadius: BorderRadius.circular(KlpRadius.control),
                    child: InkWell(
                      key: ValueKey('pln-selection-hit-$label-$index'),
                      onTap: onSelected == null
                          ? null
                          : () => onSelected!(index),
                      borderRadius: BorderRadius.circular(KlpRadius.control),
                      child: const SizedBox.square(
                        dimension: KlpFormMetrics.selectionControl,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
