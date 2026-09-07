import 'package:flutter/widgets.dart';

import '../../surface/klp_surface.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

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
		final separator = BorderSide(color: context.klpColors.border, width: context.klp.shape.hairline);

		return GridView.builder(
			shrinkWrap: true,
			physics: const NeverScrollableScrollPhysics(),
			gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: space.pageLarge + space.section),
			itemCount: items.length,
			itemBuilder: (context, index) {
				final item = items[index];
				final columnIndex = index % 7;
				final isWeekend = columnIndex == 0 || columnIndex == 6;
				final rightBorder = columnIndex == 6 ? BorderSide.none : separator;
				final bottomBorder = index + 7 >= items.length ? BorderSide.none : separator;
				var tone = isWeekend ? KlpSurfaceTone.muted : KlpSurfaceTone.transparent;
				if (item.selected) tone = KlpSurfaceTone.component;

				return GestureDetector(
					behavior: HitTestBehavior.opaque,
					onTap: onSelected == null ? null : () => onSelected!(index),
					child: KlpSurface(
						tone: tone,
						radius: 0,
						border: Border(right: rightBorder, bottom: bottomBorder),
						padding: EdgeInsets.all(space.tight + space.hairline),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								KlpText(
									item.label,
									role: item.selected ? KlpTextRole.bodyStrong : KlpTextRole.body,
									tone: item.selected ? KlpTextTone.automatic : KlpTextTone.faint,
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
