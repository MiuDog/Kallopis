import 'package:flutter/widgets.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

@immutable
class PlnKeyValueRowData {
  const PlnKeyValueRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class PlnKeyValueTable extends StatelessWidget {
  const PlnKeyValueTable({
    super.key,
    required this.rows,
    this.title,
    this.labelWidth = 112,
  });

  final List<PlnKeyValueRowData> rows;
  final String? title;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(PlnRadius.card),
      child: ColoredBox(
        color: tokens.component,
        child: Padding(
          padding: const EdgeInsets.all(PlnSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                PlnText(title!, role: PlnTextRole.label),
                const SizedBox(height: PlnSpace.md),
              ],
              for (var index = 0; index < rows.length; index++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
                  child: Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: PlnText(
                          rows[index].label,
                          role: PlnTextRole.body,
                          tone: PlnTextTone.muted,
                        ),
                      ),
                      Expanded(
                        child: PlnText(
                          rows[index].value,
                          role: PlnTextRole.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class PlnKeyValueItem {
  const PlnKeyValueItem({
    required this.id,
    required this.label,
    required this.value,
    this.verbatim = false,
    this.copyable = false,
  });

  final String id;
  final String label;
  final Widget value;
  final bool verbatim;
  final bool copyable;
}

class PlnKeyValueList extends StatelessWidget {
  const PlnKeyValueList({
    super.key,
    required this.rows,
    this.labelWidth = 96,
    this.onCopy,
    this.emptyState,
  });

  final List<PlnKeyValueItem> rows;
  final double labelWidth;
  final ValueChanged<String>? onCopy;
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return emptyState ?? const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: PlnSpace.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: labelWidth,
                  child: PlnText(
                    row.label,
                    role: PlnTextRole.caption,
                    tone: PlnTextTone.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: PlnSpace.md),
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontFamily: row.verbatim
                          ? PlnTypography.monoFamily
                          : null,
                      color: context.plnTheme.text,
                      fontSize: PlnTypography.small,
                    ),
                    child: row.value,
                  ),
                ),
                if (row.copyable && onCopy != null)
                  GestureDetector(
                    key: ValueKey('pln-key-value-copy-${row.id}'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onCopy!(row.id),
                    child: Padding(
                      padding: const EdgeInsets.all(PlnSpace.xs),
                      child: PlnIcon(
                        PlnIcons.clipboard,
                        size: PlnSize.iconSmall,
                        color: context.plnTheme.textFaint,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
