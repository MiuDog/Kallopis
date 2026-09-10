import 'package:flutter/widgets.dart';

import '../../styling/legacy_theme/klp_theme.dart';
import '../../styling/legacy_theme/klp_typography_theme.dart';
import 'klp_font_role.dart';
import 'klp_text_color_tier.dart';
import 'klp_text_role.dart';
import 'klp_text_style_definition.dart';
import 'klp_text_tone.dart';

export 'klp_font_role.dart';
export 'klp_text_color_tier.dart';
export 'klp_text_role.dart';
export 'klp_text_style_definition.dart';
export 'klp_text_tracking.dart';
export 'klp_text_tone.dart';
export 'klp_text_widget.dart';

/// 把 [KlpTextRole] 解析成具體樣式與顏色的靜態工具集合。[KlpText] 內部就是
/// 透過這個類別取得樣式，只有要繞過 [KlpText]（例如自訂 `RichText`）時才需要
/// 直接呼叫 [definitionOf] 或 [colorFor]。
abstract final class KlpTextStyles {
	/// 字級與行高由 theme 決定，因此不能是編譯期常數的 map。
	static Map<KlpTextRole, KlpTextStyleDefinition> definitionsFor(
		KlpTypographyTheme type,
	) => {
		KlpTextRole.display: KlpTextStyleDefinition(
			fontSize: type.display,
			lineHeight: type.displayLeading,
			fontWeight: type.bold,
			letterSpacing: type.displayTracking,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.h1: KlpTextStyleDefinition(
			fontSize: type.h1,
			lineHeight: type.h1Leading,
			fontWeight: type.bold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.h2: KlpTextStyleDefinition(
			fontSize: type.h2,
			lineHeight: type.h2Leading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.h3: KlpTextStyleDefinition(
			fontSize: type.h3,
			lineHeight: type.h3Leading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.h4: KlpTextStyleDefinition(
			fontSize: type.h4,
			lineHeight: type.h4Leading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.lead: KlpTextStyleDefinition(
			fontSize: type.lead,
			lineHeight: type.leadLeading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.body: KlpTextStyleDefinition(
			fontSize: type.body,
			lineHeight: type.bodyLeading,
			fontWeight: type.regular,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.sub: KlpTextStyleDefinition(
			fontSize: type.sub,
			lineHeight: type.subLeading,
			fontWeight: type.regular,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.caption: KlpTextStyleDefinition(
			fontSize: type.caption,
			lineHeight: type.captionLeading,
			fontWeight: type.regular,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.captionStrong: KlpTextStyleDefinition(
			fontSize: type.caption,
			lineHeight: type.captionLeading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.monoCaptionStrong: KlpTextStyleDefinition(
			fontSize: type.caption,
			lineHeight: type.captionLeading,
			fontWeight: type.bold,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.micro: KlpTextStyleDefinition(
			fontSize: type.micro,
			lineHeight: type.microLeading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.title: KlpTextStyleDefinition(
			fontSize: type.title,
			lineHeight: type.h1Leading,
			fontWeight: type.bold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.section: KlpTextStyleDefinition(
			fontSize: type.section,
			lineHeight: type.h3Leading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.editor: KlpTextStyleDefinition(
			fontSize: type.body,
			lineHeight: type.bodyLeading,
			fontWeight: type.regular,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.body,
		),
		KlpTextRole.terminal: KlpTextStyleDefinition(
			fontSize: type.body,
			lineHeight: type.bodyLeading,
			fontWeight: type.regular,
			letterSpacing: type.labelTracking,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.bodyStrong: KlpTextStyleDefinition(
			fontSize: type.body,
			lineHeight: type.bodyLeading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
		),
		KlpTextRole.appTitle: KlpTextStyleDefinition(
			fontSize: type.sub,
			lineHeight: type.labelLeading,
			fontWeight: FontWeight.w500,
			letterSpacing: type.labelTracking,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.header: KlpTextStyleDefinition(
			fontSize: type.body,
			lineHeight: type.bodyLeading,
			fontWeight: type.semiBold,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.status: KlpTextStyleDefinition(
			fontSize: type.sub,
			lineHeight: type.codeLeading,
			fontWeight: FontWeight.w500,
			letterSpacing: type.labelTracking,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.label: KlpTextStyleDefinition(
			fontSize: type.sub,
			lineHeight: type.labelLeading,
			fontWeight: type.regular,
			letterSpacing: type.labelTracking,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
		KlpTextRole.code: KlpTextStyleDefinition(
			fontSize: type.sub,
			lineHeight: type.codeLeading,
			fontWeight: type.regular,
			letterSpacing: type.labelTracking,
			tier: KlpTextColorTier.prominent,
			family: KlpFontRole.mono,
		),
	};

	static KlpTextStyleDefinition definitionOf(
		KlpTextRole role,
		KlpTypographyTheme type,
	) {
		return definitionsFor(type)[role]!;
	}

	/// 角色對應的色階預設皆為 prominent（淺色最黑 ink900，深色最白 ink50）。
	/// 只有註解與說明 explicitly 傳入 tone 時才套用 muted / faint。
	static const Map<KlpTextRole, KlpTextColorTier> tiers = {
		KlpTextRole.display: KlpTextColorTier.prominent,
		KlpTextRole.h1: KlpTextColorTier.prominent,
		KlpTextRole.h2: KlpTextColorTier.prominent,
		KlpTextRole.h3: KlpTextColorTier.prominent,
		KlpTextRole.h4: KlpTextColorTier.prominent,
		KlpTextRole.lead: KlpTextColorTier.prominent,
		KlpTextRole.body: KlpTextColorTier.prominent,
		KlpTextRole.sub: KlpTextColorTier.prominent,
		KlpTextRole.caption: KlpTextColorTier.prominent,
		KlpTextRole.captionStrong: KlpTextColorTier.prominent,
		KlpTextRole.monoCaptionStrong: KlpTextColorTier.prominent,
		KlpTextRole.micro: KlpTextColorTier.prominent,
		KlpTextRole.title: KlpTextColorTier.prominent,
		KlpTextRole.section: KlpTextColorTier.prominent,
		KlpTextRole.editor: KlpTextColorTier.prominent,
		KlpTextRole.terminal: KlpTextColorTier.prominent,
		KlpTextRole.bodyStrong: KlpTextColorTier.prominent,
		KlpTextRole.appTitle: KlpTextColorTier.prominent,
		KlpTextRole.header: KlpTextColorTier.prominent,
		KlpTextRole.status: KlpTextColorTier.prominent,
		KlpTextRole.label: KlpTextColorTier.prominent,
		KlpTextRole.code: KlpTextColorTier.prominent,
	};

	static Color colorFor(
		KlpThemeData tokens, {
		required KlpTextRole role,
		KlpTextTone tone = KlpTextTone.automatic,
		Color? requestedColor,
	}) {
		if (requestedColor != null) {
			return requestedColor;
		}
		final tier = _tierForTone(role, tone);

		return switch (tier) {
			KlpTextColorTier.prominent => tokens.text,
			KlpTextColorTier.standard => tokens.textMuted,
			KlpTextColorTier.subdued => tokens.textFaint,
		};
	}

	static KlpTextColorTier _tierForTone(KlpTextRole role, KlpTextTone tone) {
		return switch (tone) {
			KlpTextTone.automatic => tiers[role] ?? KlpTextColorTier.prominent,
			KlpTextTone.primary || KlpTextTone.accent => KlpTextColorTier.prominent,
			KlpTextTone.faint => KlpTextColorTier.subdued,
			KlpTextTone.muted => KlpTextColorTier.standard,
			KlpTextTone.danger || KlpTextTone.success => KlpTextColorTier.prominent,
		};
	}
}
