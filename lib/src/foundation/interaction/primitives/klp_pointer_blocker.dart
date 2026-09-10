import 'package:flutter/widgets.dart';

/// 阻擋子樹指標事件、但保留其布局與繪製的基礎互動原語。
class KlpPointerBlocker extends StatelessWidget {
	const KlpPointerBlocker({
		super.key,
		this.blocking = true,
		required this.child,
	});

	final bool blocking;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return AbsorbPointer(
			absorbing: blocking,
			child: child,
		);
	}
}
