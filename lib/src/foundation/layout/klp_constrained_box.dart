import 'package:flutter/widgets.dart';

import 'klp_box_constraints.dart';

/// 套用型別化幾何限制的基礎排版原語。
class KlpConstrainedBox extends StatelessWidget {
	const KlpConstrainedBox({
		super.key,
		required this.constraints,
		required this.child,
	});

	final KlpBoxConstraints constraints;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return ConstrainedBox(
			constraints: BoxConstraints(
				minWidth: constraints.minWidth,
				maxWidth: constraints.maxWidth,
				minHeight: constraints.minHeight,
				maxHeight: constraints.maxHeight,
			),
			child: child,
		);
	}
}
