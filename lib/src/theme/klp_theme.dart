import 'package:flutter/material.dart';

import 'klp_data_visualization_theme.dart';
import 'klp_shape_theme.dart';
import 'klp_surface_theme.dart';
import 'klp_visual_style.dart';
import 'klp_theme_data.dart';
import '../tokens/primitive_token.dart';

// 元件 import 色彩層時一併取得 token 存取面（`context.klp` 與 `context.klpColors`），
// 否則每個元件都要 import 兩個 theme 檔才拿得到值——那種摩擦會讓人選擇寫死。
export 'klp_theme_data.dart';
export 'klp_theme_scope.dart';

/// 內建的 [KlpThemeData] 預設變體。[transparent] 目前解析為 [KlpThemeData.dark]
/// 的色彩再疊加透明度，不是一份獨立的色票——它描述的是「視窗背景可透」這個
/// 額外能力，而不是第四種配色。
enum KlpThemeVariant { light, dark, ultraDark, transparent }

/// 輸入欄位底色要跟隨的互動狀態。
///
/// 刻意把 [rest] 與 [hovered] 分開列舉，即使兩者目前解析成同一個顏色
/// （見 [KlpFieldStyle.colorFor]）——這是為了讓「hover 不改底色」這件事有
/// 名字可以在程式碼裡明確表達，而不是省略 hovered 這個 case 導致日後被誤判
/// 為漏寫。
enum KlpFieldFillState { rest, hovered, focused, selected, disabled, error }

/// 輸入欄位的邊框與底色查表工具。
abstract final class KlpFieldStyle {
	/// 需要 shape token，因此不能是無參數的 getter——欄位圓角屬於風格。
	static OutlineInputBorder borderFor(KlpShapeTheme shape) =>
			OutlineInputBorder(
				borderRadius: BorderRadius.circular(shape.control),
				borderSide: BorderSide.none,
			);

	/// 欄位底色。
	///
	/// **hover 以高亮底色表達，不畫邊框。** 欄位本來就有自己的底色，狀態直接反映在
	/// 那個底色上，不必在外面再包一層框——包框會讓欄位在 hover 時尺寸感改變，
	/// 也讓同一個狀態在欄位與其他元件長得不一樣。
	///
	/// 高亮是把前景色以低 alpha 疊上去，因此亮態壓暗、暗態提亮，且不必知道底下
	/// 實際是哪個表面。
	static Color colorFor(
		KlpThemeData tokens,
		KlpFieldFillState state, {
		KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
	}) {
		return switch (state) {
			KlpFieldFillState.rest => tokens.surfaceInset,
			KlpFieldFillState.hovered => Color.alphaBlend(
				tokens.selectionWashWith(surface.selectionWashOpacity),
				tokens.surfaceInset,
			),
			KlpFieldFillState.focused ||
			KlpFieldFillState.selected => Color.alphaBlend(
				tokens.interaction.withValues(alpha: surface.focusWashOpacity),
				tokens.surfaceInset,
			),
			KlpFieldFillState.disabled => tokens.surfaceMuted,
			// 不合法輸入用半透明紅**疊在**欄位上，而不是先跟 surfaceInset 混成不透明色。
			// 疊層才會跟著底下實際的表面走；預混會在欄位被放到別的表面上時顏色對不上。
			KlpFieldFillState.error => tokens.danger.withValues(
				alpha: surface.invalidFillOpacity,
			),
		};
	}

	static Color resolveInputColor(
		KlpThemeData tokens,
		Set<WidgetState> states, {
		KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
	}) {
		if (states.contains(WidgetState.disabled)) {
			return colorFor(tokens, KlpFieldFillState.disabled, surface: surface);
		}
		if (states.contains(WidgetState.error)) {
			return colorFor(tokens, KlpFieldFillState.error, surface: surface);
		}
		if (states.contains(WidgetState.focused)) {
			return colorFor(tokens, KlpFieldFillState.focused, surface: surface);
		}
		if (states.contains(WidgetState.hovered)) {
			return colorFor(tokens, KlpFieldFillState.hovered, surface: surface);
		}

		return colorFor(tokens, KlpFieldFillState.rest, surface: surface);
	}

	static WidgetStateColor inputFill(
		KlpThemeData tokens, {
		bool error = false,
		KlpSurfaceTheme surface = KlpSurfaceTheme.elevated,
	}) {
		return WidgetStateColor.resolveWith(
			(states) => error
					? colorFor(tokens, KlpFieldFillState.error, surface: surface)
					: resolveInputColor(tokens, states, surface: surface),
		);
	}
}

/// 由一套視覺風格建出 `ThemeData`。
///
/// 色彩的來源規則刻意是**明確的，不做推測**：
///
/// - 不給 [style]：依 [brightness] 取內建 preset，套用 defaultStyle 風格。
/// - 給了 [style]：**`style.colors` 就是色彩，[brightness] 不再干涉。**
///
/// 曾經試過「偵測消費者有沒有動過色彩，沒動過才依 brightness 挑」，那是行不通的：
/// Dart 會把欄位值相同的 `const` 實例正規化成同一個物件，因此一組剛好等於內建
/// preset 的自訂色盤會被誤判為未修改，然後被靜默換掉。**能被靜默搞錯的推測就不要做。**
///
/// [accent] 為 `null` 時保留色彩層原本的 interaction 色；給定值才覆寫它。
ThemeData buildKlpTheme(
	Brightness brightness, {
	KlpAccent? accent,
	KlpVisualStyle? style,
}) {
	final baseTokens = style != null
			? style.colors
			: (brightness == Brightness.dark
						? KlpThemeData.dark
						: KlpThemeData.light);
	final effectiveStyle = style ?? KlpVisualStyle.forBrightness(brightness);
	return _buildKlpThemeData(baseTokens, accent: accent, style: effectiveStyle);
}

ThemeData buildKlpThemeVariant(
	KlpThemeVariant variant, {
	KlpAccent? accent,
	bool transparencyEnabled = false,
	KlpVisualStyle? style,
}) {
	final tokens = switch (variant) {
		KlpThemeVariant.light => KlpThemeData.light,
		KlpThemeVariant.dark => KlpThemeData.dark,
		KlpThemeVariant.ultraDark => KlpThemeData.ultraDark,
		KlpThemeVariant.transparent => KlpThemeData.dark,
	};

	final effectiveStyle =
			style ??
			KlpVisualStyle.defaultStyle.copyWith(
				colors: tokens,
				dataVisualization: switch (variant) {
					KlpThemeVariant.light => KlpDataVisualizationTheme.light,
					KlpThemeVariant.dark => KlpDataVisualizationTheme.dark,
					KlpThemeVariant.ultraDark => KlpDataVisualizationTheme.ultraDark,
					KlpThemeVariant.transparent => KlpDataVisualizationTheme.dark,
				},
			);
	final effectiveTokens = style?.colors ?? tokens;

	return _buildKlpThemeData(
		effectiveTokens,
		accent: accent,
		style: effectiveStyle,
		transparencyEnabled:
				transparencyEnabled || variant == KlpThemeVariant.transparent,
	);
}

ThemeData _buildKlpThemeData(
	KlpThemeData baseTokens, {
	KlpAccent? accent,
	bool transparencyEnabled = false,
	KlpVisualStyle style = KlpVisualStyle.defaultStyle,
}) {
	// 由實際的表面色推導明暗，而不是比對是否為某個 preset 實例——自訂色盤永遠不會
	// `identical` 於 preset，用 identical 判斷會讓所有自訂主題都被當成暗色。
	final brightness = baseTokens.app.computeLuminance() > 0.5
			? Brightness.light
			: Brightness.dark;
	final interactionColor = accent?.resolve(brightness);
	final themedTokens = interactionColor == null
			? baseTokens
			: baseTokens.copyWith(
					interaction: interactionColor,
					interactionSoft: Color.alphaBlend(
						interactionColor.withValues(
							alpha: brightness == Brightness.dark
									? style.surface.accentSoftOpacityDark
									: style.surface.accentSoftOpacityLight,
						),
						baseTokens.surfaceInset,
					),
				);
	final tokens = transparencyEnabled
			? themedTokens.withWindowTransparency(
					brightness,
					surfaceTheme: style.surface,
				)
			: themedTokens;
	final baseTextTheme = ThemeData(
		brightness: brightness,
		useMaterial3: false,
		fontFamily: style.typography.uiFamily,
		fontFamilyFallback: style.typography.fallbackFor(style.typography.uiFamily),
	).textTheme;
	final textTheme = baseTextTheme.copyWith(
		displayLarge: baseTextTheme.displayLarge?.copyWith(color: tokens.text),
		displayMedium: baseTextTheme.displayMedium?.copyWith(color: tokens.text),
		displaySmall: baseTextTheme.displaySmall?.copyWith(color: tokens.text),
		headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: tokens.text),
		headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: tokens.text),
		headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: tokens.text),
		titleLarge: baseTextTheme.titleLarge?.copyWith(color: tokens.text),
		titleMedium: baseTextTheme.titleMedium?.copyWith(color: tokens.text),
		titleSmall: baseTextTheme.titleSmall?.copyWith(color: tokens.text),
		bodyLarge: baseTextTheme.bodyLarge?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.body,
		),
		bodyMedium: baseTextTheme.bodyMedium?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.body,
		),
		bodySmall: baseTextTheme.bodySmall?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.caption,
		),
		labelLarge: baseTextTheme.labelLarge?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.body,
		),
		labelMedium: baseTextTheme.labelMedium?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.caption,
		),
		labelSmall: baseTextTheme.labelSmall?.copyWith(
			color: tokens.textMuted,
			fontSize: style.typography.caption,
			fontWeight: style.typography.regular,
		),
	);

	return ThemeData(
		brightness: brightness,
		useMaterial3: false,
		splashFactory: NoSplash.splashFactory,
		splashColor: tokens.clear,
		highlightColor: tokens.clear,
		scaffoldBackgroundColor: tokens.app,
		fontFamily: style.typography.uiFamily,
		fontFamilyFallback: style.typography.fallbackFor(style.typography.uiFamily),
		textTheme: textTheme,
		colorScheme: ColorScheme.fromSeed(
			seedColor: tokens.interaction,
			brightness: brightness,
			surface: tokens.surface,
		),
		inputDecorationTheme: InputDecorationTheme(
			border: KlpFieldStyle.borderFor(style.shape),
			enabledBorder: KlpFieldStyle.borderFor(style.shape),
			focusedBorder: KlpFieldStyle.borderFor(style.shape),
			disabledBorder: KlpFieldStyle.borderFor(style.shape),
			errorBorder: KlpFieldStyle.borderFor(style.shape),
			focusedErrorBorder: KlpFieldStyle.borderFor(style.shape),
			hoverColor: tokens.clear,
		),
		scrollbarTheme: ScrollbarThemeData(
			thumbColor: WidgetStatePropertyAll(tokens.textFaint),
			trackColor: WidgetStatePropertyAll(tokens.clear),
			trackBorderColor: WidgetStatePropertyAll(tokens.clear),
			thickness: WidgetStatePropertyAll(
				style.geometry.control.scrollbarThickness,
			),
			radius: Radius.circular(style.shape.pill),
			trackVisibility: const WidgetStatePropertyAll(false),
		),
		tooltipTheme: TooltipThemeData(
			decoration: BoxDecoration(
				color: tokens.overlay,
				borderRadius: BorderRadius.circular(style.shape.control),
			),
			textStyle: TextStyle(
				color: tokens.textMuted,
				fontSize: style.typography.caption,
				fontFamily: style.typography.uiFamily,
				fontFamilyFallback: style.typography.fallbackFor(
					style.typography.uiFamily,
				),
			),
			padding: EdgeInsets.symmetric(
				horizontal: style.spacing.overlayContentInset,
				vertical: style.spacing.tight,
			),
			waitDuration: style.motion.tooltipDelay,
			showDuration: style.motion.tooltipDwell,
			preferBelow: false,
		),
		// 註冊完整的 token 疊層。少放任何一層，該層會回退預設而不會報錯——
		// 因此這裡以 KlpVisualStyle 為單一來源，避免逐項列舉時漏掉。
		extensions: [...style.copyWith(colors: tokens).extensions],
	);
}
