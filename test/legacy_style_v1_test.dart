import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_theme.dart';

void main() {
	// 確認預設角色及深色層級，不綁定尚未定型的畫面。
	test('v1 legacy theme preserves surface hierarchy and control geometry', () {
		const light = KlpThemeData.light;
		const dark = KlpThemeData.dark;
		expect(light.app, const Color(0xFFE7E4DD));
		expect(light.surface, const Color(0xFFEFEDE7));
		expect(light.component, const Color(0xFFF8F6F1));
		expect(dark.app, const Color(0xFF201F1C));
		expect(dark.surface, const Color(0xFF292724));
		expect(dark.component, const Color(0xFF35322D));
		expect(dark.app.computeLuminance(), lessThan(dark.surface.computeLuminance()));
		expect(dark.surface.computeLuminance(), lessThan(dark.component.computeLuminance()));
		const style = KlpVisualStyle.defaultStyle;
		expect(style.shape.control, 6);
		expect(style.shape.controlInner, 5);
		expect(style.shape.card, 7);
		expect(style.shape.panel, 12);
		expect(style.spacing.controlInset, 8);
	});

	// 陰影配方必須雙層且可由風格關閉，深色文字不可變成白色光暈。
	test('v1 shadow uses two black layers and supports disabling', () {
		const surface = KlpSurfaceTheme.elevated;
		for (final foreground in [KlpThemeData.light.text, KlpThemeData.dark.text]) {
			final shadows = surface.overlayShadow(foreground);
			expect(shadows, hasLength(2));
			expect(shadows[0].color, const Color(0x22000000));
			expect(shadows[0].blurRadius, 3);
			expect(shadows[0].offset, const Offset(0, 2));
			expect(shadows[0].spreadRadius, 0);
			expect(shadows[1].color, const Color(0x22000000));
			expect(shadows[1].blurRadius, 20);
			expect(shadows[1].offset, const Offset(0, 8));
			expect(shadows[1].spreadRadius, 0);
		}
		expect(surface.copyWith(separation: KlpSurfaceSeparation.tone).overlayShadow(Colors.black), isEmpty);
	});

	// 自訂值須穿過序列化與主題相等性，避免保存後靜默回到預設。
	test('v1 shadow customization round trips through JSON and lerp', () {
		const base = KlpVisualStyle.defaultStyle;
		final customSurface = base.surface.copyWith(
			contactBlur: 5,
			contactOffsetY: 1,
			contactShadowOpacity: 0.2,
			overlayShadowColor: const Color(0xFF442211),
		);
		final custom = base.copyWith(surface: customSurface);
		final decoded = KlpVisualStyleJson.decode(KlpVisualStyleJson.encode(custom));
		expect(decoded.surface, customSurface);
		expect(customSurface, isNot(base.surface));
		expect(base.surface.lerp(customSurface, 0.25), base.surface);
		expect(base.surface.lerp(customSurface, 0.75), customSurface);
		expect(customSurface.copyWith(contactShadowOpacity: 0).overlayShadow(Colors.black), hasLength(1));
	});
}
