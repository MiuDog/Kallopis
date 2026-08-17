import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';
import 'dash_theme.dart';

enum DashFillTreatment { solid, hatch, dot, outline }

class DashLegendItem {
  const DashLegendItem({
    required this.id,
    required this.label,
    this.colorIndex = 0,
    this.color,
    this.treatment = DashFillTreatment.solid,
    this.opacity = 1,
    this.hidden = false,
    this.valueLabel,
  });

  final String id;
  final String label;
  final int colorIndex;
  final Color? color;
  final DashFillTreatment treatment;
  final double opacity;
  final bool hidden;
  final String? valueLabel;
}

class DashChartLegend extends StatelessWidget {
  const DashChartLegend({
    super.key,
    required this.items,
    this.onToggle,
    this.layout = Axis.horizontal,
    this.compact = false,
  });

  final List<DashLegendItem> items;
  final ValueChanged<String>? onToggle;
  final Axis layout;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final item in items)
        _DashLegendEntry(
          item: item,
          compact: compact,
          onPressed: onToggle == null ? null : () => onToggle!(item.id),
        ),
    ];

    if (layout == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }

    return Wrap(
      spacing: PlnSpace.md,
      runSpacing: PlnSpace.xs,
      children: children,
    );
  }
}

class _DashLegendEntry extends StatelessWidget {
  const _DashLegendEntry({
    required this.item,
    required this.compact,
    this.onPressed,
  });

  final DashLegendItem item;
  final bool compact;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final dataTokens = context.plnDataVisualizationTheme;
    final color = (item.color ?? dataTokens.seriesColor(item.colorIndex))
        .withValues(alpha: item.hidden ? 0.24 : item.opacity.clamp(0, 1));
    final entry = Padding(
      padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 8 : 10,
            height: compact ? 8 : 10,
            decoration: BoxDecoration(
              color: item.treatment == DashFillTreatment.outline
                  ? const Color(0x00000000)
                  : color,
              border: Border.all(color: color, width: PlnLine.hairline),
              borderRadius: BorderRadius.circular(PlnRadius.sm),
            ),
          ),
          const SizedBox(width: PlnSpace.xs),
          PlnText(
            item.label,
            role: compact ? PlnTextRole.label : PlnTextRole.caption,
            color: item.hidden ? dataTokens.label.withValues(alpha: 0.5) : null,
          ),
          if (item.valueLabel != null) ...[
            const SizedBox(width: PlnSpace.xs),
            PlnText(
              item.valueLabel!,
              role: PlnTextRole.code,
              color: dataTokens.label,
            ),
          ],
        ],
      ),
    );

    return Semantics(
      button: onPressed != null,
      toggled: !item.hidden,
      child: onPressed == null
          ? entry
          : PlnPressable(
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(PlnRadius.control),
              child: entry,
            ),
    );
  }
}

class DashTooltipRow {
  const DashTooltipRow({
    required this.id,
    required this.label,
    required this.valueLabel,
    this.colorIndex = 0,
    this.color,
    this.muted = false,
  });

  final String id;
  final String label;
  final String valueLabel;
  final int colorIndex;
  final Color? color;
  final bool muted;
}

class DashChartTooltip extends StatelessWidget {
  const DashChartTooltip({
    super.key,
    required this.rows,
    this.title,
    this.footnote,
  });

  final String? title;
  final List<DashTooltipRow> rows;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final dataTokens = context.plnDataVisualizationTheme;

    return Semantics(
      container: true,
      label: title,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 260),
        padding: const EdgeInsets.all(PlnSpace.sm),
        decoration: BoxDecoration(
          color: tokens.overlay,
          borderRadius: BorderRadius.circular(PlnRadius.md),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              PlnText(title!, role: PlnTextRole.bodyStrong),
              const SizedBox(height: PlnSpace.xs),
            ],
            for (final row in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: PlnSpace.xxs),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color:
                            row.color ?? dataTokens.seriesColor(row.colorIndex),
                        borderRadius: BorderRadius.circular(PlnRadius.full),
                      ),
                    ),
                    const SizedBox(width: PlnSpace.xs),
                    Expanded(
                      child: PlnText(
                        row.label,
                        role: PlnTextRole.caption,
                        tone: row.muted ? PlnTextTone.faint : PlnTextTone.muted,
                      ),
                    ),
                    PlnText(
                      row.valueLabel,
                      role: PlnTextRole.code,
                      color: row.muted ? dataTokens.label : dataTokens.value,
                    ),
                  ],
                ),
              ),
            if (footnote != null) ...[
              const SizedBox(height: PlnSpace.xs),
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
  }
}
