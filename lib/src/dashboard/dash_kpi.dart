import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'dash_theme.dart';

enum DashDeltaFormat { percent, absolute, compact }

enum DashSparklineMode { line, area, bar, winLoss }

enum DashDataTone { automatic, market, neutral, series }

class DashDeltaBadge extends StatelessWidget {
  const DashDeltaBadge({
    super.key,
    required this.value,
    this.format = DashDeltaFormat.percent,
    this.invertTone = false,
    this.contextLabel,
    this.compact = false,
    this.flatThreshold = 0,
  });

  final double value;
  final DashDeltaFormat format;
  final bool invertTone;
  final String? contextLabel;
  final bool compact;
  final double flatThreshold;

  @override
  Widget build(BuildContext context) {
    final dataTokens = context.plnDataVisualizationTheme;
    final direction = value.abs() <= flatThreshold
        ? 0
        : value.isNegative
        ? -1
        : 1;
    final effectiveDirection = invertTone ? -direction : direction;
    final color = switch (effectiveDirection) {
      > 0 => dataTokens.marketUp,
      < 0 => dataTokens.marketDown,
      _ => dataTokens.marketFlat,
    };
    final background = switch (effectiveDirection) {
      > 0 => dataTokens.marketUpWash,
      < 0 => dataTokens.marketDownWash,
      _ => context.plnTheme.surfaceInset,
    };
    final directionLabel = switch (direction) {
      > 0 => 'increased',
      < 0 => 'decreased',
      _ => 'unchanged',
    };

    return Semantics(
      label:
          '${_formattedValue()} $directionLabel${contextLabel == null ? '' : ', $contextLabel'}',
      child: ExcludeSemantics(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? PlnSpace.xs : PlnSpace.sm,
            vertical: PlnSpace.xxs,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(PlnRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlnText(_formattedValue(), role: PlnTextRole.code, color: color),
              if (!compact && contextLabel != null) ...[
                const SizedBox(width: PlnSpace.xs),
                // 數值一定要完整；擠不下時截斷的是脈絡文字。
                // 兩個都不可壓縮時，窄欄位裡的 badge 會直接溢出（2026-08-11）。
                Flexible(
                  child: PlnText(
                    contextLabel!,
                    role: PlnTextRole.caption,
                    color: color,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formattedValue() {
    final prefix = value > 0 ? '+' : '';
    return switch (format) {
      DashDeltaFormat.percent => '$prefix${(value * 100).toStringAsFixed(1)}%',
      DashDeltaFormat.absolute => '$prefix${value.toStringAsFixed(1)}',
      DashDeltaFormat.compact => '$prefix${_compactNumber(value)}',
    };
  }
}

class DashSparkline extends StatelessWidget {
  const DashSparkline({
    super.key,
    required this.values,
    this.mode = DashSparklineMode.line,
    this.width = 120,
    this.height = 36,
    this.colorIndex = 0,
    this.tone = DashDataTone.series,
    this.showLast = false,
    this.valueLabel,
    this.referenceBand,
    this.semanticsLabel,
  });

  final List<double> values;
  final DashSparklineMode mode;
  final double width;
  final double height;
  final int colorIndex;
  final DashDataTone tone;
  final bool showLast;
  final String? valueLabel;
  final (double, double)? referenceBand;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final dataTokens = context.plnDataVisualizationTheme;
    final lineColor = tone == DashDataTone.neutral
        ? dataTokens.value
        : dataTokens.seriesColor(colorIndex);
    final chart = SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DashSparklinePainter(
          values: values,
          mode: mode,
          lineColor: lineColor,
          washColor: dataTokens.seriesWashColor(colorIndex),
          marketUp: dataTokens.marketUp,
          marketDown: dataTokens.marketDown,
          gridColor: dataTokens.grid,
          referenceBand: referenceBand,
          showLast: showLast,
        ),
      ),
    );

    return Semantics(
      image: true,
      label:
          semanticsLabel ??
          'Trend with ${values.length} values${valueLabel == null ? '' : ', latest $valueLabel'}',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            chart,
            if (showLast && valueLabel != null) ...[
              const SizedBox(width: PlnSpace.xs),
              PlnText(valueLabel!, role: PlnTextRole.code),
            ],
          ],
        ),
      ),
    );
  }
}

class DashKpiTile extends StatelessWidget {
  const DashKpiTile({
    super.key,
    required this.label,
    required this.valueLabel,
    this.unitLabel,
    this.deltaValue,
    this.deltaFormat = DashDeltaFormat.percent,
    this.invertDeltaTone = false,
    this.comparisonLabel,
    this.trendValues = const [],
    this.trendMode = DashSparklineMode.line,
    this.targetLabel,
    this.targetProgress,
    this.footnote,
    this.loading = false,
    this.selected = false,
    this.colorIndex = 0,
    this.onSelect,
  });

  final String label;
  final String valueLabel;
  final String? unitLabel;
  final double? deltaValue;
  final DashDeltaFormat deltaFormat;
  final bool invertDeltaTone;
  final String? comparisonLabel;
  final List<double> trendValues;
  final DashSparklineMode trendMode;
  final String? targetLabel;
  final double? targetProgress;
  final String? footnote;
  final bool loading;
  final bool selected;
  final int colorIndex;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final content = AnimatedOpacity(
      duration: Duration.zero,
      opacity: loading ? 0.46 : 1,
      child: Container(
        padding: const EdgeInsets.all(PlnSpace.md),
        decoration: BoxDecoration(
          color: selected ? tokens.selectionBackground : tokens.component,
          borderRadius: BorderRadius.circular(PlnRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlnText(label, role: PlnTextRole.label, tone: PlnTextTone.muted),
            const SizedBox(height: PlnSpace.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: PlnText(
                    loading ? '—' : valueLabel,
                    role: PlnTextRole.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unitLabel != null) ...[
                  const SizedBox(width: PlnSpace.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: PlnSpace.xxs),
                    child: PlnText(
                      unitLabel!,
                      role: PlnTextRole.caption,
                      tone: PlnTextTone.muted,
                    ),
                  ),
                ],
              ],
            ),
            if (!loading && deltaValue != null) ...[
              const SizedBox(height: PlnSpace.sm),
              DashDeltaBadge(
                value: deltaValue!,
                format: deltaFormat,
                invertTone: invertDeltaTone,
                contextLabel: comparisonLabel,
              ),
            ],
            if (trendValues.isNotEmpty) ...[
              const SizedBox(height: PlnSpace.sm),
              LayoutBuilder(
                builder: (context, constraints) => DashSparkline(
                  values: trendValues,
                  mode: trendMode,
                  width: constraints.maxWidth,
                  height: 34,
                  colorIndex: colorIndex,
                ),
              ),
            ],
            if (targetProgress != null) ...[
              const SizedBox(height: PlnSpace.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(PlnRadius.sm),
                child: LinearProgressIndicator(
                  value: targetProgress!.clamp(0, 1),
                  minHeight: PlnSpace.xs,
                  backgroundColor: tokens.surfaceInset,
                  color: context.plnDataVisualizationTheme.seriesColor(
                    colorIndex,
                  ),
                ),
              ),
              if (targetLabel != null) ...[
                const SizedBox(height: PlnSpace.xs),
                PlnText(
                  targetLabel!,
                  role: PlnTextRole.caption,
                  tone: PlnTextTone.muted,
                ),
              ],
            ],
            if (footnote != null) ...[
              const SizedBox(height: PlnSpace.sm),
              PlnText(
                footnote!,
                role: PlnTextRole.caption,
                tone: PlnTextTone.faint,
              ),
            ],
          ],
        ),
      ),
    );
    return Semantics(
      button: onSelect != null,
      selected: selected,
      label: '$label, ${loading ? 'loading' : valueLabel}',
      child: onSelect == null
          ? content
          : PlnPressable(
              onPressed: loading ? null : onSelect,
              borderRadius: BorderRadius.circular(PlnRadius.card),
              child: content,
            ),
    );
  }
}

class _DashSparklinePainter extends CustomPainter {
  const _DashSparklinePainter({
    required this.values,
    required this.mode,
    required this.lineColor,
    required this.washColor,
    required this.marketUp,
    required this.marketDown,
    required this.gridColor,
    required this.referenceBand,
    required this.showLast,
  });

  final List<double> values;
  final DashSparklineMode mode;
  final Color lineColor;
  final Color washColor;
  final Color marketUp;
  final Color marketDown;
  final Color gridColor;
  final (double, double)? referenceBand;
  final bool showLast;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty || size.isEmpty) return;

    final minimum = values.reduce(math.min);
    final maximum = values.reduce(math.max);
    final range = math.max(maximum - minimum, 0.000001);
    final points = <Offset>[
      for (var index = 0; index < values.length; index++)
        Offset(
          values.length == 1
              ? size.width / 2
              : size.width * index / (values.length - 1),
          size.height - (values[index] - minimum) / range * size.height,
        ),
    ];

    if (referenceBand != null) {
      final low =
          size.height - (referenceBand!.$1 - minimum) / range * size.height;
      final high =
          size.height - (referenceBand!.$2 - minimum) / range * size.height;
      canvas.drawRect(
        Rect.fromLTRB(0, math.min(low, high), size.width, math.max(low, high)),
        Paint()..color = gridColor.withValues(alpha: 0.36),
      );
    }

    if (mode == DashSparklineMode.bar || mode == DashSparklineMode.winLoss) {
      final barWidth = math.max(1, size.width / values.length * 0.58);
      final zeroY = minimum < 0 && maximum > 0
          ? size.height - (0 - minimum) / range * size.height
          : size.height;
      for (var index = 0; index < values.length; index++) {
        final value = values[index];
        final valueY = mode == DashSparklineMode.winLoss
            ? value >= 0
                  ? size.height * 0.18
                  : size.height * 0.82
            : points[index].dy;
        final top = math.min(valueY, zeroY);
        final bottom = math.max(valueY, zeroY);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              points[index].dx - barWidth / 2,
              top,
              points[index].dx + barWidth / 2,
              math.max(top + 2, bottom),
            ),
            const Radius.circular(2),
          ),
          Paint()..color = value.isNegative ? marketDown : marketUp,
        );
      }
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    if (mode == DashSparklineMode.area) {
      final area = Path.from(path)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();
      canvas.drawPath(area, Paint()..color = washColor.withValues(alpha: 0.72));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 1.75
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (showLast) {
      canvas.drawCircle(points.last, 3, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _DashSparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.mode != mode ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.referenceBand != referenceBand ||
        oldDelegate.showLast != showLast;
  }
}

String _compactNumber(double value) {
  final magnitude = value.abs();
  if (magnitude >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (magnitude >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (magnitude >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
}
