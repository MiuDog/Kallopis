import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// Layer 2：字體的 semantic token。
///
/// 字體家族本身是 theme 的一部分——有些風格全域使用等寬字，有些只在程式碼與路徑使用。
/// 元件讀 `body`／`label`／`code` 這些**角色**，不指定家族，因此換 theme 時字體會整體
/// 跟著換，不會只換一半。
@immutable
class KlpTypographyTheme extends ThemeExtension<KlpTypographyTheme> {
  const KlpTypographyTheme({
    required this.sansFamily,
    required this.sansFallback,
    required this.monoFamily,
    required this.monoFallback,
    required this.uiFamily,
    required this.bodyFamily,
    required this.codeFamily,
    this.micro = KlpScale.font100,
    required this.caption,
    this.sub = KlpScale.font300,
    required this.body,
    this.lead = KlpScale.font500,
    this.h4 = KlpScale.font600,
    this.h3 = KlpScale.font700,
    this.h2 = KlpScale.font800,
    this.h1 = KlpScale.font900,
    required this.label,
    required this.section,
    required this.headingSmall,
    required this.heading,
    required this.title,
    required this.display,
    this.microLeading = KlpScale.leading120,
    required this.captionLeading,
    this.subLeading = KlpScale.leading142,
    required this.bodyLeading,
    this.leadLeading = KlpScale.leading155,
    this.h4Leading = KlpScale.leading127,
    this.h3Leading = KlpScale.leading128,
    this.h2Leading = KlpScale.leading122,
    this.h1Leading = KlpScale.leading116,
    required this.headingLeading,
    required this.displayLeading,
    required this.codeLeading,
    required this.readingLeading,
    required this.labelLeading,
    required this.labelTracking,
    required this.displayTracking,
    required this.regular,
    required this.medium,
    this.semiBold = KlpScale.weight600,
    this.bold = KlpScale.weight700,
    this.extraBold = KlpScale.weight800,
    required this.strong,
  });

  // 家族。隨套件散佈的字型家族名必須帶 `packages/kallopis/` 前綴，少了不會編譯失敗，
  // 只會靜默 fallback 到系統字型。
  final String sansFamily;
  final List<String> sansFallback;
  final String monoFamily;
  final List<String> monoFallback;

  // 角色 → 家族的對應。這一層讓「全域等寬」成為換 theme 就能達成的事。
  final String uiFamily;
  final String bodyFamily;
  final String codeFamily;

  // 十階字級
  final double micro; // 10px (font-micro)
  final double caption; // 12px (font-caption)
  final double sub; // 14px (font-sub)
  final double body; // 16px (font-body 基準)
  final double lead; // 18px (font-lead)
  final double h4; // 22px (font-h4)
  final double h3; // 28px (font-h3)
  final double h2; // 36px (font-h2)
  final double h1; // 48px (font-h1)
  final double display; // 64px (font-display)

  // 舊有別名支援
  final double label;
  final double section;
  final double headingSmall;
  final double heading;
  final double title;

  // 行高角色（比例）
  final double microLeading; // 1.200 (12px / 10px)
  final double captionLeading; // 1.333 (16px / 12px)
  final double subLeading; // 1.428 (20px / 14px)
  final double bodyLeading; // 1.500 (24px / 16px)
  final double leadLeading; // 1.555 (28px / 18px)
  final double h4Leading; // 1.272 (28px / 22px)
  final double h3Leading; // 1.285 (36px / 28px)
  final double h2Leading; // 1.222 (44px / 36px)
  final double h1Leading; // 1.166 (56px / 48px)
  final double displayLeading; // 1.125 (72px / 64px)

  final double headingLeading;
  final double codeLeading;
  final double readingLeading;
  final double labelLeading;

  // 字距
  final double labelTracking;
  final double displayTracking;

  // 字重
  final FontWeight regular; // w400
  final FontWeight medium; // w500
  final FontWeight semiBold; // w600
  final FontWeight bold; // w700
  final FontWeight extraBold; // w800
  final FontWeight strong; // 預設強調字重

  static const String _sans = 'sans-serif';
  static const String _mono = 'packages/kallopis/IBM Plex Mono';

  /// 系統預設字體與接手順序。
  static const List<String> _fallback = [
    'Microsoft JhengHei UI',
    'Microsoft JhengHei',
    'PingFang TC',
    'Noto Sans TC',
    'sans-serif',
  ];

  static const List<String> _monoFallback = [
    'IBM Plex Mono',
    'Consolas',
    'Courier New',
    'monospace',
  ];

  /// 現代風：完整 10 階字級排版系統。
  static const KlpTypographyTheme proportional = KlpTypographyTheme(
    sansFamily: _sans,
    sansFallback: _fallback,
    monoFamily: _mono,
    monoFallback: _monoFallback,
    uiFamily: _sans,
    bodyFamily: _sans,
    codeFamily: _mono,
    micro: KlpScale.font100, // 10px
    caption: KlpScale.font200, // 12px
    sub: KlpScale.font300, // 14px
    body: KlpScale.font400, // 16px
    lead: KlpScale.font500, // 18px
    h4: KlpScale.font600, // 22px
    h3: KlpScale.font700, // 28px
    h2: KlpScale.font800, // 36px
    h1: KlpScale.font900, // 48px
    display: KlpScale.font1000, // 64px
    label: KlpScale.font300, // 14px
    section: KlpScale.font700,
    headingSmall: KlpScale.font600,
    heading: KlpScale.font800,
    title: KlpScale.font900,
    microLeading: KlpScale.leading120, // 1.200 (12/10)
    captionLeading: KlpScale.leading133, // 1.333 (16/12)
    subLeading: KlpScale.leading142, // 1.428 (20/14)
    bodyLeading: KlpScale.leading150, // 1.500 (24/16)
    leadLeading: KlpScale.leading155, // 1.555 (28/18)
    h4Leading: KlpScale.leading127, // 1.272 (28/22)
    h3Leading: KlpScale.leading128, // 1.285 (36/28)
    h2Leading: KlpScale.leading122, // 1.222 (44/36)
    h1Leading: KlpScale.leading116, // 1.166 (56/48)
    displayLeading: KlpScale.leading100, // 1.125 (72/64)
    headingLeading: KlpScale.leading122,
    codeLeading: KlpScale.leading142,
    readingLeading: KlpScale.leading155,
    labelLeading: KlpScale.leading133,
    labelTracking: KlpScale.tracking0,
    displayTracking: KlpScale.trackingTight,
    regular: KlpScale.weight400,
    medium: KlpScale.weight400,
    semiBold: KlpScale.weight600,
    bold: KlpScale.weight700,
    extraBold: KlpScale.weight700,
    strong: KlpScale.weight600,
  );

  List<String> fallbackFor(String family) =>
      family == monoFamily || family == codeFamily
      ? monoFallback
      : sansFallback;

  @override
  KlpTypographyTheme copyWith({
    String? sansFamily,
    List<String>? sansFallback,
    String? monoFamily,
    List<String>? monoFallback,
    String? uiFamily,
    String? bodyFamily,
    String? codeFamily,
    double? micro,
    double? caption,
    double? sub,
    double? body,
    double? lead,
    double? h4,
    double? h3,
    double? h2,
    double? h1,
    double? display,
    double? label,
    double? section,
    double? headingSmall,
    double? heading,
    double? title,
    double? microLeading,
    double? captionLeading,
    double? subLeading,
    double? bodyLeading,
    double? leadLeading,
    double? h4Leading,
    double? h3Leading,
    double? h2Leading,
    double? h1Leading,
    double? displayLeading,
    double? headingLeading,
    double? codeLeading,
    double? readingLeading,
    double? labelLeading,
    double? labelTracking,
    double? displayTracking,
    FontWeight? regular,
    FontWeight? medium,
    FontWeight? semiBold,
    FontWeight? bold,
    FontWeight? extraBold,
    FontWeight? strong,
  }) {
    return KlpTypographyTheme(
      sansFamily: sansFamily ?? this.sansFamily,
      sansFallback: sansFallback ?? this.sansFallback,
      monoFamily: monoFamily ?? this.monoFamily,
      monoFallback: monoFallback ?? this.monoFallback,
      uiFamily: uiFamily ?? this.uiFamily,
      bodyFamily: bodyFamily ?? this.bodyFamily,
      codeFamily: codeFamily ?? this.codeFamily,
      micro: micro ?? this.micro,
      caption: caption ?? this.caption,
      sub: sub ?? this.sub,
      body: body ?? this.body,
      lead: lead ?? this.lead,
      h4: h4 ?? this.h4,
      h3: h3 ?? this.h3,
      h2: h2 ?? this.h2,
      h1: h1 ?? this.h1,
      display: display ?? this.display,
      label: label ?? this.label,
      section: section ?? this.section,
      headingSmall: headingSmall ?? this.headingSmall,
      heading: heading ?? this.heading,
      title: title ?? this.title,
      microLeading: microLeading ?? this.microLeading,
      captionLeading: captionLeading ?? this.captionLeading,
      subLeading: subLeading ?? this.subLeading,
      bodyLeading: bodyLeading ?? this.bodyLeading,
      leadLeading: leadLeading ?? this.leadLeading,
      h4Leading: h4Leading ?? this.h4Leading,
      h3Leading: h3Leading ?? this.h3Leading,
      h2Leading: h2Leading ?? this.h2Leading,
      h1Leading: h1Leading ?? this.h1Leading,
      displayLeading: displayLeading ?? this.displayLeading,
      headingLeading: headingLeading ?? this.headingLeading,
      codeLeading: codeLeading ?? this.codeLeading,
      readingLeading: readingLeading ?? this.readingLeading,
      labelLeading: labelLeading ?? this.labelLeading,
      labelTracking: labelTracking ?? this.labelTracking,
      displayTracking: displayTracking ?? this.displayTracking,
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      semiBold: semiBold ?? this.semiBold,
      bold: bold ?? this.bold,
      extraBold: extraBold ?? this.extraBold,
      strong: strong ?? this.strong,
    );
  }

  @override
  KlpTypographyTheme lerp(covariant KlpTypographyTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpTypographyTheme &&
          sansFamily == other.sansFamily &&
          sansFallback == other.sansFallback &&
          monoFamily == other.monoFamily &&
          monoFallback == other.monoFallback &&
          uiFamily == other.uiFamily &&
          bodyFamily == other.bodyFamily &&
          codeFamily == other.codeFamily &&
          micro == other.micro &&
          caption == other.caption &&
          sub == other.sub &&
          body == other.body &&
          lead == other.lead &&
          h4 == other.h4 &&
          h3 == other.h3 &&
          h2 == other.h2 &&
          h1 == other.h1 &&
          display == other.display &&
          label == other.label &&
          section == other.section &&
          headingSmall == other.headingSmall &&
          heading == other.heading &&
          title == other.title &&
          microLeading == other.microLeading &&
          captionLeading == other.captionLeading &&
          subLeading == other.subLeading &&
          bodyLeading == other.bodyLeading &&
          leadLeading == other.leadLeading &&
          h4Leading == other.h4Leading &&
          h3Leading == other.h3Leading &&
          h2Leading == other.h2Leading &&
          h1Leading == other.h1Leading &&
          displayLeading == other.displayLeading &&
          headingLeading == other.headingLeading &&
          codeLeading == other.codeLeading &&
          readingLeading == other.readingLeading &&
          labelLeading == other.labelLeading &&
          labelTracking == other.labelTracking &&
          displayTracking == other.displayTracking &&
          regular == other.regular &&
          medium == other.medium &&
          semiBold == other.semiBold &&
          bold == other.bold &&
          extraBold == other.extraBold &&
          strong == other.strong;

  @override
  int get hashCode => Object.hashAll([
    sansFamily,
    sansFallback,
    monoFamily,
    monoFallback,
    uiFamily,
    bodyFamily,
    codeFamily,
    micro,
    caption,
    sub,
    body,
    lead,
    h4,
    h3,
    h2,
    h1,
    display,
    label,
    section,
    headingSmall,
    heading,
    title,
    microLeading,
    captionLeading,
    subLeading,
    bodyLeading,
    leadLeading,
    h4Leading,
    h3Leading,
    h2Leading,
    h1Leading,
    displayLeading,
    headingLeading,
    codeLeading,
    readingLeading,
    labelLeading,
    labelTracking,
    displayTracking,
    regular,
    medium,
    semiBold,
    bold,
    extraBold,
    strong,
  ]);
}
