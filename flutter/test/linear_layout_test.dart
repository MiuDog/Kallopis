import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 與 React 使用相同期望幾何，只觀察公開入口。
void main() {
	test('預設等分與間距守恆', () {
		const items = <KlpLinearItem>[KlpLinearItem(), KlpLinearItem(), KlpLinearItem()];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 5.0, gutterCount: 2, items: items);
		_check(result, extent: 100.0, gutterCount: 2, extents: [30.0, 30.0, 30.0], gutter: 5.0, unused: 0.0, compressed: false);
	});

	test('非整數 flex 與順序', () {
		const items = <KlpLinearItem>[KlpLinearItem(flex: 0.5), KlpLinearItem(flex: 1.5), KlpLinearItem(flex: 0.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [25.0, 75.0, 0.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('依序達 maximum 後再分配', () {
		const items = <KlpLinearItem>[KlpLinearItem(maximum: 10.0), KlpLinearItem(maximum: 30.0, flex: 2.0), KlpLinearItem(flex: 1.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [10.0, 30.0, 60.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('全部達 maximum 保留 unused', () {
		const items = <KlpLinearItem>[KlpLinearItem(maximum: 20.0), KlpLinearItem(maximum: 30.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 5.0, gutterCount: 1, items: items);
		_check(result, extent: 100.0, gutterCount: 1, extents: [20.0, 30.0], gutter: 5.0, unused: 45.0, compressed: false);
	});

	test('零 flex 保留 preferred 與 unused', () {
		const items = <KlpLinearItem>[KlpLinearItem(preferred: 20.0, flex: 0.0), KlpLinearItem(preferred: 30.0, flex: 0.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [20.0, 30.0], gutter: 0.0, unused: 50.0, compressed: false);
	});

	test('preferred 超量依 minimum 以上比例壓縮', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 10.0, preferred: 90.0), KlpLinearItem(minimum: 20.0, preferred: 60.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [56.666666666666664, 43.333333333333336], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('preferred clamp 於兩端限制', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 20.0, preferred: 5.0, flex: 0.0), KlpLinearItem(maximum: 30.0, preferred: 80.0, flex: 0.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [20.0, 30.0], gutter: 0.0, unused: 50.0, compressed: false);
	});

	test('minimum 不足只依 minimum 比例退化', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 40.0, preferred: 100.0, flex: 100.0), KlpLinearItem(minimum: 20.0, flex: 0.0), KlpLinearItem(flex: 100.0)];
		final result = resolveKlpLinearLayout(extent: 30.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 30.0, gutterCount: 0, extents: [20.0, 10.0, 0.0], gutter: 0.0, unused: 0.0, compressed: true);
	});

	test('恰好滿足 minimum 不標記壓縮', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 10.0, preferred: 80.0), KlpLinearItem(minimum: 20.0, preferred: 80.0)];
		final result = resolveKlpLinearLayout(extent: 30.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 30.0, gutterCount: 0, extents: [10.0, 20.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('巨大 gutter 壓縮占滿主軸', () {
		const items = <KlpLinearItem>[KlpLinearItem(), KlpLinearItem()];
		final result = resolveKlpLinearLayout(extent: 90.0, gutter: 1e+308, gutterCount: 3, items: items);
		_check(result, extent: 90.0, gutterCount: 3, extents: [0.0, 0.0], gutter: 30.0, unused: 0.0, compressed: true);
	});

	test('巨大 minimum 加總仍有限', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 1e+308), KlpLinearItem(minimum: 1e+308), KlpLinearItem(minimum: 5e+307)];
		final result = resolveKlpLinearLayout(extent: 90.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 90.0, gutterCount: 0, extents: [36.0, 36.0, 18.0], gutter: 0.0, unused: 0.0, compressed: true);
	});

	test('巨大 preferred 加總保留 minimum', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 10.0, preferred: 1e+308, flex: 0.0), KlpLinearItem(minimum: 20.0, preferred: 1e+308, flex: 0.0)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [45.0, 55.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('巨大 flex 正規化保留權重', () {
		const items = <KlpLinearItem>[KlpLinearItem(flex: 1e+308), KlpLinearItem(flex: 1e+308), KlpLinearItem(flex: 5e+307)];
		final result = resolveKlpLinearLayout(extent: 90.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 90.0, gutterCount: 0, extents: [36.0, 36.0, 18.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('巨大 flex 達上限再分配', () {
		const items = <KlpLinearItem>[KlpLinearItem(maximum: 10.0, flex: 1e+308), KlpLinearItem(flex: 1e+308)];
		final result = resolveKlpLinearLayout(extent: 100.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 100.0, gutterCount: 0, extents: [10.0, 90.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('巨大 extent 仍守恆', () {
		const items = <KlpLinearItem>[KlpLinearItem(), KlpLinearItem()];
		final result = resolveKlpLinearLayout(extent: 1e+308, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 1e+308, gutterCount: 0, extents: [5e+307, 5e+307], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('空 items 仍保留間距', () {
		const items = <KlpLinearItem>[];
		final result = resolveKlpLinearLayout(extent: 20.0, gutter: 3.0, gutterCount: 2, items: items);
		_check(result, extent: 20.0, gutterCount: 2, extents: [], gutter: 3.0, unused: 14.0, compressed: false);
	});

	test('零 extent 沒有 minimum', () {
		const items = <KlpLinearItem>[KlpLinearItem(), KlpLinearItem()];
		final result = resolveKlpLinearLayout(extent: 0.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 0.0, gutterCount: 0, extents: [0.0, 0.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('零 extent 與正 minimum', () {
		const items = <KlpLinearItem>[KlpLinearItem(minimum: 1.0)];
		final result = resolveKlpLinearLayout(extent: 0.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 0.0, gutterCount: 0, extents: [0.0], gutter: 0.0, unused: 0.0, compressed: true);
	});

	test('零 gutterCount 不扣間距', () {
		const items = <KlpLinearItem>[KlpLinearItem()];
		final result = resolveKlpLinearLayout(extent: 20.0, gutter: 0.0, gutterCount: 0, items: items);
		_check(result, extent: 20.0, gutterCount: 0, extents: [20.0], gutter: 0.0, unused: 0.0, compressed: false);
	});

	test('非法幾何於執行時拒絕且不修改 caller', () {
		for (final value in [-1.0, double.nan, double.infinity, double.negativeInfinity]) {
			expect(() => resolveKlpLinearLayout(extent: value, gutter: 0, gutterCount: 0, items: const []), throwsA(anything));
			expect(() => resolveKlpLinearLayout(extent: 100, gutter: value, gutterCount: 0, items: const []), throwsA(anything));
			for (final item in [
				KlpLinearItem(minimum: value),
				KlpLinearItem(maximum: value),
				KlpLinearItem(preferred: value),
				KlpLinearItem(flex: value),
			]) {
				final items = [item];
				expect(() => resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: 0, items: items), throwsA(anything));
				expect(items, [same(item)], reason: '拒絕非法資料不得改寫 caller');
			}
		}
		expect(() => resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: -1, items: const []), throwsA(anything));
		const item = KlpLinearItem(minimum: 2, maximum: 1);
		final items = [item];
		expect(() => resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: 0, items: items), throwsA(anything));
		expect(items, [same(item)]);
	});

	test('caller、result 及重複呼叫互相隔離', () {
		const left = KlpLinearItem(flex: 1);
		const right = KlpLinearItem(flex: 3);
		final items = [left, right];
		final first = resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: 0, items: items);
		_check(first, extent: 100, gutterCount: 0, extents: [25, 75], gutter: 0, unused: 0, compressed: false);
		expect(items, [same(left), same(right)], reason: '解析不得修改 caller');
		expect(() => first.extents[0] = 99, throwsUnsupportedError);
		expect(() => first.extents.add(1), throwsUnsupportedError);
		expect(() => first.extents.clear(), throwsUnsupportedError);
		final dynamic mutable = first;
		expect(() => mutable.gutter = 99, throwsNoSuchMethodError);
		expect(() => mutable.unused = 99, throwsNoSuchMethodError);
		expect(() => mutable.compressed = true, throwsNoSuchMethodError);
		items.removeLast();
		_check(resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: 0, items: items), extent: 100, gutterCount: 0, extents: [100], gutter: 0, unused: 0, compressed: false);
		expect(first.extents, [25, 75], reason: 'caller 後續改動不得污染舊結果');
		_check(resolveKlpLinearLayout(extent: 100, gutter: 0, gutterCount: 0, items: [left, right]), extent: 100, gutterCount: 0, extents: [25, 75], gutter: 0, unused: 0, compressed: false);
	});
}

void _close(double actual, double expected, String label) {
	expect(actual.isFinite && actual >= 0, isTrue, reason: '$label 必須有限非負');
	final scale = expected > 1 ? expected : 1.0;
	expect((actual - expected).abs(), lessThanOrEqualTo(1e-6 * scale), reason: '$label：$actual != $expected');
}

void _check(KlpLinearLayoutResult result, {
	required double extent,
	required int gutterCount,
	required List<double> extents,
	required double gutter,
	required double unused,
	required bool compressed,
}) {
	expect(result.extents.length, extents.length, reason: '項目次序與數量必須保留');
	for (var i = 0; i < extents.length; i++) {
		_close(result.extents[i], extents[i], 'extents[$i]');
	}
	_close(result.gutter, gutter, 'gutter');
	_close(result.unused, unused, 'unused');
	expect(result.compressed, compressed);
	final scale = extent > 1 ? extent : 1.0;
	final total = result.extents.fold<double>(0, (sum, value) => sum + value / scale)
		+ (result.gutter / scale) * gutterCount + result.unused / scale;
	expect((total - extent / scale).abs(), lessThanOrEqualTo(1e-6), reason: '內容、間距與留白必須守恆');
}
