import 'package:flutter/widgets.dart';

import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';

/// 側邊欄分組標題，固定高度且左對齊、使用低對比的
/// [KlpTextRole.label] 樣式。
///
/// 固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會
/// 讓上下間距看起來不一樣。
class KlpSidebarSectionLabel extends StatelessWidget {
	const KlpSidebarSectionLabel({super.key, required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			height: context.klp.space.loose,
			child: Align(
				alignment: Alignment.centerLeft,
				child: Padding(
					padding: EdgeInsets.only(left: context.klp.space.tight),
					child: KlpText(
						label,
						role: KlpTextRole.label,
						tone: KlpTextTone.muted,
					),
				),
			),
		);
	}
}
