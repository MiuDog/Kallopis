import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'dash_kpi.dart';
import '../theme/pln_data_visualization_theme.dart';

class DashChartFrame extends StatelessWidget {
  const DashChartFrame({
    super.key,
    required this.plot,
    required this.semanticsLabel,
    this.title,
    this.subtitle,
    this.legend,
    this.xAxisLabel,
    this.yAxisLabel,
    this.overlay,
    this.footer,
    this.selected = false,
    this.height = 280,
  });

  final Widget plot;
  final String semanticsLabel;
  final String? title;
  final String? subtitle;
  final Widget? legend;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final Widget? overlay;
  final Widget? footer;
  final bool selected;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final body = Container(
      height: height,
      padding: const EdgeInsets.all(PlnSpace.md),
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : tokens.component,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || subtitle != null || legend != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null || subtitle != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          PlnText(title!, role: PlnTextRole.bodyStrong),
                        if (subtitle != null)
                          PlnText(
                            subtitle!,
                            role: PlnTextRole.caption,
                            tone: PlnTextTone.muted,
                          ),
                      ],
                    ),
                  ),
                ?legend,
              ],
            ),
            const SizedBox(height: PlnSpace.md),
          ],
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (yAxisLabel != null) ...[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Center(
                      child: PlnText(
                        yAxisLabel!,
                        role: PlnTextRole.caption,
                        tone: PlnTextTone.faint,
                      ),
                    ),
                  ),
                  const SizedBox(width: PlnSpace.xs),
                ],
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [plot, ?overlay],
                  ),
                ),
              ],
            ),
          ),
          if (xAxisLabel != null) ...[
            const SizedBox(height: PlnSpace.xs),
            Center(
              child: PlnText(
                xAxisLabel!,
                role: PlnTextRole.caption,
                tone: PlnTextTone.faint,
              ),
            ),
          ],
          if (footer != null) ...[const SizedBox(height: PlnSpace.sm), footer!],
        ],
      ),
    );

    return Semantics(
      container: true,
      image: true,
      label: semanticsLabel,
      child: ExcludeSemantics(child: body),
    );
  }
}

class DashRangeBrush extends StatelessWidget {
  const DashRangeBrush({
    super.key,
    required this.values,
    required this.start,
    required this.end,
    this.onChanged,
    this.onReset,
    this.startLabel,
    this.endLabel,
    this.height = 48,
  }) : assert(start >= 0 && start <= 1),
       assert(end >= 0 && end <= 1),
       assert(start <= end);

  final List<double> values;
  final double start;
  final double end;
  final ValueChanged<RangeValues>? onChanged;
  final VoidCallback? onReset;
  final String? startLabel;
  final String? endLabel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final dataTokens = context.plnDataVisualizationTheme;

    return Semantics(
      slider: true,
      label: 'Visible chart range',
      value: '${startLabel ?? _percent(start)} to ${endLabel ?? _percent(end)}',
      onIncrease: onChanged == null
          ? null
          : () => onChanged!(RangeValues(start, (end + 0.05).clamp(0, 1))),
      onDecrease: onChanged == null
          ? null
          : () => onChanged!(RangeValues(start, (end - 0.05).clamp(start, 1))),
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final left = start * width;
              final right = end * width;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: onReset,
                onHorizontalDragUpdate: onChanged == null
                    ? null
                    : (details) {
                        final position = (details.localPosition.dx / width)
                            .clamp(0.0, 1.0);
                        if ((position - start).abs() <=
                            (position - end).abs()) {
                          onChanged!(RangeValues(position.clamp(0, end), end));
                        } else {
                          onChanged!(
                            RangeValues(start, position.clamp(start, 1)),
                          );
                        }
                      },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: PlnSpace.sm,
                      ),
                      child: DashSparkline(
                        values: values,
                        width: width,
                        height: height - PlnSpace.lg,
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DashRangePainter(
                          start: start,
                          end: end,
                          dimColor: tokens.app.withValues(alpha: 0.62),
                          selectionColor: dataTokens.seriesColor(0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: left - 3,
                      top: 0,
                      bottom: 0,
                      child: _DashBrushHandle(color: dataTokens.seriesColor(0)),
                    ),
                    Positioned(
                      left: right - 3,
                      top: 0,
                      bottom: 0,
                      child: _DashBrushHandle(color: dataTokens.seriesColor(0)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _percent(double value) => '${(value * 100).round()}%';
}

class _DashBrushHandle extends StatelessWidget {
  const _DashBrushHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 6,
        height: 28,
        decoration: BoxDecoration(
          color: context.plnTheme.component,
          border: Border.all(color: color, width: PlnLine.hairline),
          borderRadius: BorderRadius.circular(PlnRadius.sm),
        ),
      ),
    );
  }
}

class _DashRangePainter extends CustomPainter {
  const _DashRangePainter({
    required this.start,
    required this.end,
    required this.dimColor,
    required this.selectionColor,
  });

  final double start;
  final double end;
  final Color dimColor;
  final Color selectionColor;

  @override
  void paint(Canvas canvas, Size size) {
    final left = start * size.width;
    final right = end * size.width;
    canvas.drawRect(
      Rect.fromLTRB(0, 0, left, size.height),
      Paint()..color = dimColor,
    );
    canvas.drawRect(
      Rect.fromLTRB(right, 0, size.width, size.height),
      Paint()..color = dimColor,
    );
    canvas.drawRect(
      Rect.fromLTRB(left, 0, right, size.height),
      Paint()
        ..color = selectionColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = PlnLine.hairline,
    );
  }

  @override
  bool shouldRepaint(covariant _DashRangePainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.dimColor != dimColor ||
        oldDelegate.selectionColor != selectionColor;
  }
}
