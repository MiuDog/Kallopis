import 'package:flutter/foundation.dart';

/// OKLCH 編輯控制項可操作的 Chroma 範圍。
@immutable
class KlpOklchChromaRange {
	const KlpOklchChromaRange.custom(this.upperBound) : assert(upperBound > 0);

	static const standard = KlpOklchChromaRange.custom(0.4);

	final double upperBound;
}
