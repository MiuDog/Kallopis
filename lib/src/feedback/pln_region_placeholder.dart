import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../surface/pln_stroke.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

enum PlnRegionPlaceholderTone { neutral, pending }

class PlnRegionPlaceholder extends StatelessWidget {
  const PlnRegionPlaceholder({
    super.key,
    required this.label,
    required this.kindLabel,
    this.detail,
    this.hatched = true,
    this.minHeight = PlnPlaceholderMetrics.minimumHeight,
    this.tone = PlnRegionPlaceholderTone.neutral,
    this.actionLabel,
    this.onAction,
  }) : assert(minHeight >= 0),
       assert(
         actionLabel == null || onAction != null,
         'A visible Placeholder action must be invokable.',
       );

  final String label;
  final String kindLabel;
  final String? detail;
  final bool hatched;
  final double minHeight;
  final PlnRegionPlaceholderTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final hatchColor = darkMode
        ? Color.lerp(
            tokens.app,
            tokens.surfaceInset,
            PlnPlaceholderMetrics.darkHatchColorMix,
          )!
        : tokens.surfaceInset;
    final semanticLabel = [label, kindLabel, ?detail].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: PlnStrokeFrame(
        role: PlnStrokeRole.latent,
        radius: PlnRadius.card,
        opacity: PlnPlaceholderMetrics.latentStrokeOpacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PlnRadius.card),
          child: CustomPaint(
            painter: _PlnPlaceholderFillPainter(
              fillColor: hatched
                  ? tokens.app.withValues(alpha: 0)
                  : tokens.surfaceInset,
              hatchColor: hatchColor,
              hatched: hatched,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: minHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PlnPlaceholderMetrics.contentPaddingHorizontal,
                  vertical: PlnPlaceholderMetrics.contentPaddingVertical,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PlaceholderMarker(tone: tone),
                            const SizedBox(width: PlnSpace.sm),
                            Flexible(
                              child: Text(
                                '${label.toUpperCase()} · ${kindLabel.toUpperCase()}',
                                textAlign: TextAlign.center,
                                style:
                                    PlnTextStyles.definitionOf(
                                      PlnTextRole.code,
                                    ).toTextStyle().copyWith(
                                      color: tokens.textFaint,
                                      letterSpacing: PlnPlaceholderMetrics
                                          .labelLetterSpacing,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (detail != null) ...[
                        const SizedBox(
                          height: PlnPlaceholderMetrics.contentGap,
                        ),
                        ExcludeSemantics(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  PlnPlaceholderMetrics.detailMaximumWidth,
                            ),
                            child: PlnText(
                              detail!,
                              role: PlnTextRole.caption,
                              tone: PlnTextTone.muted,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                      if (actionLabel != null) ...[
                        const SizedBox(
                          height:
                              PlnPlaceholderMetrics.contentGap +
                              PlnPlaceholderMetrics.actionLeadingGap,
                        ),
                        _PlaceholderAction(
                          label: actionLabel!,
                          onPressed: onAction,
                        ),
                      ],
                    ],
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

class _PlaceholderAction extends StatefulWidget {
  const _PlaceholderAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  State<_PlaceholderAction> createState() => _PlaceholderActionState();
}

class _PlaceholderActionState extends State<_PlaceholderAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    return Semantics(
      button: true,
      label: widget.label,
      child: Material(
        type: MaterialType.transparency,
        child: PlnPressable(
          onPressed: widget.onPressed,
          onHover: (hovered) => setState(() => _hovered = hovered),
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PlnPlaceholderMetrics.actionPaddingHorizontal,
              vertical: PlnPlaceholderMetrics.actionPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: _hovered ? tokens.hoverSurface : tokens.surface,
              borderRadius: BorderRadius.circular(PlnRadius.control),
            ),
            child: ExcludeSemantics(
              child: Text(
                widget.label.toUpperCase(),
                style: PlnTextStyles.definitionOf(PlnTextRole.code)
                    .toTextStyle()
                    .copyWith(
                      color: tokens.text,
                      letterSpacing: PlnPlaceholderMetrics.labelLetterSpacing,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderMarker extends StatelessWidget {
  const _PlaceholderMarker({required this.tone});

  final PlnRegionPlaceholderTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: PlnPlaceholderMetrics.markerSize,
        height: PlnPlaceholderMetrics.markerSize,
        decoration: BoxDecoration(
          color: tone == PlnRegionPlaceholderTone.pending
              ? tokens.info
              : tokens.app.withValues(alpha: 0),
          // 這是狀態字形，不是元件或 Surface 的可見框線。
          border: tone == PlnRegionPlaceholderTone.pending
              ? null
              : Border.fromBorderSide(
                  BorderSide(color: tokens.textFaint, width: PlnLine.hairline),
                ),
        ),
      ),
    );
  }
}

class _PlnPlaceholderFillPainter extends CustomPainter {
  const _PlnPlaceholderFillPainter({
    required this.fillColor,
    required this.hatchColor,
    required this.hatched,
  });

  final Color fillColor;
  final Color hatchColor;
  final bool hatched;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = fillColor);
    if (!hatched) return;

    final step =
        PlnPlaceholderMetrics.hatchBand + PlnPlaceholderMetrics.hatchGap;
    final paint = Paint()
      ..color = hatchColor
      ..strokeWidth = PlnPlaceholderMetrics.hatchStrokeWidth;
    for (var offset = -size.height; offset < size.width; offset += step) {
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PlnPlaceholderFillPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        hatchColor != oldDelegate.hatchColor ||
        hatched != oldDelegate.hatched;
  }
}
