import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  test('既有 theme constructor 參數集合仍可編譯', () {
    const shape = KlpShapeTheme(
      none: 0,
      control: 8,
      card: 8,
      panel: 16,
      pill: 9999,
      hairline: 1,
      stroke: 2,
      dashedLength: 3,
      dashedGap: 2,
      dashedOpacity: 0.78,
    );
    const motion = KlpMotionTheme(
      themeTransition: Duration.zero,
      styleTransition: Duration.zero,
      stateTransition: Duration(milliseconds: 140),
      overlayEnter: Duration(milliseconds: 140),
      overlayExit: Duration(milliseconds: 120),
      toastDwell: Duration(milliseconds: 500),
      tooltipDelay: Duration(milliseconds: 450),
      longPressThreshold: Duration(milliseconds: 500),
      standard: Curves.ease,
      emphasized: Curves.easeInOut,
    );
    const surface = KlpSurfaceTheme(
      separation: KlpSurfaceSeparation.shadow,
      overlayBlur: 18,
      overlaySpread: 1,
      overlayOffsetY: 8,
      overlayShadowOpacity: 0.22,
      scrimOpacity: 0.6,
      selectionWashOpacity: 0.1,
      statusFillOpacity: 0.16,
      pressProgressOpacity: 0.55,
      diffFillOpacity: 0.12,
      gridLineOpacity: 0.18,
      veilOpacity: 0.82,
      statusRowOpacity: 0.14,
      statusRowSelectedOpacity: 0.32,
      statusRowOpacityDark: 0.28,
      statusRowSelectedOpacityDark: 0.48,
      frostedOpacity: 0.14,
      frostedVeilOpacity: 0.12,
    );

    expect(shape.controlInner, 7);
    expect(motion.spinnerCycle, const Duration(milliseconds: 1000));
    expect(surface.backdropBlurSigma, 12);
  });
}
