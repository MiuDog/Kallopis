import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_theme.dart';

// 依 micro-elevation-v1 語意組合膠囊分頁列（使用 context.klp 解析背景、邊框與強調點）。
class MicroElevatedPillTabs extends StatelessWidget {
	const MicroElevatedPillTabs({super.key, required this.labels, required this.activeIndex, required this.onSelect});
	final List<String> labels;
	final int activeIndex;
	final ValueChanged<int> onSelect;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		return Container(
			padding: EdgeInsets.all(klp.spacing.tight),
			decoration: BoxDecoration(
				color: klp.colors.surface,
				borderRadius: BorderRadius.circular(klp.shape.panel),
				border: Border.all(color: klp.colors.border),
			),
			child: Wrap(
				spacing: 6,
				children: [
					for (var i = 0; i < labels.length; i++)
						GestureDetector(
							onTap: () => onSelect(i),
							child: Container(
								padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
								decoration: BoxDecoration(
									color: i == activeIndex ? klp.colors.component : klp.colors.transparent,
									borderRadius: BorderRadius.circular(klp.shape.control),
									border: Border.all(color: i == activeIndex ? klp.colors.borderStrong : klp.colors.transparent),
								),
								child: Text(labels[i], style: TextStyle(color: i == activeIndex ? klp.colors.text : klp.colors.textMuted)),
							),
						),
				],
			),
		);
	}
}
