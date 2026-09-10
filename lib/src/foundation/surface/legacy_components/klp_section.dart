import 'package:flutter/widgets.dart';

import '../../layout/klp_layout.dart';
import '../../content/klp_text.dart';

/// 帶標題的內容分段。`label` 是標題上方的小型分類文字。
class KlpSection extends StatelessWidget {
	const KlpSection({
		super.key,
		required this.title,
		required this.child,
		this.label,
		this.trailing,
	});

	final String title;
	final String? label;
	final Widget? trailing;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		final heading = KlpWrap(
			crossAxisAlignment: WrapCrossAlignment.center,
			spacingSize: KlpSpaceSize.base,
			runSpacingSize: KlpSpaceSize.tight,
			children: [
				KlpText(title, role: KlpTextRole.section),
				if (label != null)
					KlpText(label!.toUpperCase(), role: KlpTextRole.label),
			],
		);

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpRow(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						KlpExpanded(child: heading),
						if (trailing != null) ...[
							const KlpGap.widthSize(KlpSpaceSize.base),
							trailing!,
						],
					],
				),
				const KlpGap.heightSize(KlpSpaceSize.comfortable),
				child,
			],
		);
	}
}
