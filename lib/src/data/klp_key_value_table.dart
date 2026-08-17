import 'package:flutter/widgets.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

@immutable
class KlpKeyValueRowData {
  const KlpKeyValueRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class KlpKeyValueTable extends StatelessWidget {
  const KlpKeyValueTable({
    super.key,
    required this.rows,
    this.title,
    this.labelWidth = 112,
  });

  final List<KlpKeyValueRowData> rows;
  final String? title;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(KlpRadius.card),
      child: ColoredBox(
        color: tokens.component,
        child: Padding(
          padding: const EdgeInsets.all(KlpSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                KlpText(title!, role: KlpTextRole.label),
                const SizedBox(height: KlpSpace.md),
              ],
              for (var index = 0; index < rows.length; index++) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
                  child: Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: KlpText(
                          rows[index].label,
                          role: KlpTextRole.body,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                      Expanded(
                        child: KlpText(
                          rows[index].value,
                          role: KlpTextRole.body,
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
class KlpKeyValueItem {
  const KlpKeyValueItem({
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

class KlpKeyValueList extends StatelessWidget {
  const KlpKeyValueList({
    super.key,
    required this.rows,
    this.labelWidth = 96,
    this.onCopy,
    this.emptyState,
  });

  final List<KlpKeyValueItem> rows;
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
            padding: const EdgeInsets.symmetric(vertical: KlpSpace.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: labelWidth,
                  child: KlpText(
                    row.label,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: KlpSpace.md),
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontFamily: row.verbatim
                          ? KlpTypography.monoFamily
                          : null,
                      color: context.plnTheme.text,
                      fontSize: KlpTypography.small,
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
                      padding: const EdgeInsets.all(KlpSpace.xs),
                      child: KlpIcon(
                        KlpIcons.clipboard,
                        size: KlpSize.iconSmall,
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
