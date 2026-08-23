import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 日期格內容；只描述顯示資料，不擁有行事曆領域規則。
@immutable
class KlpDateGridItem {
  const KlpDateGridItem({
    required this.label,
    this.lines = const [],
    this.selected = false,
  });

  final String label;
  final List<String> lines;
  final bool selected;
}

/// 一列七欄的日期概覽格。
class KlpDateGrid extends StatelessWidget {
  const KlpDateGrid({super.key, required this.items, this.onSelected});

  final List<KlpDateGridItem> items;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: space.pageLarge + space.section,
        crossAxisSpacing: space.tight,
        mainAxisSpacing: space.tight,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onSelected == null ? null : () => onSelected!(index),
          child: KlpSurface(
            tone: item.selected
                ? KlpSurfaceTone.component
                : KlpSurfaceTone.transparent,
            padding: EdgeInsets.all(space.tight + space.hairline),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KlpText(
                  item.label,
                  role: item.selected
                      ? KlpTextRole.bodyStrong
                      : KlpTextRole.body,
                  tone: item.selected
                      ? KlpTextTone.automatic
                      : KlpTextTone.faint,
                ),
                SizedBox(height: space.tight),
                for (final line in item.lines) ...[
                  KlpText(line, role: KlpTextRole.body),
                  SizedBox(height: space.hairline),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
