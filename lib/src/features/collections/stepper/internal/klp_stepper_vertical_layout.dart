part of '../klp_stepper.dart';

class _KlpStepperVerticalLayout extends StatelessWidget {
  const _KlpStepperVerticalLayout({
    required this.steps,
    required this.currentIndex,
  });

  final List<KlpStepData> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final markerSize = klp.geometry.data.stepperMarkerSize;
    final textDefinition = KlpTextStyles.definitionOf(
      KlpTextRole.bodyStrong,
      klp.type,
    );
    final firstLineHeight = textDefinition.fontSize * textDefinition.lineHeight;
    final unresolvedLabelTopOffset = (markerSize - firstLineHeight) / 2;
    final labelTopOffset = unresolvedLabelTopOffset < klp.shape.none
        ? klp.shape.none
        : unresolvedLabelTopOffset;

    return KlpColumn(
      children: [
        for (var index = 0; index < steps.length; index++)
          _KlpStepperIntrinsicHeight(
            child: KlpRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpColumn(
                  children: [
                    _KlpStepMarker(
                      status: _resolveKlpStepStatus(index, currentIndex),
                      index: index,
                    ),
                    if (index < steps.length - 1)
                      KlpExpanded(
                        child: _KlpStepConnector(
                          completed:
                              _resolveKlpStepStatus(index, currentIndex) ==
                              KlpStepStatus.completed,
                          direction: KlpStepperDirection.vertical,
                        ),
                      ),
                  ],
                ),
                KlpBox(width: klp.space.contentInlineGap),
                KlpExpanded(
                  child: KlpBox(
                    insets: KlpBoxInsets.directional(
                      top: labelTopOffset,
                      bottom: klp.space.comfortable,
                    ),
                    child: _KlpStepLabel(
                      step: steps[index],
                      status: _resolveKlpStepStatus(index, currentIndex),
                      direction: KlpStepperDirection.vertical,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
