import 'package:flutter/widgets.dart';

import 'klp_quarter_turn.dart';

/// 只接受型別化直角方向的旋轉排版原語。
class KlpRotate extends StatelessWidget {
	const KlpRotate({
		super.key,
		required this.turn,
		required this.child,
	});

	final KlpQuarterTurn turn;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return RotatedBox(
			quarterTurns: switch (turn) {
				KlpQuarterTurn.clockwise => 1,
				KlpQuarterTurn.half => 2,
				KlpQuarterTurn.counterClockwise => 3,
			},
			child: child,
		);
	}
}
