part of '../klp_phase_toggle.dart';

class _KlpPhaseToggleFrame extends StatelessWidget {
  const _KlpPhaseToggleFrame({
    required this.selectedIndex,
    required this.style,
    required this.children,
  });

  final int selectedIndex;
  final _KlpPhaseToggleStyle style;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: style.totalWidth,
      height: style.totalHeight,
      padding: style.padding,
      decoration: BoxDecoration(
        color: style.trackColor,
        borderRadius: BorderRadius.circular(style.trackRadius),
        border: style.border,
      ),
      child: Stack(
        children: [
          if (selectedIndex >= 0)
            AnimatedPositioned(
              duration: style.positionDuration,
              curve: style.positionCurve,
              left: selectedIndex * style.segmentExtent,
              top: 0,
              width: style.segmentExtent,
              height: style.segmentExtent,
              child: AnimatedContainer(
                duration: style.styleDuration,
                decoration: BoxDecoration(
                  color: style.activeBackground,
                  borderRadius: BorderRadius.circular(style.selectionRadius),
                ),
              ),
            ),
          Row(mainAxisSize: MainAxisSize.min, children: children),
        ],
      ),
    );
  }
}
