import 'package:flutter/material.dart';

import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

enum DashGridGap { tight, standard, loose }

class DashDashboardGrid extends StatelessWidget {
  const DashDashboardGrid({
    super.key,
    required this.children,
    this.columns = 12,
    this.gap = DashGridGap.standard,
    this.minColumnWidth = 120,
  });

  final List<Widget> children;
  final int columns;
  final DashGridGap gap;
  final double minColumnWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = switch (gap) {
          DashGridGap.tight => PlnSpace.xs,
          DashGridGap.standard => PlnLayoutGap.lg,
          DashGridGap.loose => PlnSpace.lg,
        };
        final requestedColumns = columns.clamp(1, 24);
        final availableColumns = constraints.maxWidth.isFinite
            ? ((constraints.maxWidth + spacing) / (minColumnWidth + spacing))
                  .floor()
                  .clamp(1, requestedColumns)
            : requestedColumns;
        final columnWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - spacing * (availableColumns - 1)) /
                  availableColumns
            : minColumnWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              _DashboardGridCell(
                columnWidth: columnWidth,
                columns: availableColumns,
                spacing: spacing,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class DashGridItem extends StatelessWidget {
  const DashGridItem({
    super.key,
    required this.child,
    this.span = 1,
    this.rowSpan = 1,
  });

  final Widget child;
  final int span;
  final int rowSpan;

  @override
  Widget build(BuildContext context) => child;
}

class _DashboardGridCell extends StatelessWidget {
  const _DashboardGridCell({
    required this.child,
    required this.columnWidth,
    required this.columns,
    required this.spacing,
  });

  final Widget child;
  final double columnWidth;
  final int columns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final gridItem = child is DashGridItem ? child as DashGridItem : null;
    final span = (gridItem?.span ?? 1).clamp(1, columns);
    final rowSpan = (gridItem?.rowSpan ?? 1).clamp(1, 12);
    final width = columnWidth * span + spacing * (span - 1);
    final content = gridItem?.child ?? child;

    return SizedBox(
      width: width,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: rowSpan * 72),
        child: content,
      ),
    );
  }
}

class DashPanel extends StatelessWidget {
  const DashPanel({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.footer,
    this.selected = false,
    this.onPressed,
    this.padding = const EdgeInsets.all(PlnSpace.md),
    this.semanticsLabel,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? footer;
  final bool selected;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final body = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: selected ? tokens.selectionBackground : tokens.surface,
        borderRadius: BorderRadius.circular(PlnRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || subtitle != null || trailing != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ?trailing,
              ],
            ),
            const SizedBox(height: PlnSpace.md),
          ],
          child,
          if (footer != null) const SizedBox(height: PlnSpace.md),
          ?footer,
        ],
      ),
    );
    return Semantics(
      label: semanticsLabel,
      button: onPressed != null,
      selected: selected,
      child: onPressed == null
          ? body
          : PlnPressable(
              onPressed: onPressed,
              borderRadius: BorderRadius.circular(PlnRadius.card),
              child: body,
            ),
    );
  }
}
