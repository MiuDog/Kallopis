import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
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

  final String label;
  final int selectedIndex;
  final List<KlpSelectionOption> options;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final controlHeight = klp.space.controlHeightSmall;
    final segmentWidth = controlHeight * 1.15;
    final padding = klp.space.hairline * 2;
    final borderWidth = klp.shape.hairline;
    final totalWidth =
        segmentWidth * options.length + padding * 2 + borderWidth * 2;
    final indicatorHeight = controlHeight - padding * 2 - borderWidth * 2;

    return Semantics(
      label: label,
      enabled: onSelected != null,
      child: Container(
        width: totalWidth,
        height: controlHeight,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: tokens.surfaceInset,
          borderRadius: BorderRadius.circular(klp.shape.control),
          border: Border.all(color: tokens.divider, width: klp.shape.hairline),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              key: ValueKey('pln-selection-indicator-$label'),
              duration: klp.motion.stateTransition,
              curve: Curves.easeOutCubic,
              left: selectedIndex * segmentWidth,
              top: 0,
              width: segmentWidth,
              height: indicatorHeight,
              child: AnimatedContainer(
                duration: klp.motion.styleTransition,
                decoration: BoxDecoration(
                  color: options[selectedIndex].color.withValues(
                    alpha: klp.surface.statusFillOpacity,
                  ),
                  borderRadius: BorderRadius.circular(klp.shape.control - 1),
                  border: Border.all(
                    color: options[selectedIndex].color,
                    width: klp.shape.hairline,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < options.length; index++)
                  SizedBox(
                    width: segmentWidth,
                    height: indicatorHeight,
                    child: Center(
                      child: KlpIcon(
                        options[index].icon,
                        size: klp.space.iconSmall,
                        color: index == selectedIndex
                            ? options[index].color
                            : tokens.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < options.length; index++)
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(klp.shape.control - 1),
                    child: InkWell(
                      key: ValueKey('pln-selection-hit-$label-$index'),
                      onTap: onSelected == null
                          ? null
                          : () => onSelected!(index),
                      borderRadius: BorderRadius.circular(
                        klp.shape.control - 1,
                      ),
                      child: SizedBox(
                        width: segmentWidth,
                        height: indicatorHeight,
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
