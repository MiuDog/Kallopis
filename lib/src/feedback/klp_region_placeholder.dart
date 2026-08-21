import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../interaction/klp_pressable.dart';
import '../surface/klp_dashed_border.dart';
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
    this.minHeight,
    this.tone = KlpRegionPlaceholderTone.neutral,
    this.actionLabel,
    this.onAction,
  }) : assert(minHeight == null || minHeight >= 0),
       assert(
         actionLabel == null || onAction != null,
         'A visible Placeholder action must be invokable.',
       );

  final String label;
  final String kindLabel;
  final String? detail;
  final bool hatched;
  final double? minHeight;
  final KlpRegionPlaceholderTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final hatchColor = tokens.surfaceInset;
    final semanticLabel = [label, kindLabel, ?detail].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.klp.shape.card),
          border: Border.all(
            color: tokens.border,
            width: context.klp.shape.hairline,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.klp.shape.card),
          child: CustomPaint(
            painter: _KlpPlaceholderFillPainter(
              fillColor: hatched ? tokens.component : tokens.surfaceInset,
              hatchColor: hatchColor,
              hatched: hatched,
              hatchBand: context.klp.geometry.data.placeholderHatchBand,
              hatchGap: context.klp.geometry.data.placeholderHatchGap,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    minHeight ??
                    context.klp.geometry.data.placeholderMinimumHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.klp.space.containerPadding,
                  vertical:
                      context.klp.geometry.data.placeholderContentPaddingY,
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
                            SizedBox(width: context.klp.space.compact),
                            Flexible(
                              child: Text(
                                '${label.toUpperCase()} · ${kindLabel.toUpperCase()}',
                                textAlign: TextAlign.center,
                                style:
                                    KlpTextStyles.definitionOf(
                                          KlpTextRole.label,
                                          context.klp.type,
                                        )
                                        .toTextStyle(context.klp.type)
                                        .copyWith(
                                          color: tokens.textFaint,
                                          letterSpacing: context
                                              .klp
                                              .geometry
                                              .data
                                              .placeholderLabelTracking,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (detail != null) ...[
                        SizedBox(height: context.klp.space.tight),
                        ExcludeSemantics(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: context
                                  .klp
                                  .geometry
                                  .data
                                  .placeholderDetailMaximumWidth,
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
                        SizedBox(height: context.klp.space.tight * 2),
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
    final tokens = context.klpColors;
    Widget action = Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.klp.space.controlPaddingXSmall,
        vertical: context.klp.geometry.data.placeholderActionPaddingY,
      ),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
      ),
      child: ExcludeSemantics(
        child: Text(
          widget.label.toUpperCase(),
          style: KlpTextStyles.definitionOf(KlpTextRole.code, context.klp.type)
              .toTextStyle(context.klp.type)
              .copyWith(
                color: tokens.text,
                letterSpacing:
                    context.klp.geometry.data.placeholderLabelTracking,
              ),
        ),
      ),
    );

    if (_hovered) {
      action = KlpDashedBorder(
        color: context.klp.hoverBorder,
        radius: context.klp.shape.control,
        child: action,
      );
    }

    return Semantics(
      button: true,
      label: widget.label,
      child: Material(
        type: MaterialType.transparency,
        child: KlpPressable(
          onPressed: widget.onPressed,
          onHover: (hovered) => setState(() => _hovered = hovered),
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: action,
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
    final tokens = context.klpColors;
    return Transform.rotate(
      angle: math.pi / 4,
      child: Container(
        width: context.klp.space.indicatorDot,
        height: context.klp.space.indicatorDot,
        decoration: BoxDecoration(
          color: tone == KlpRegionPlaceholderTone.pending ? tokens.info : null,
          // 這是狀態字形，不是元件或 Surface 的可見框線。
          border: tone == KlpRegionPlaceholderTone.pending
              ? null
              : Border.fromBorderSide(
                  BorderSide(
                    color: tokens.textFaint,
                    width: context.klp.shape.hairline,
                  ),
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
    required this.hatchBand,
    required this.hatchGap,
  });

  final Color fillColor;
  final Color hatchColor;
  final bool hatched;
  final double hatchBand;
  final double hatchGap;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = fillColor);
    if (!hatched) {
      canvas.restore();
      return;
    }

    final strokeWidth = hatchBand;
    final step = (hatchBand + hatchGap) * math.sqrt2;
    final paint = Paint()
      ..color = hatchColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final extra = size.height + strokeWidth * 4;
    final startOffset = -size.height - strokeWidth * 4;
    final endOffset = size.width + size.height + strokeWidth * 4;

    for (var offset = startOffset; offset < endOffset; offset += step) {
      canvas.drawLine(
        Offset(offset - extra, -extra),
        Offset(offset + size.height + extra, size.height + extra),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KlpPlaceholderFillPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        hatchColor != oldDelegate.hatchColor ||
        hatched != oldDelegate.hatched ||
        hatchBand != oldDelegate.hatchBand ||
        hatchGap != oldDelegate.hatchGap;
  }
}
