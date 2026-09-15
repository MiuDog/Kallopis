import 'package:flutter/widgets.dart';

import 'package:kallopis/src/features/actions/button/klp_button.dart';
import 'package:kallopis/src/foundation/layout/klp_gap.dart';
import 'package:kallopis/src/foundation/layout/klp_row.dart';
import 'package:kallopis/src/foundation/layout/klp_space_size.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';

/// 上一頁／頁碼／下一頁的受控分頁元件。
class KlpPagination extends StatelessWidget {
  const KlpPagination({
    super.key,
    required this.page,
    required this.pageCount,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPageChanged,
  });

  final int page;
  final int pageCount;
  final String previousLabel;
  final String nextLabel;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return KlpRow(
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpButton(
          label: previousLabel,
          compact: true,
          onPressed: page <= 1 || onPageChanged == null
              ? null
              : () => onPageChanged!(page - 1),
        ),
        const KlpGap.widthSize(KlpSpaceSize.action),
        KlpText('$page / $pageCount', role: KlpTextRole.code),
        const KlpGap.widthSize(KlpSpaceSize.action),
        KlpButton(
          label: nextLabel,
          compact: true,
          onPressed: page >= pageCount || onPageChanged == null
              ? null
              : () => onPageChanged!(page + 1),
        ),
      ],
    );
  }
}
