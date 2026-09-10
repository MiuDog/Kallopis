import 'package:flutter/widgets.dart';

import 'klp_translation.dart';

/// 依型別化幾何介面平移內容的排版原語。
class KlpTranslate extends StatelessWidget {
	const KlpTranslate({
		super.key,
		required this.translation,
		required this.child,
	});

	final KlpTranslation translation;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Transform.translate(
			offset: Offset(translation.horizontal, translation.vertical),
			child: child,
		);
	}
}
