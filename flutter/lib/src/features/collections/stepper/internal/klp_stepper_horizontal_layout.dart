part of '../klp_stepper.dart';

class _KlpStepperHorizontalLayout extends StatelessWidget {
  const _KlpStepperHorizontalLayout({
    required this.steps,
    required this.currentIndex,
  });

  final List<KlpStepData> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final markerSize = klp.geometry.data.stepperMarkerSize;

    return KlpRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < steps.length; index++) ...[
          KlpColumn(
            mainAxisSize: MainAxisSize.min,
            children: [
              _KlpStepMarker(
                status: _resolveKlpStepStatus(index, currentIndex),
                index: index,
              ),
              KlpBox(height: klp.space.tight),
              KlpBox(
                width: klp.geometry.data.stepperLabelWidth,
                child: _KlpStepLabel(
                  step: steps[index],
                  status: _resolveKlpStepStatus(index, currentIndex),
                  direction: KlpStepperDirection.horizontal,
                ),
              ),
            ],
          ),
          if (index < steps.length - 1)
            KlpExpanded(
              child: KlpBox(
                height: markerSize,
                child: KlpCenter(
                  child: _KlpStepConnector(
                    completed:
                        _resolveKlpStepStatus(index, currentIndex) ==
                        KlpStepStatus.completed,
                    direction: KlpStepperDirection.horizontal,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
