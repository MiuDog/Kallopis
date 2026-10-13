import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis_catalog/modern_productivity_preview.dart';

// 驗證實際 paragraph／editable 的有效字型 metadata，不推論 engine 網路請求或像素 fallback。
void main() {
	testWidgets('模板與預覽正文、編輯器及首個下拉選單保留套件字型權威', (tester) async {
		tester.view.physicalSize = const Size(1400, 1100);
		tester.view.devicePixelRatio = 1;
		addTearDown(tester.view.resetPhysicalSize);
		addTearDown(tester.view.resetDevicePixelRatio);
		await tester.pumpWidget(const ModernProductivityPreview(id: 'modern-productivity-layout'));
		await tester.pumpAndSettle();
		_expectOwnedFonts(tester, '預設頁面');
		final dropdown = find.byWidgetPredicate((widget) => widget is DropdownButton);
		expect(dropdown, findsWidgets, reason: 'consumer 的第一個下拉選單必須可供驗證');
		await tester.tap(dropdown.first);
		await tester.pumpAndSettle();
		_expectOwnedFonts(tester, '開啟第一個下拉選單');
		expect(tester.takeException(), isNull);
		await tester.pumpWidget(const SizedBox());
		await tester.pumpAndSettle();
	});
}

void _expectOwnedFonts(WidgetTester tester, String phase) {
	final families = <String>{};
	final fallbackFamilies = <String>{};
	var paragraphs = 0;
	var editors = 0;
	var icons = 0;
	void check(InlineSpan span, TextStyle inherited) {
		final effective = inherited.merge(span.style);
		if (span is TextSpan) {
			if (span.text != null && span.text!.trim().isNotEmpty) {
				final family = effective.fontFamily;
				expect(family, startsWith('packages/kallopis/'), reason: '$phase 的實際文字 ${span.text} 未使用套件擁有字型');
				families.add(family!);
				for (final fallback in effective.fontFamilyFallback ?? const <String>[]) {
					fallbackFamilies.add(fallback);
				}
				if (family == 'packages/${KlpIconFonts.package}/${KlpIconFonts.regular}' || family == 'packages/${KlpIconFonts.package}/${KlpIconFonts.thin}') {
					icons++;
				}
			}
			for (final child in span.children ?? const <InlineSpan>[]) {
				check(child, effective);
			}
		}
	}
	for (final element in find.byType(RichText).evaluate()) {
		final render = element.renderObject;
		if (render is RenderParagraph && render.attached && render.hasSize && !render.size.isEmpty) {
			check(render.text, const TextStyle());
			paragraphs++;
		}
	}
	for (final element in find.byType(EditableText).evaluate()) {
		final widget = element.widget as EditableText;
		// 空白編輯器也驗證下一次輸入採用的有效 style，已有正文另讀真實 RenderEditable.text。
		expect(widget.style.fontFamily, startsWith('packages/kallopis/'), reason: '$phase 的編輯文字不得靜默使用宿主字型');
		families.add(widget.style.fontFamily!);
		var hasRenderer = false;
		void inspect(RenderObject render) {
			if (render is RenderEditable) {
				hasRenderer = true;
				if (render.text != null) check(render.text!, widget.style);
			}
			render.visitChildren(inspect);
		}
		inspect(element.renderObject!);
		expect(hasRenderer, isTrue, reason: '必須量測真正掛載的 RenderEditable');
		editors++;
	}
	expect(paragraphs, greaterThan(0));
	expect(editors, greaterThan(0), reason: '必須包含真實草稿／設定編輯器');
	expect(icons, greaterThan(0), reason: '實際圖示 paragraph 必須使用公開套件圖示字型');
	debugPrint('$phase：paragraph=$paragraphs editable=$editors icon=$icons families=${families.toList()..sort()} fallbackMetadata=${fallbackFamilies.toList()..sort()}');
}
