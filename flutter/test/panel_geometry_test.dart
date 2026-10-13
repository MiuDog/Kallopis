import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 僅觀察 caller 提供的槽與公開元件，不依賴私有 Widget 樹或視覺快照。
void main() {
	testWidgets('正常面板保留 semantic chrome 高度並將剩餘高度交給正文', (tester) async {
		final tokens = KlpStylePack.defaults().resolve(KlpThemeVariant.light);
		final margin = _token(tokens, 'spacing.dockMargin');
		final header = _token(tokens, 'spacing.chromeHeader');
		final footer = _token(tokens, 'spacing.chromeStatusBar');
		final inset = _token(tokens, 'spacing.chromePanelInset');
		await _pump(tester, _frame());
		_expectRect(tester, 'header', Rect.fromLTWH(margin, margin, 400 - margin * 2, header));
		_expectRect(tester, 'content', Rect.fromLTWH(margin, margin + header, 400 - margin * 2, 300 - margin * 2 - header - footer));
		_expectRect(tester, 'footer', Rect.fromLTWH(margin + inset, 300 - margin - footer, 400 - margin * 2 - inset * 2, footer));
		expect(tester.takeException(), isNull);
	});

	testWidgets('沒有 chrome 時正文取得全部內框', (tester) async {
		final margin = _token(KlpStylePack.defaults().resolve(KlpThemeVariant.light), 'spacing.dockMargin');
		await _pump(tester, KlpPanelFrame(content: _slot('content')));
		_expectRect(tester, 'content', Rect.fromLTWH(margin, margin, 400 - margin * 2, 300 - margin * 2));
		expect(tester.takeException(), isNull);
	});

	testWidgets('短面板按比例收縮 chrome 並保留零正文槽', (tester) async {
		final tokens = KlpStylePack.defaults().resolve(KlpThemeVariant.light);
		final margin = _token(tokens, 'spacing.dockMargin');
		final header = _token(tokens, 'spacing.chromeHeader');
		final footer = _token(tokens, 'spacing.chromeStatusBar');
		final inset = _token(tokens, 'spacing.chromePanelInset');
		final height = margin * 2 + (header + footer) / 3;
		await _pump(tester, _frame(), height: height);
		_expectRect(tester, 'header', Rect.fromLTWH(margin, margin, 400 - margin * 2, header / 3));
		_expectRect(tester, 'content', Rect.fromLTWH(margin, margin + header / 3, 400 - margin * 2, 0));
		_expectRect(tester, 'footer', Rect.fromLTWH(margin + inset, margin + header / 3, 400 - margin * 2 - inset * 2, footer / 3));
		expect(tester.takeException(), isNull);
	});

	testWidgets('零尺寸及單軸零尺寸仍保留有限非負槽', (tester) async {
		final tokens = KlpStylePack.defaults().resolve(KlpThemeVariant.light);
		final margin = _token(tokens, 'spacing.dockMargin');
		final inset = _token(tokens, 'spacing.chromePanelInset');
		for (final size in [Size.zero, const Size(0, 300), const Size(400, 0)]) {
			await _pump(tester, _frame(), width: size.width, height: size.height);
			final horizontal = math.min(margin, size.width / 2);
			final vertical = math.min(margin, size.height / 2);
			final rects = [for (final id in ['header', 'content', 'footer']) _rect(tester, id)];
			for (var index = 0; index < rects.length; index++) {
				final rect = rects[index];
				final footerInset = index == 2 ? math.min(inset, (size.width - horizontal * 2) / 2) : 0;
				_expectFiniteRect(rect);
				expect(rect.left, closeTo(horizontal + footerInset, 1e-6));
				expect(rect.right, closeTo(size.width - horizontal - footerInset, 1e-6));
				expect(rect.top, greaterThanOrEqualTo(vertical - 1e-6));
				expect(rect.bottom, lessThanOrEqualTo(size.height - vertical + 1e-6));
			}
			expect(rects.fold<double>(0, (sum, rect) => sum + rect.height), closeTo(size.height - vertical * 2, 1e-6));
			expect(tester.takeException(), isNull, reason: '有限尺寸 $size 不得產生 layout exception');
		}
	});

	testWidgets('合法巨大外距與 chrome 依有限可用空間限制', (tester) async {
		final hugeMargin = _pack({'spacing.dockMargin': 'p(radiusFull)'});
		await _pump(tester, _frame(), pack: hugeMargin);
		for (final id in ['header', 'content', 'footer']) {
			_expectRect(tester, id, const Rect.fromLTWH(200, 150, 0, 0));
		}
		expect(tester.takeException(), isNull);
		final hugeChrome = _pack({
			'spacing.dockMargin': 'p(space0)',
			'spacing.chromeHeader': 'p(radiusFull)',
			'spacing.chromeStatusBar': 'p(radiusFull)',
		});
		await _pump(tester, _frame(), pack: hugeChrome);
		_expectRect(tester, 'header', const Rect.fromLTWH(0, 0, 400, 150));
		_expectRect(tester, 'content', const Rect.fromLTWH(0, 150, 400, 0));
		final inset = _token(hugeChrome.resolve(KlpThemeVariant.light), 'spacing.chromePanelInset');
		_expectRect(tester, 'footer', Rect.fromLTWH(inset, 150, 400 - inset * 2, 150));
		expect(tester.takeException(), isNull);
	});

	testWidgets('stroke 大於 card 的合法 style 不產生負圓角 exception', (tester) async {
		final pack = _pack({'shape.card': 'p(space0)', 'shape.stroke': 'p(space100)'});
		await _pump(tester, _frame(), pack: pack);
		_expectFiniteRect(_rect(tester, 'content'));
		expect(tester.takeException(), isNull);
	});

	testWidgets('公開 Header 的 title label leading actions 在窄低及巨大 inset 下保持節點', (tester) async {
		final leadingKey = GlobalKey();
		final actionKey = GlobalKey();
		final header = KlpPanelHeader(
			title: '很長的標題必須保留並省略水平文字',
			label: '保留的標籤',
			leading: SizedBox(key: leadingKey, width: 24, height: 24),
			actions: [SizedBox(key: actionKey, width: 32, height: 24)],
		);
		await _pump(tester, header, width: 300, height: 60);
		final leadingElement = leadingKey.currentContext;
		final actionElement = actionKey.currentContext;
		for (final size in [const Size(30, 8), Size.zero]) {
			await _pump(tester, header, width: size.width, height: size.height);
			expect(find.text('很長的標題必須保留並省略水平文字'), findsOneWidget);
			expect(find.text('保留的標籤'), findsOneWidget);
			expect(leadingKey.currentContext, same(leadingElement));
			expect(actionKey.currentContext, same(actionElement));
			expect(tester.takeException(), isNull, reason: 'Header 在 $size 不得造成庫內 overflow');
		}
		await _pump(tester, header, width: 30, height: 8, pack: _pack({
			'spacing.chromePanelInset': 'p(radiusFull)',
			'spacing.controlPaddingY': 'p(radiusFull)',
		}));
		expect(leadingKey.currentContext, same(leadingElement));
		expect(actionKey.currentContext, same(actionElement));
		expect(tester.takeException(), isNull);
	});

	testWidgets('Footer 保留自訂 directional padding 並按每軸比例限制巨大 inset', (tester) async {
		const padding = EdgeInsetsDirectional.fromSTEB(10, 4, 30, 6);
		final footer = KlpPanelFooter(padding: padding, child: _slot('footer-content'));
		await _pump(tester, footer, width: 100, height: 40);
		_expectRect(tester, 'footer-content', const Rect.fromLTWH(10, 4, 60, 30));
		await _pump(tester, footer, width: 100, height: 40, direction: TextDirection.rtl);
		_expectRect(tester, 'footer-content', const Rect.fromLTWH(30, 4, 60, 30));
		await _pump(tester, footer, width: 20, height: 5, direction: TextDirection.rtl);
		_expectRect(tester, 'footer-content', const Rect.fromLTWH(15, 2, 0, 0));
		expect(tester.takeException(), isNull);
		await _pump(tester, KlpPanelFooter(child: _slot('footer-content')), width: 20, height: 5,
			pack: _pack({'spacing.chromePanelInset': 'p(radiusFull)'}));
		_expectRect(tester, 'footer-content', const Rect.fromLTWH(10, 0, 0, 5));
		expect(tester.takeException(), isNull);
	});

	testWidgets('resize 與合法 theme 更新保持正文 Element State 及本地資料', (tester) async {
		final key = GlobalKey<_ContentState>();
		final frame = KlpPanelFrame(header: _slot('header'), content: _Content(key: key), footer: _slot('footer'));
		await _pump(tester, frame);
		final originalState = key.currentState!;
		final originalElement = key.currentContext;
		originalState.increment();
		await tester.pump();
		for (final size in [const Size(120, 30), Size.zero, const Size(400, 300)]) {
			await _pump(tester, frame, width: size.width, height: size.height);
			expect(key.currentState, same(originalState));
			expect(key.currentContext, same(originalElement));
			expect(key.currentState!.value, 1);
			expect(tester.takeException(), isNull);
		}
		await _pump(tester, frame, pack: _pack({'spacing.dockMargin': 'p(space0)', 'spacing.chromeHeader': 'p(radiusFull)'}));
		expect(key.currentState, same(originalState));
		expect(key.currentContext, same(originalElement));
		expect(key.currentState!.value, 1);
		expect(tester.takeException(), isNull);
	});
}

Widget _slot(String id) => SizedBox.expand(key: ValueKey(id));

Widget _frame() => KlpPanelFrame(header: _slot('header'), content: _slot('content'), footer: _slot('footer'));

KlpStylePack _pack(Map<String, String> expressions) => KlpStylePack.defaults().applyOverrides({
	'semantics': {for (final entry in expressions.entries) 'theme.${entry.key}': {'light': entry.value}},
});

double _token(Map<String, Object?> tokens, String id) => (tokens['theme.$id'] as num).toDouble();

Future<void> _pump(WidgetTester tester, Widget child, {double width = 400, double height = 300,
	KlpStylePack? pack, TextDirection direction = TextDirection.ltr}) async {
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: pack),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Directionality(textDirection: direction, child: Align(
			alignment: Alignment.topLeft,
			child: SizedBox(width: width, height: height, child: child),
		))),
	));
	await tester.pumpAndSettle();
}

Rect _rect(WidgetTester tester, String id) => tester.getRect(find.byKey(ValueKey(id)));

void _expectFiniteRect(Rect rect) {
	for (final value in [rect.left, rect.top, rect.width, rect.height]) {
		expect(value.isFinite, isTrue, reason: '槽 geometry 必須有限');
	}
	for (final value in [rect.width, rect.height]) {
		expect(value, greaterThanOrEqualTo(0), reason: '槽尺寸不得為負');
	}
}

void _expectRect(WidgetTester tester, String id, Rect expected) {
	final actual = _rect(tester, id);
	_expectFiniteRect(actual);
	for (final pair in [(actual.left, expected.left), (actual.top, expected.top), (actual.width, expected.width), (actual.height, expected.height)]) {
		expect(pair.$1, closeTo(pair.$2, 1e-6), reason: '$id 槽須符合有限分配契約');
	}
}

class _Content extends StatefulWidget {
	const _Content({super.key});

	@override
	State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
	int value = 0;

	void increment() => setState(() => value++);

	@override
	Widget build(BuildContext context) => const SizedBox.expand();
}
