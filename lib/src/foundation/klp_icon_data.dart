import 'package:flutter/foundation.dart';

import 'klp_icon_weight.dart';

/// Kallopis 圖示字型中的 regular 與 optional thin 字碼。
@immutable
final class KlpIconData {
	const KlpIconData(this.regularCodePoint, {this.thinCodePoint});

	final int regularCodePoint;
	final int? thinCodePoint;

	int get codePoint => regularCodePoint;

	int codePointFor(KlpIconWeight weight) {
		if (weight == KlpIconWeight.thin && thinCodePoint != null) {
			return thinCodePoint!;
		}
		return regularCodePoint;
	}

	bool supports(KlpIconWeight weight) =>
			weight == KlpIconWeight.regular || thinCodePoint != null;
}
