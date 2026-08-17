import 'package:flutter/widgets.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_dashed_border.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

enum PlnDiffKind { add, remove, context, conflict }

@immutable
class PlnDiffRowData {
  const PlnDiffRowData({
    required this.line,
    required this.content,
    this.kind = PlnDiffKind.context,
  });

  final String line;
  final String content;
  final PlnDiffKind kind;
}

@immutable
class PlnDiffLineData {
  const PlnDiffLineData({
    required this.content,
    this.beforeLine,
    this.afterLine,
    this.kind = PlnDiffKind.context,
    this.changeId,
  });

  final int? beforeLine;
  final int? afterLine;
  final String content;
  final PlnDiffKind kind;
  final String? changeId;
}

class PlnDiffViewer extends StatelessWidget {
  const PlnDiffViewer({
    super.key,
    required this.lines,
    this.title,
    this.selectedChangeId,
    this.granular = false,
    this.maxHeight = 340,
    this.onSelectChange,
    this.onAcceptPart,
    this.onRejectPart,
  });

  final List<PlnDiffLineData> lines;
  final String? title;
  final String? selectedChangeId;
  final bool granular;
  final double maxHeight;
  final ValueChanged<String>? onSelectChange;
  final ValueChanged<String>? onAcceptPart;
  final ValueChanged<String>? onRejectPart;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();

    return PlnDashedBorder(
      radius: PlnRadius.card,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlnRadius.card),
        child: ColoredBox(
          color: context.plnTheme.component,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlnSpace.md,
                    vertical: PlnSpace.sm,
                  ),
                  child: PlnText(
                    title!,
                    role: PlnTextRole.label,
                    tone: PlnTextTone.muted,
                  ),
                ),
                const PlnDashedDivider(),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < lines.length; index++)
                        _PlnDiffViewerLine(
                          index: index,
                          line: lines[index],
                          selected:
                              lines[index].changeId != null &&
                              lines[index].changeId == selectedChangeId,
                          granular: granular,
                          onSelectChange: onSelectChange,
                          onAcceptPart: onAcceptPart,
                          onRejectPart: onRejectPart,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlnDiffViewerLine extends StatelessWidget {
  const _PlnDiffViewerLine({
    required this.index,
    required this.line,
    required this.selected,
    required this.granular,
    required this.onSelectChange,
    required this.onAcceptPart,
    required this.onRejectPart,
  });

  final int index;
  final PlnDiffLineData line;
  final bool selected;
  final bool granular;
  final ValueChanged<String>? onSelectChange;
  final ValueChanged<String>? onAcceptPart;
  final ValueChanged<String>? onRejectPart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final marker = switch (line.kind) {
      PlnDiffKind.add => '+',
      PlnDiffKind.remove => '-',
      PlnDiffKind.conflict => '!',
      PlnDiffKind.context => ' ',
    };
    final foreground = switch (line.kind) {
      PlnDiffKind.add => tokens.success,
      PlnDiffKind.remove => tokens.danger,
      PlnDiffKind.conflict => tokens.warning,
      PlnDiffKind.context => tokens.text,
    };
    final background = switch (line.kind) {
      PlnDiffKind.add => tokens.diffAdd,
      PlnDiffKind.remove => tokens.diffRemove,
      PlnDiffKind.conflict => tokens.warning.withValues(alpha: 0.14),
      PlnDiffKind.context => tokens.component,
    };
    final changeId = line.changeId;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: changeId == null || onSelectChange == null
          ? null
          : () => onSelectChange!(changeId),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          border: selected
              ? Border(left: BorderSide(color: tokens.borderStrong))
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: PlnSpace.sm,
          vertical: PlnSpace.xs,
        ),
        child: Row(
          children: [
            _PlnDiffLineNumber(value: line.beforeLine),
            _PlnDiffLineNumber(value: line.afterLine),
            SizedBox(
              width: PlnSpace.lg,
              child: PlnText(marker, role: PlnTextRole.code, color: foreground),
            ),
            Expanded(child: PlnText(line.content, role: PlnTextRole.code)),
            if (granular && changeId != null) ...[
              _PlnDiffAction(
                key: ValueKey('pln-diff-accept-$changeId-$index'),
                icon: PlnIcons.check,
                color: tokens.success,
                onPressed: onAcceptPart == null
                    ? null
                    : () => onAcceptPart!(changeId),
              ),
              _PlnDiffAction(
                key: ValueKey('pln-diff-reject-$changeId-$index'),
                icon: PlnIcons.x,
                color: tokens.danger,
                onPressed: onRejectPart == null
                    ? null
                    : () => onRejectPart!(changeId),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlnDiffLineNumber extends StatelessWidget {
  const _PlnDiffLineNumber({required this.value});

  final int? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: PlnText(
        value?.toString() ?? '',
        role: PlnTextRole.code,
        tone: PlnTextTone.faint,
        textAlign: TextAlign.end,
      ),
    );
  }
}

class _PlnDiffAction extends StatelessWidget {
  const _PlnDiffAction({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(PlnSpace.xs),
        child: PlnIcon(icon, size: PlnSize.iconSmall, color: color),
      ),
    );
  }
}

class PlnDiffGroup extends StatelessWidget {
  const PlnDiffGroup({super.key, required this.rows});

  final List<PlnDiffRowData> rows;

  @override
  Widget build(BuildContext context) {
    return PlnDashedBorder(
      radius: PlnRadius.sm,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlnRadius.sm),
        child: Column(
          children: [
            for (var index = 0; index < rows.length; index++)
              PlnDiffRow(
                line: rows[index].line,
                content: rows[index].content,
                kind: rows[index].kind,
                borderRadius: _radiusFor(index),
                showDivider: false,
              ),
          ],
        ),
      ),
    );
  }

  BorderRadius _radiusFor(int index) {
    if (rows.length == 1) {
      return BorderRadius.circular(PlnRadius.sm);
    }

    if (index == 0) {
      return const BorderRadius.vertical(top: Radius.circular(PlnRadius.sm));
    }

    if (index == rows.length - 1) {
      return const BorderRadius.vertical(bottom: Radius.circular(PlnRadius.sm));
    }

    return BorderRadius.zero;
  }
}

class PlnDiffRow extends StatelessWidget {
  const PlnDiffRow({
    super.key,
    required this.line,
    required this.content,
    this.kind = PlnDiffKind.context,
    this.borderRadius,
    this.showDivider = false,
  });

  final String line;
  final String content;
  final PlnDiffKind kind;
  final BorderRadius? borderRadius;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final marker = switch (kind) {
      PlnDiffKind.add => '+',
      PlnDiffKind.remove => '-',
      PlnDiffKind.context => ' ',
      PlnDiffKind.conflict => '!',
    };
    final markerColor = switch (kind) {
      PlnDiffKind.add => tokens.success,
      PlnDiffKind.remove => tokens.danger,
      PlnDiffKind.context => tokens.textFaint,
      PlnDiffKind.conflict => tokens.warning,
    };
    final background = switch (kind) {
      PlnDiffKind.add => tokens.diffAdd,
      PlnDiffKind.remove => tokens.diffRemove,
      PlnDiffKind.context => tokens.component,
      PlnDiffKind.conflict => tokens.warning.withValues(alpha: 0.14),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: tokens.divider,
                  width: PlnLine.hairline,
                ),
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(PlnRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PlnSpace.sm,
          vertical: PlnSpace.xs,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: PlnText(
                line,
                role: PlnTextRole.code,
                tone: PlnTextTone.faint,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: PlnSpace.sm),
            PlnText(marker, role: PlnTextRole.code, color: markerColor),
            const SizedBox(width: PlnSpace.sm),
            Expanded(child: PlnText(content, role: PlnTextRole.code)),
          ],
        ),
      ),
    );
  }
}
