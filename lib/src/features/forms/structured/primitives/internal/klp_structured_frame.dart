import 'package:flutter/widgets.dart';

import 'klp_structured_frame_style.dart';

export 'klp_structured_frame_style.dart';

/// Structured form 專用的底層框架，精確保留既有 Container paint 行為。
class KlpStructuredFrame extends StatelessWidget {
	const KlpStructuredFrame({
		super.key,
		required this.style,
		required this.child,
	});

	final KlpStructuredFrameStyle style;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		Border? border;
		if (style.borderColor != null && style.borderWidth != null) {
			border = Border.all(color: style.borderColor!, width: style.borderWidth!);
		}

		return Container(
			height: style.height,
			alignment: style.alignment,
			padding: style.insets.edgeInsets,
			decoration: BoxDecoration(
				color: style.background,
				borderRadius: BorderRadius.circular(style.radius),
				border: border,
			),
			child: child,
		);
	}
}
