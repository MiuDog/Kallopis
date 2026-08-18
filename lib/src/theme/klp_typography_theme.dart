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
    required this.caption,
    required this.body,
    required this.label,
    required this.section,
    required this.headingSmall,
    required this.heading,
    required this.title,
    required this.display,
    required this.bodyLeading,
    required this.headingLeading,
    required this.displayLeading,
    required this.codeLeading,
    required this.readingLeading,
    required this.captionLeading,
    required this.labelLeading,
    required this.labelTracking,
    required this.displayTracking,
    required this.regular,
    required this.medium,
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

  // 字級角色
  final double caption;
  final double body;
  final double label;
  final double section;
  final double headingSmall;
  final double heading;
  final double title;
  final double display;

  // 行高角色
  final double bodyLeading;
  final double headingLeading;
  final double displayLeading;
  final double codeLeading;
  final double readingLeading;

  /// caption 與 label 的行高刻意與內文不同：小字需要更緊的行距才不會顯得鬆散，
  /// 而 label 通常單行，行高只影響垂直置中。
  final double captionLeading;
  final double labelLeading;

  // 字距
  final double labelTracking;
  final double displayTracking;

  // 字重
  final FontWeight regular;
  final FontWeight medium;
  final FontWeight strong;

  static const String _sans = 'packages/kallopis/IBM Plex Sans TC';
  static const String _mono = 'packages/kallopis/IBM Plex Mono';

  /// 中文與缺字的接手順序。
  ///
  /// 隨套件打包的 IBM Plex 排在最前面，因為它保證每台機器都渲染成同一個樣子；
  /// 之後才輪到系統字體。清單同時涵蓋三個平台——Flutter 會依序找第一個有該字符的
  /// 字體，找不到的平台會直接跳過，因此不需要在程式裡分支判斷作業系統。
  ///
  /// Inter 排在中文字體之前：它只有拉丁字符，接不到的中文會繼續往下找。
  static const List<String> _fallback = [
    'Inter',
    // macOS / iOS
    'PingFang TC',
    // Windows
    'Microsoft JhengHei',
    // Android
    'Noto Sans CJK TC',
    'Noto Sans TC',
  ];

  /// 現代風：比例字體為主，等寬只用於程式碼與路徑。
  static const KlpTypographyTheme proportional = KlpTypographyTheme(
    sansFamily: _sans,
    sansFallback: _fallback,
    monoFamily: _mono,
    // 等寬沒有打包中文字重，中文字符一律交給系統的黑體接手。
    monoFallback: _fallback,
    uiFamily: _sans,
    bodyFamily: _sans,
    codeFamily: _mono,
    caption: KlpScale.font200,
    body: KlpScale.font300,
    label: KlpScale.font200,
    section: KlpScale.font400,
    headingSmall: KlpScale.font500,
    heading: KlpScale.font700,
    title: KlpScale.font900,
    display: KlpScale.font1100,
    bodyLeading: KlpScale.leading500,
    headingLeading: KlpScale.leading350,
    displayLeading: KlpScale.leading100,
    codeLeading: KlpScale.leading550,
    readingLeading: KlpScale.leading650,
    captionLeading: KlpScale.leading400,
    labelLeading: KlpScale.leading150,
    labelTracking: KlpScale.trackingWide,
    displayTracking: KlpScale.trackingTight,
    regular: KlpScale.weight400,
    medium: KlpScale.weight600,
    strong: KlpScale.weight700,
  );

  List<String> fallbackFor(String family) =>
      family == monoFamily ? monoFallback : sansFallback;

  @override
  KlpTypographyTheme copyWith({
    String? sansFamily,
    List<String>? sansFallback,
    String? monoFamily,
    List<String>? monoFallback,
    String? uiFamily,
    String? bodyFamily,
    String? codeFamily,
    double? caption,
    double? body,
    double? label,
    double? section,
    double? headingSmall,
    double? heading,
    double? title,
    double? display,
    double? bodyLeading,
    double? headingLeading,
    double? displayLeading,
    double? codeLeading,
    double? readingLeading,
    double? captionLeading,
    double? labelLeading,
    double? labelTracking,
    double? displayTracking,
    FontWeight? regular,
    FontWeight? medium,
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
      caption: caption ?? this.caption,
      body: body ?? this.body,
      label: label ?? this.label,
      section: section ?? this.section,
      headingSmall: headingSmall ?? this.headingSmall,
      heading: heading ?? this.heading,
      title: title ?? this.title,
      display: display ?? this.display,
      bodyLeading: bodyLeading ?? this.bodyLeading,
      headingLeading: headingLeading ?? this.headingLeading,
      displayLeading: displayLeading ?? this.displayLeading,
      codeLeading: codeLeading ?? this.codeLeading,
      readingLeading: readingLeading ?? this.readingLeading,
      captionLeading: captionLeading ?? this.captionLeading,
      labelLeading: labelLeading ?? this.labelLeading,
      labelTracking: labelTracking ?? this.labelTracking,
      displayTracking: displayTracking ?? this.displayTracking,
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      strong: strong ?? this.strong,
    );
  }

  /// **不做內插。**
  ///
  /// `MaterialApp` 在 theme 變更時會跑一段過場並沿路呼叫 `lerp`。各層若各自內插，
  /// 中途會出現「某幾層已經換了、某幾層還沒」的混合狀態——那正是切換深淺色時看起來
  /// 「有些元件沒有跟著變」的原因：它們不是沒變，是停在中間值上。
  ///
  /// 因此整個 token 疊層一律在中點原子性地翻轉，任何時刻都只會是完整的其中一套。
  @override
  KlpTypographyTheme lerp(covariant KlpTypographyTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpTypographyTheme &&
          uiFamily == other.uiFamily &&
          bodyFamily == other.bodyFamily &&
          codeFamily == other.codeFamily &&
          body == other.body &&
          heading == other.heading &&
          bodyLeading == other.bodyLeading &&
          labelTracking == other.labelTracking &&
          regular == other.regular;

  @override
  int get hashCode => Object.hash(
    uiFamily,
    bodyFamily,
    codeFamily,
    body,
    heading,
    bodyLeading,
    labelTracking,
    regular,
  );
}
