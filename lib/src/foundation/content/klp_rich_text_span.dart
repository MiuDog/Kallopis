import 'dart:ui';

import 'package:flutter/foundation.dart';

/// 簡化的行內純文字片段，只承載粗體與顏色覆寫。
@immutable
class KlpRichTextSpan {
	const KlpRichTextSpan({
		required this.text,
		this.strong = false,
		this.color,
	});

	final String text;
	final bool strong;
	final Color? color;
}
