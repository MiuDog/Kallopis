/// Kallopis 專案模組。
library;

import 'package:flutter/widgets.dart';

import 'klp_schedule_item_data.dart';
import '../badge/klp_badge.dart';
import '../../../foundation/layout/klp_layout.dart';
import '../../../foundation/surface/klp_surface.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';

/// 固定時間欄、標題與選填標籤的排程清單。
class KlpScheduleList extends StatelessWidget {
  const KlpScheduleList({super.key, required this.items});

  final List<KlpScheduleItemData> items;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          KlpSurface(
            tone: KlpSurfaceTone.component,
            padding: EdgeInsets.symmetric(
              horizontal: space.contentInset,
              vertical: space.contentInset - space.hairline,
            ),
            child: KlpRow(
              children: [
                KlpBox(
                  widthSize: KlpSpaceSize.sectionLarge,
                  child: KlpText(
                    items[index].time,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                KlpGap.widthSize(KlpSpaceSize.contentInline),
                KlpExpanded(child: KlpText(items[index].label)),
                if (items[index].tag case final tag?) KlpBadge(label: tag),
              ],
            ),
          ),
          if (index < items.length - 1)
            KlpGap.heightSize(KlpSpaceSize.contentStack),
        ],
      ],
    );
  }
}
