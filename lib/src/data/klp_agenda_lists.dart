import 'package:flutter/widgets.dart';

import '../controls/klp_checkbox.dart';
import '../data/klp_badge.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 待辦列的呈現資料。
@immutable
class KlpTaskItemData {
  const KlpTaskItemData({
    required this.title,
    required this.detail,
    this.checked = false,
  });

  final String title;
  final String detail;
  final bool checked;
}

/// 帶有核取狀態與輔助資訊的待辦清單。
class KlpTaskList extends StatelessWidget {
  const KlpTaskList({super.key, required this.items, this.onChanged});

  final List<KlpTaskItemData> items;
  final void Function(int index, bool value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: space.tight,
              vertical: space.tight + space.hairline,
            ),
            child: Row(
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
                SizedBox(width: space.compact),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(items[index].title),
                      SizedBox(height: space.tight),
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
          if (index < items.length - 1) SizedBox(height: space.hairline),
        ],
      ],
    );
  }
}

/// 排程列的呈現資料。
@immutable
class KlpScheduleItemData {
  const KlpScheduleItemData({
    required this.time,
    required this.title,
    this.tag,
  });

  final String time;
  final String title;
  final String? tag;
}

/// 固定時間欄、標題與選填標籤的排程清單。
class KlpScheduleList extends StatelessWidget {
  const KlpScheduleList({super.key, required this.items});

  final List<KlpScheduleItemData> items;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          KlpSurface(
            tone: KlpSurfaceTone.component,
            padding: EdgeInsets.symmetric(
              horizontal: space.compact,
              vertical: space.compact - space.hairline,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: space.section + space.compact,
                  child: KlpText(
                    items[index].time,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                  ),
                ),
                SizedBox(width: space.compact),
                Expanded(child: KlpText(items[index].title)),
                if (items[index].tag != null)
                  KlpBadge(label: items[index].tag!),
              ],
            ),
          ),
          if (index < items.length - 1) SizedBox(height: space.compact),
        ],
      ],
    );
  }
}
