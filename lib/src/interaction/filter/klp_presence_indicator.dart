import 'package:flutter/widgets.dart';

import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';

/// 協作者在線／連線狀態標記。
class KlpPresenceIndicator extends StatelessWidget {
	const KlpPresenceIndicator({
		super.key,
		required this.label,
		required this.active,
	});

	final String label;
	final bool active;

	@override
	Widget build(BuildContext context) {
		final color = active ? context.klpColors.success : context.klpColors.textFaint;
		return Row(
			mainAxisSize: MainAxisSize.min,
			children: [
				Container(
					width: context.klp.geometry.control.presenceMarkerExtent,
					height: context.klp.geometry.control.presenceMarkerExtent,
					decoration: BoxDecoration(
						color: color,
						borderRadius: BorderRadius.circular(context.klp.shape.pill),
					),
				),
				SizedBox(width: context.klp.space.tight),
				KlpText(label, role: KlpTextRole.caption, color: color),
			],
		);
	}
}
