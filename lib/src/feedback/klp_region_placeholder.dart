import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../foundation/klp_metrics.dart';
import '../interaction/klp_pressable.dart';
import '../surface/klp_stroke.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpRegionPlaceholderTone { neutral, pending }

class KlpRegionPlaceholder extends StatelessWidget {
  const KlpRegionPlaceholder({
    super.key,
    required this.label,
    required this.kindLabel,
    this.detail,
    this.hatched = true,
    this.minHeight = KlpPlaceholderMetrics.minimumHeight,
    this.tone = KlpRegionPlaceholderTone.neutral,
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
  final KlpRegionPlaceholderTone tone;
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
            KlpPlaceholderMetrics.darkHatchColorMix,
          )!
        : tokens.surfaceInset;
    final semanticLabel = [label, kindLabel, ?detail].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: KlpStrokeFrame(
        role: KlpStrokeRole.latent,
        radius: KlpRadius.card,
        opacity: KlpPlaceholderMetrics.latentStrokeOpacity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(KlpRadius.card),
          child: CustomPaint(
            painter: _KlpPlaceholderFillPainter(
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
                  horizontal: KlpPlaceholderMetrics.contentPaddingHorizontal,
                  vertical: KlpPlaceholderMetrics.contentPaddingVertical,
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
                            const SizedBox(width: KlpSpace.sm),
                            Flexible(
                              child: Text(
                                '${label.toUpperCase()} · ${kindLabel.toUpperCase()}',
                                textAlign: TextAlign.center,
                                style:
                                    KlpTextStyles.definitionOf(
                                      KlpTextRole.code,
                                    ).toTextStyle().copyWith(
                                      color: tokens.textFaint,
                                      letterSpacing: KlpPlaceholderMetrics
                                          .labelLetterSpacing,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (detail != null) ...[
                        const SizedBox(
                          height: KlpPlaceholderMetrics.contentGap,
                        ),
                        ExcludeSemantics(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth:
                                  KlpPlaceholderMetrics.detailMaximumWidth,
                            ),
                            child: KlpText(
                              detail!,
                              role: KlpTextRole.caption,
                              tone: KlpTextTone.muted,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                      if (actionLabel != null) ...[
                        const SizedBox(
                          height:
                              KlpPlaceholderMetrics.contentGap +
                              KlpPlaceholderMetrics.actionLeadingGap,
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
        child: KlpPressable(
          onPressed: widget.onPressed,
          onHover: (hovered) => setState(() => _hovered = hovered),
          borderRadius: BorderRadius.circular(KlpRadius.control),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: KlpPlaceholderMetrics.actionPaddingHorizontal,
              vertical: KlpPlaceholderMetrics.actionPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: _hovered ? tokens.hoverSurface : tokens.surface,
              borderRadius: BorderRadius.circular(KlpRadius.control),
            ),
            child: ExcludeSemantics(
              child: Text(
                widget.label.toUpperCase(),
                style: KlpTextStyles.definitionOf(KlpTextRole.code)
                    .toTextStyle()
                    .copyWith(
                      color: tokens.text,
                      letterSpacing: KlpPlaceholderMetrics.labelLetterSpacing,
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

  final KlpRegionPlaceholderTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: KlpPlaceholderMetrics.markerSize,
        height: KlpPlaceholderMetrics.markerSize,
        decoration: BoxDecoration(
          color: tone == KlpRegionPlaceholderTone.pending
              ? tokens.info
              : tokens.app.withValues(alpha: 0),
          // 這是狀態字形，不是元件或 Surface 的可見框線。
          border: tone == KlpRegionPlaceholderTone.pending
              ? null
              : Border.fromBorderSide(
                  BorderSide(color: tokens.textFaint, width: KlpLine.hairline),
                ),
        ),
      ),
    );
  }
}

class _KlpPlaceholderFillPainter extends CustomPainter {
  const _KlpPlaceholderFillPainter({
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
        KlpPlaceholderMetrics.hatchBand + KlpPlaceholderMetrics.hatchGap;
    final paint = Paint()
      ..color = hatchColor
      ..strokeWidth = KlpPlaceholderMetrics.hatchStrokeWidth;
    for (var offset = -size.height; offset < size.width; offset += step) {
      canvas.drawLine(
        Offset(offset, 0),
        Offset(offset + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _KlpPlaceholderFillPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        hatchColor != oldDelegate.hatchColor ||
        hatched != oldDelegate.hatched;
  }
}
