/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';

import '../../forms/selection/klp_checkbox.dart';
import '../../../foundation/layout/klp_layout.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';
import 'klp_task_item_data.dart';

/// 帶有核取狀態與輔助資訊的待辦清單。
class KlpTaskList extends StatelessWidget {
  const KlpTaskList({super.key, required this.items, this.onChanged});

  final List<KlpTaskItemData> items;
  final void Function(int index, bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          KlpBox(
            padding: EdgeInsets.symmetric(
              horizontal: space.tight,
              vertical: space.tight + space.hairline,
            ),
            child: KlpRow(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpCheckbox(
                  value: items[index].checked,
                  label: items[index].title,
                  showLabel: false,
                  onChanged: onChanged == null
                      ? null
                      : (value) => onChanged!(index, value),
                ),
                KlpGap.widthSize(KlpSpaceSize.contentInline),
                KlpExpanded(
                  child: KlpColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(items[index].title),
                      KlpGap.heightSize(KlpSpaceSize.tight),
                      KlpText(
                        items[index].detail,
                        role: KlpTextRole.code,
                        tone: KlpTextTone.faint,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (index < items.length - 1) KlpGap.heightSize(KlpSpaceSize.hairline),
        ],
      ],
    );
  }
}
