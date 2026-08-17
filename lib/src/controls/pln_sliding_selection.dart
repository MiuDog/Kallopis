import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';

@immutable
class PlnSelectionOption {
  const PlnSelectionOption({required this.icon, required this.color});

  final String icon;
  final Color color;
}

class PlnSlidingSelection extends StatelessWidget {
  const PlnSlidingSelection({
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
  final List<PlnSelectionOption> options;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final totalWidth = PlnFormMetrics.selectionControl * options.length;

    return Semantics(
      label: label,
      enabled: onSelected != null,
      child: SizedBox(
        width: totalWidth,
        height: PlnFormMetrics.selectionControl,
        child: Stack(
          children: [
            AnimatedPositioned(
              key: ValueKey('pln-selection-indicator-$label'),
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              left:
                  selectedIndex * PlnFormMetrics.selectionControl +
                  PlnFormMetrics.selectionIndicatorInset,
              top: PlnFormMetrics.selectionIndicatorInset,
              width: PlnFormMetrics.selectionIndicator,
              height: PlnFormMetrics.selectionIndicator,
              child: AnimatedContainer(
                duration: PlnMotion.styleTransition,
                decoration: BoxDecoration(
                  color: options[selectedIndex].color,
                  borderRadius: BorderRadius.circular(PlnRadius.sm - 1),
                ),
              ),
            ),
            Row(
              children: [
                for (var index = 0; index < options.length; index++)
                  SizedBox.square(
                    dimension: PlnFormMetrics.selectionControl,
                    child: Center(
                      child: PlnIcon(
                        options[index].icon,
                        size: PlnSize.iconSmall,
                        color: index == selectedIndex
                            ? PlnThemeContrast.foregroundFor(
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
                    borderRadius: BorderRadius.circular(PlnRadius.control),
                    child: InkWell(
                      key: ValueKey('pln-selection-hit-$label-$index'),
                      onTap: onSelected == null
                          ? null
                          : () => onSelected!(index),
                      borderRadius: BorderRadius.circular(PlnRadius.control),
                      child: const SizedBox.square(
                        dimension: PlnFormMetrics.selectionControl,
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
