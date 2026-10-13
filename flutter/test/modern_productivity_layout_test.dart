import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 從公開入口與 consumer 內容觀察契約，不使用私有布局或視覺快照。
void main() {
	testWidgets('Header 只占右區，側欄全高且 semantic inset 只套一次', (tester) async {
		final pack = _pack({
			'spacing.space2': 'p(space300)',
			'spacing.chromeHeader': 'p(space1000)',
			'geometry.layout.primaryPaneWidth': 'p(length-300)',
			'geometry.control.buttonHeight': 'p(space1000)',
			'shape.panel': 'p(space400)',
		});
		final tokens = pack.resolve(KlpThemeVariant.light);
		final gap = _token(tokens, 'spacing.space2');
		final width = _token(tokens, 'geometry.layout.primaryPaneWidth');
		final headerHeight = _token(tokens, 'spacing.chromeHeader');
		await _pump(tester, _layout(), pack: pack);
		final sidebar = tester.getRect(_sidebar(tester));
		expect(sidebar, Rect.fromLTWH(gap, gap, width, 400 - gap * 2));
		_expectRect(tester, 'header', Rect.fromLTWH(gap + width + gap, gap, 800 - gap * 3 - width, headerHeight));
		_expectRect(tester, 'stage', Rect.fromLTWH(gap + width + gap, gap + headerHeight, 800 - gap * 3 - width, 400 - gap * 2 - headerHeight));
		for (final button in tester.widgetList<KlpButton>(find.byType(KlpButton))) {
			expect(tester.getSize(find.byWidget(button)).height, _token(tokens, 'geometry.control.buttonHeight'));
		}
		var hasPanelRadius = false;
		tester.element(find.byKey(const ValueKey('a-content'))).visitAncestorElements((element) {
			final widget = element.widget;
			if (widget is DecoratedBox && widget.decoration is BoxDecoration && (widget.decoration as BoxDecoration).borderRadius == BorderRadius.circular(_token(tokens, 'shape.panel'))) {
				final rect = tester.getRect(find.byElementPredicate((candidate) => identical(candidate, element)));
				if (rect == sidebar) hasPanelRadius = true;
			}
			return true;
		});
		expect(hasPanelRadius, isTrue, reason: '側欄必須使用 semantic panel 圓角');
		expect(tester.takeException(), isNull);
		await _pump(tester, _layout(sidebarWidth: 180, header: const SizedBox(key: ValueKey('header'), height: 96)), pack: pack);
		expect(tester.getSize(_sidebar(tester)).width, 180);
		expect(_rect(tester, 'stage').top, gap + 96);
		expect(tester.getSize(_sidebar(tester)).height, 400 - gap * 2);
		expect(tester.takeException(), isNull);
	});

	testWidgets('零與窄宿主仍輸出有限非負尺寸而不溢出', (tester) async {
		for (final size in [Size.zero, const Size(0, 200), const Size(80, 400), const Size(800, 0)]) {
			await _pump(tester, _layout(), width: size.width, height: size.height);
			for (final finder in [_sidebar(tester), find.byKey(const ValueKey('header')), find.byKey(const ValueKey('stage'))]) {
				final rect = tester.getRect(finder);
				for (final value in [rect.left, rect.top, rect.width, rect.height]) expect(value.isFinite, isTrue);
				expect(rect.width, greaterThanOrEqualTo(0));
				expect(rect.height, greaterThanOrEqualTo(0));
				expect(rect.right, lessThanOrEqualTo(size.width + 1e-6));
				expect(rect.bottom, lessThanOrEqualTo(size.height + 1e-6));
			}
			expect(tester.takeException(), isNull, reason: '有限宿主 $size 不得產生 overflow');
		}
	});

	testWidgets('切換受控；目前項不發事件，沒有 callback 時全部停用', (tester) async {
		final events = <String>[];
		await _pump(tester, _layout(onSelected: events.add));
		await tester.tap(find.text('甲功能'));
		expect(events, isEmpty);
		await tester.tap(find.text('乙功能'));
		expect(events, ['b']);
		expect(find.byKey(const ValueKey('a-content')), findsOneWidget);
		expect(find.byKey(const ValueKey('b-content')), findsNothing, reason: 'consumer 未提交 selectedId 前不得自行切換');
		await _pump(tester, _layout(selectedId: 'b'));
		expect(find.byKey(const ValueKey('b-content')), findsOneWidget);
		await tester.tap(find.text('甲功能'));
		expect(events, ['b']);
		expect(tester.takeException(), isNull);
	});

	testWidgets('stable id 保留 A-B-A 草稿與重排身分；inactive 隔離焦點與可存取樹', (tester) async {
		final semantics = tester.ensureSemantics();
		final focusA = FocusNode();
		final focusB = FocusNode();
		addTearDown(focusA.dispose);
		addTearDown(focusB.dispose);
		List<KlpModernProductivityPanel> panels(bool reverse) {
			final items = [
				KlpModernProductivityPanel(id: 'a', label: '甲功能', content: TextField(key: const ValueKey('draft-a'), focusNode: focusA, decoration: const InputDecoration(labelText: '甲草稿'))),
				KlpModernProductivityPanel(id: 'b', label: '乙功能', content: TextField(key: const ValueKey('draft-b'), focusNode: focusB, decoration: const InputDecoration(labelText: '乙草稿'))),
			];
			return reverse ? items.reversed.toList() : items;
		}
		await _pump(tester, _layout(panels: panels(false)));
		final original = tester.element(find.byKey(const ValueKey('draft-a')));
		await tester.enterText(find.byKey(const ValueKey('draft-a')), '未保存的甲草稿');
		expect(find.bySemanticsLabel('乙草稿'), findsNothing);
		focusB.requestFocus();
		await tester.pump();
		expect(focusB.hasFocus, isFalse);
		await _pump(tester, _layout(selectedId: 'b', panels: panels(false)));
		expect(find.bySemanticsLabel('甲草稿'), findsNothing);
		focusA.requestFocus();
		await tester.pump();
		expect(focusA.hasFocus, isFalse);
		await tester.enterText(find.byKey(const ValueKey('draft-b')), '未保存的乙草稿');
		await _pump(tester, _layout(panels: panels(true)));
		expect(tester.element(find.byKey(const ValueKey('draft-a'))), same(original));
		expect(find.text('未保存的甲草稿'), findsOneWidget);
		await _pump(tester, _layout(selectedId: 'b', panels: panels(true)));
		expect(find.text('未保存的乙草稿'), findsOneWidget);
		expect(tester.takeException(), isNull);
		semantics.dispose();
		await tester.pumpWidget(const SizedBox());
	});

	testWidgets('非法公開輸入明確拒絕而不發事件', (tester) async {
		final events = <String>[];
		final valid = _panels();
		final invalid = <Map<String, Object?>>[
			{'panels': <KlpModernProductivityPanel>[]},
			{'panels': [valid.first, valid.first]},
			{'panels': [const KlpModernProductivityPanel(id: '', label: '甲', content: SizedBox())]},
			{'panels': [const KlpModernProductivityPanel(id: 'a', label: '', content: SizedBox())]},
			{'selectedId': 'missing'},
			for (final value in [0.0, -1.0, double.infinity, double.nan]) {'sidebarWidth': value},
		];
		for (final values in invalid) {
			Object? failure;
			try {
				await _pump(tester, _layout(panels: values['panels'] as List<KlpModernProductivityPanel>?, selectedId: values['selectedId'] as String? ?? 'a', sidebarWidth: values['sidebarWidth'] as double?, onSelected: events.add));
				failure = tester.takeException();
			} catch (error) {
				failure = error;
			}
			expect(failure, isArgumentError, reason: '$values 必須由公開邊界拒絕');
			expect(events, isEmpty);
			await tester.pumpWidget(const SizedBox());
		}
	});
}

List<KlpModernProductivityPanel> _panels() => const [
	KlpModernProductivityPanel(id: 'a', label: '甲功能', content: SizedBox.expand(key: ValueKey('a-content'))),
	KlpModernProductivityPanel(id: 'b', label: '乙功能', content: SizedBox.expand(key: ValueKey('b-content'))),
];

Widget _layout({List<KlpModernProductivityPanel>? panels, String selectedId = 'a', ValueChanged<String>? onSelected, double? sidebarWidth, Widget header = const SizedBox.expand(key: ValueKey('header'))}) => KlpModernProductivityLayout(
	panels: panels ?? _panels(), selectedId: selectedId, onSelected: onSelected,
	header: header, stage: const SizedBox.expand(key: ValueKey('stage')), sidebarWidth: sidebarWidth,
);

KlpStylePack _pack(Map<String, String> values) => KlpStylePack.defaults().applyOverrides({
	'semantics': {for (final entry in values.entries) 'theme.${entry.key}': {'light': entry.value}},
});
double _token(dynamic tokens, String name) => (tokens['theme.$name'] as num).toDouble();

Future<void> _pump(WidgetTester tester, Widget child, {double width = 800, double height = 400, KlpStylePack? pack}) async {
	await tester.pumpWidget(MaterialApp(
		theme: buildKlpThemeVariant(KlpThemeVariant.light, stylePack: pack),
		localizationsDelegates: const [KlpLocalizationsDelegate()],
		home: Scaffold(body: Align(alignment: Alignment.topLeft, child: SizedBox(width: width, height: height, child: child))),
	));
	await tester.pumpAndSettle();
}
Rect _rect(WidgetTester tester, String id) => tester.getRect(find.byKey(ValueKey(id)));

// 側欄由產品面板與 switcher 的最小共同繪製祖先識別，不限定框架內部組合型別。
Finder _sidebar(WidgetTester tester) {
	final switcherAncestors = <Element>{};
	tester.element(find.text('甲功能')).visitAncestorElements((element) {
		switcherAncestors.add(element);
		return true;
	});
	Element? region;
	tester.element(find.byKey(const ValueKey('a-content'))).visitAncestorElements((element) {
		if (switcherAncestors.contains(element) && element.widget is RenderObjectWidget) {
			region = element;
			return false;
		}
		return true;
	});
	expect(region, isNotNull, reason: '面板與 switcher 須位於同一側欄');
	return find.byElementPredicate((element) => identical(element, region));
}
void _expectRect(WidgetTester tester, String id, Rect expected) {
	final actual = _rect(tester, id);
	for (final pair in [(actual.left, expected.left), (actual.top, expected.top), (actual.width, expected.width), (actual.height, expected.height)]) {
		expect(pair.$1.isFinite, isTrue);
		expect(pair.$1, closeTo(pair.$2, 1e-6), reason: '$id 位置與尺寸須符合共同契約');
	}
}
