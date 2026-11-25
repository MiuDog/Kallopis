import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis_theme.dart';

// 依 modern-minimal-v1（open-tag）語意呈現編輯感細線卡片。
class EditorialSpotlightCard extends StatelessWidget {
	const EditorialSpotlightCard({super.key, required this.title, required this.subtitle});
	final String title;
	final String subtitle;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		return Container(
			padding: EdgeInsets.all(klp.spacing.comfortable),
			decoration: BoxDecoration(
				color: klp.colors.component,
				borderRadius: BorderRadius.circular(klp.shape.card),
				border: Border.all(color: klp.colors.border),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Text(title, style: TextStyle(fontSize: 24, color: klp.colors.text)),
					SizedBox(height: klp.spacing.tight),
					Text(subtitle, style: TextStyle(color: klp.colors.textMuted)),
				],
			),
		);
	}
}
