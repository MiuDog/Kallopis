import 'package:flutter/widgets.dart';

/// 集中鍵盤焦點與按鍵事件的基礎互動原語。
class KlpFocusRegion extends StatelessWidget {
	const KlpFocusRegion({
		super.key,
		required this.child,
		this.autofocus = false,
		this.focusNode,
		this.onKeyEvent,
	});

	final Widget child;
	final bool autofocus;
	final FocusNode? focusNode;
	final FocusOnKeyEventCallback? onKeyEvent;

	@override
	Widget build(BuildContext context) {
		return Focus(
			autofocus: autofocus,
			focusNode: focusNode,
			onKeyEvent: onKeyEvent,
			child: child,
		);
	}
}
