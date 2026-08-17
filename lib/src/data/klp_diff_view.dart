import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

enum KlpDiffKind { add, remove, context, conflict }

@immutable
class KlpDiffRowData {
  const KlpDiffRowData({
    required this.line,
    required this.content,
    this.kind = KlpDiffKind.context,
  });

  final String line;
  final String content;
  final KlpDiffKind kind;
}

@immutable
class KlpDiffLineData {
  const KlpDiffLineData({
    required this.content,
    this.beforeLine,
    this.afterLine,
    this.kind = KlpDiffKind.context,
    this.changeId,
  });

  final int? beforeLine;
  final int? afterLine;
  final String content;
  final KlpDiffKind kind;
  final String? changeId;
}

class KlpDiffViewer extends StatelessWidget {
  const KlpDiffViewer({
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

  final List<KlpDiffLineData> lines;
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

    return KlpDashedBorder(
      radius: KlpRadius.card,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KlpRadius.card),
        child: ColoredBox(
          color: context.plnTheme.component,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: KlpSpace.md,
                    vertical: KlpSpace.sm,
                  ),
                  child: KlpText(
                    title!,
                    role: KlpTextRole.label,
                    tone: KlpTextTone.muted,
                  ),
                ),
                const KlpDashedDivider(),
              ],
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var index = 0; index < lines.length; index++)
                        _KlpDiffViewerLine(
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

class _KlpDiffViewerLine extends StatelessWidget {
  const _KlpDiffViewerLine({
    required this.index,
    required this.line,
    required this.selected,
    required this.granular,
    required this.onSelectChange,
    required this.onAcceptPart,
    required this.onRejectPart,
  });

  final int index;
  final KlpDiffLineData line;
  final bool selected;
  final bool granular;
  final ValueChanged<String>? onSelectChange;
  final ValueChanged<String>? onAcceptPart;
  final ValueChanged<String>? onRejectPart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final marker = switch (line.kind) {
      KlpDiffKind.add => '+',
      KlpDiffKind.remove => '-',
      KlpDiffKind.conflict => '!',
      KlpDiffKind.context => ' ',
    };
    final foreground = switch (line.kind) {
      KlpDiffKind.add => tokens.success,
      KlpDiffKind.remove => tokens.danger,
      KlpDiffKind.conflict => tokens.warning,
      KlpDiffKind.context => tokens.text,
    };
    final background = switch (line.kind) {
      KlpDiffKind.add => tokens.diffAdd,
      KlpDiffKind.remove => tokens.diffRemove,
      KlpDiffKind.conflict => tokens.warning.withValues(alpha: 0.14),
      KlpDiffKind.context => tokens.component,
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
          horizontal: KlpSpace.sm,
          vertical: KlpSpace.xs,
        ),
        child: Row(
          children: [
            _KlpDiffLineNumber(value: line.beforeLine),
            _KlpDiffLineNumber(value: line.afterLine),
            SizedBox(
              width: KlpSpace.lg,
              child: KlpText(marker, role: KlpTextRole.code, color: foreground),
            ),
            Expanded(child: KlpText(line.content, role: KlpTextRole.code)),
            if (granular && changeId != null) ...[
              _KlpDiffAction(
                key: ValueKey('pln-diff-accept-$changeId-$index'),
                icon: KlpIcons.check,
                color: tokens.success,
                onPressed: onAcceptPart == null
                    ? null
                    : () => onAcceptPart!(changeId),
              ),
              _KlpDiffAction(
                key: ValueKey('pln-diff-reject-$changeId-$index'),
                icon: KlpIcons.x,
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

class _KlpDiffLineNumber extends StatelessWidget {
  const _KlpDiffLineNumber({required this.value});

  final int? value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: KlpText(
        value?.toString() ?? '',
        role: KlpTextRole.code,
        tone: KlpTextTone.faint,
        textAlign: TextAlign.end,
      ),
    );
  }
}

class _KlpDiffAction extends StatelessWidget {
  const _KlpDiffAction({
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
        padding: const EdgeInsets.all(KlpSpace.xs),
        child: KlpIcon(icon, size: KlpSize.iconSmall, color: color),
      ),
    );
  }
}

class KlpDiffGroup extends StatelessWidget {
  const KlpDiffGroup({super.key, required this.rows});

  final List<KlpDiffRowData> rows;

  @override
  Widget build(BuildContext context) {
    return KlpDashedBorder(
      radius: KlpRadius.sm,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KlpRadius.sm),
        child: Column(
          children: [
            for (var index = 0; index < rows.length; index++)
              KlpDiffRow(
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
      return BorderRadius.circular(KlpRadius.sm);
    }

    if (index == 0) {
      return const BorderRadius.vertical(top: Radius.circular(KlpRadius.sm));
    }

    if (index == rows.length - 1) {
      return const BorderRadius.vertical(bottom: Radius.circular(KlpRadius.sm));
    }

    return BorderRadius.zero;
  }
}

class KlpDiffRow extends StatelessWidget {
  const KlpDiffRow({
    super.key,
    required this.line,
    required this.content,
    this.kind = KlpDiffKind.context,
    this.borderRadius,
    this.showDivider = false,
  });

  final String line;
  final String content;
  final KlpDiffKind kind;
  final BorderRadius? borderRadius;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final marker = switch (kind) {
      KlpDiffKind.add => '+',
      KlpDiffKind.remove => '-',
      KlpDiffKind.context => ' ',
      KlpDiffKind.conflict => '!',
    };
    final markerColor = switch (kind) {
      KlpDiffKind.add => tokens.success,
      KlpDiffKind.remove => tokens.danger,
      KlpDiffKind.context => tokens.textFaint,
      KlpDiffKind.conflict => tokens.warning,
    };
    final background = switch (kind) {
      KlpDiffKind.add => tokens.diffAdd,
      KlpDiffKind.remove => tokens.diffRemove,
      KlpDiffKind.context => tokens.component,
      KlpDiffKind.conflict => tokens.warning.withValues(alpha: 0.14),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: tokens.divider,
                  width: KlpLine.hairline,
                ),
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(KlpRadius.sm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KlpSpace.sm,
          vertical: KlpSpace.xs,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: KlpText(
                line,
                role: KlpTextRole.code,
                tone: KlpTextTone.faint,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: KlpSpace.sm),
            KlpText(marker, role: KlpTextRole.code, color: markerColor),
            const SizedBox(width: KlpSpace.sm),
            Expanded(child: KlpText(content, role: KlpTextRole.code)),
          ],
        ),
      ),
    );
  }
}
