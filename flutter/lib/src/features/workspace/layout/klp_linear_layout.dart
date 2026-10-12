import 'dart:math' as math;

/// 單一主軸尺寸，不持有內容、panel 或產品狀態。
final class KlpLinearItem {
	const KlpLinearItem({this.minimum = 0, this.maximum, this.preferred = 0, this.flex = 1});

	/// minimum／maximum：正常空間下的尺寸限制。
	final double minimum;
	final double? maximum;
	/// preferred：分配 flex 前要求的尺寸，會先限制在合法範圍。
	final double preferred;
	/// flex：剩餘空間的比例權重；零表示不增長。
	final double flex;
}

/// 尺寸與 caller 隔離；留白由呈現層決定對齊位置。
final class KlpLinearLayoutResult {
	KlpLinearLayoutResult._(List<double> extents, {required this.gutter, required this.unused, required this.compressed})
		: extents = List<double>.unmodifiable(extents);

	final List<double> extents;
	final double gutter;
	final double unused;
	/// compressed：間距被縮小或 minimum 無法全部滿足。
	final bool compressed;
}

void _nonnegative(double value, String path) {
	if (!value.isFinite || value < 0) throw ArgumentError.value(value, path, 'Expected finite nonnegative number.');
}

double _sum(Iterable<double> values) => values.fold<double>(0, (sum, value) => sum + value);

/// 比例先正規化，避免巨大但有限的權重加總變成 Infinity。
List<double> _proportional(List<double> weights, double budget) {
	final maximum = weights.fold<double>(0, math.max);
	if (maximum == 0 || budget == 0) return List<double>.filled(weights.length, 0);
	final normalized = weights.map((weight) => weight / maximum).toList();
	final total = _sum(normalized);
	return normalized.map((weight) => (weight / total) * budget).toList();
}

/// 先保留 gutter，再解析 minimum、preferred 與受限 flex。
KlpLinearLayoutResult resolveKlpLinearLayout({
	required double extent,
	required double gutter,
	required int gutterCount,
	required List<KlpLinearItem> items,
}) {
	_nonnegative(extent, 'extent');
	_nonnegative(gutter, 'gutter');
	if (gutterCount < 0) throw ArgumentError.value(gutterCount, 'gutterCount', 'Expected nonnegative integer.');
	for (var index = 0; index < items.length; index++) {
		final item = items[index];
		_nonnegative(item.minimum, 'items[$index].minimum');
		_nonnegative(item.preferred, 'items[$index].preferred');
		_nonnegative(item.flex, 'items[$index].flex');
		final maximum = item.maximum;
		if (maximum != null) {
			_nonnegative(maximum, 'items[$index].maximum');
			if (maximum < item.minimum) throw ArgumentError.value(maximum, 'items[$index].maximum', 'Below minimum.');
		}
	}
	final actualGutter = gutterCount == 0 ? 0.0 : math.min(gutter, extent / gutterCount);
	final budget = math.max(0.0, extent - actualGutter * gutterCount);
	final minima = items.map((item) => item.minimum).toList();
	final minimumTotal = _sum(minima);
	final compressed = (gutterCount > 0 && actualGutter < gutter) || minimumTotal > budget;
	late List<double> extents;
	if (minimumTotal > budget) {
		extents = _proportional(minima, budget);
	} else {
		extents = items.map((item) => math.max(item.minimum, math.min(item.preferred, item.maximum ?? double.infinity))).toList();
		final preferredTotal = _sum(extents);
		if (preferredTotal > budget) {
			final extras = _proportional([for (var index = 0; index < items.length; index++) extents[index] - minima[index]], math.max(0.0, budget - minimumTotal));
			extents = [for (var index = 0; index < items.length; index++) minima[index] + extras[index]];
		} else {
			var remaining = math.max(0.0, budget - preferredTotal);
			// 每輪至少完成分配或移除一個達上限的項目，迭代次數有限。
			for (var round = 0; round <= items.length && remaining > 0; round++) {
				final active = [for (var index = 0; index < items.length; index++)
					if (items[index].flex > 0 && (items[index].maximum == null || items[index].maximum! > extents[index])) index];
				if (active.isEmpty) break;
				final shares = _proportional(active.map((index) => items[index].flex).toList(), remaining);
				var spent = 0.0, capped = false;
				for (var position = 0; position < active.length; position++) {
					final index = active[position];
					final maximum = items[index].maximum;
					final capacity = maximum == null ? remaining : math.max(0.0, maximum - extents[index]);
					final amount = math.min(shares[position], capacity);
					extents[index] += amount;
					spent += amount;
					capped = capped || capacity <= shares[position];
				}
				remaining = math.max(0.0, remaining - spent);
				if (!capped || spent == 0) break;
			}
		}
	}
	return KlpLinearLayoutResult._(extents, gutter: actualGutter, unused: math.max(0.0, budget - _sum(extents)), compressed: compressed);
}
