import 'package:flutter/material.dart';

import '../tokens/klp_scale.dart';

/// Layer 2：間距與密度的 semantic token。
///
/// 這是換風格時差異最大的一組 token——高密度與寬鬆兩種取向用的是同一批元件。
/// 因此 padding **必須**由 theme 提供；元件內寫死 `EdgeInsets.all(12)` 會讓該元件在
/// 換風格時原地不動，是最典型的風格不對齊。
@immutable
class KlpSpacingTheme extends ThemeExtension<KlpSpacingTheme> {
  const KlpSpacingTheme({
    required this.hairline,
    required this.tight,
    required this.compact,
    required this.base,
    required this.comfortable,
    required this.loose,
    required this.section,
    required this.page,
    required this.controlPaddingX,
    required this.controlPaddingY,
    required this.containerPadding,
    required this.itemGap,
    required this.groupGap,
    required this.controlHeight,
    required this.controlHeightSmall,
    required this.controlHeightLarge,
    required this.iconSmall,
    required this.icon,
    required this.iconLarge,
    required this.chromeHeader,
    required this.chromeStatusBar,
    required this.chromeRail,
    required this.chromeTab,
    required this.iconButton,
  });

  // 通用階梯（角色化，不是尺寸化）
  final double hairline;
  final double tight;
  final double compact;
  final double base;
  final double comfortable;
  final double loose;
  final double section;
  final double page;

  // 直接可用的組合值——元件讀這些，不自己算
  final double controlPaddingX;
  final double controlPaddingY;
  final double containerPadding;
  final double itemGap;
  final double groupGap;

  // 密度：控制項高度是「緊湊 vs 寬鬆」最直接的體現
  final double controlHeight;
  final double controlHeightSmall;
  final double controlHeightLarge;

  /// 圖示尺寸屬於密度：高密度風格的圖示要能與收緊後的行高對齊。
  final double iconSmall;
  final double icon;
  final double iconLarge;

  /// App 外殼的高度。高密度風格的標題列與狀態列會矮一截——這是密度，不是版面常數。
  final double chromeHeader;
  final double chromeStatusBar;
  final double chromeRail;
  final double chromeTab;
  final double iconButton;

  EdgeInsets get controlInsets => EdgeInsets.symmetric(
    horizontal: controlPaddingX,
    vertical: controlPaddingY,
  );

  EdgeInsets get containerInsets => EdgeInsets.all(containerPadding);

  /// 現代風：呼吸感優先，控制項 32pt。
  static const KlpSpacingTheme comfortableDensity = KlpSpacingTheme(
    hairline: KlpScale.space50,
    tight: KlpScale.space100,
    compact: KlpScale.space200,
    base: KlpScale.space300,
    comfortable: KlpScale.space400,
    loose: KlpScale.space600,
    section: KlpScale.space800,
    page: KlpScale.space1000,
    controlPaddingX: KlpScale.space300,
    controlPaddingY: KlpScale.space200,
    containerPadding: KlpScale.space400,
    itemGap: KlpScale.space200,
    groupGap: KlpScale.space400,
    controlHeight: 32,
    controlHeightSmall: 26,
    controlHeightLarge: 40,
    iconSmall: 14,
    icon: 18,
    iconLarge: 22,
    chromeHeader: 60,
    chromeStatusBar: 30,
    chromeRail: 56,
    chromeTab: 32,
    iconButton: 30,
  );

  @override
  KlpSpacingTheme copyWith({
    double? hairline,
    double? tight,
    double? compact,
    double? base,
    double? comfortable,
    double? loose,
    double? section,
    double? page,
    double? controlPaddingX,
    double? controlPaddingY,
    double? containerPadding,
    double? itemGap,
    double? groupGap,
    double? controlHeight,
    double? controlHeightSmall,
    double? controlHeightLarge,
    double? iconSmall,
    double? icon,
    double? iconLarge,
    double? chromeHeader,
    double? chromeStatusBar,
    double? chromeRail,
    double? chromeTab,
    double? iconButton,
  }) {
    return KlpSpacingTheme(
      hairline: hairline ?? this.hairline,
      tight: tight ?? this.tight,
      compact: compact ?? this.compact,
      base: base ?? this.base,
      comfortable: comfortable ?? this.comfortable,
      loose: loose ?? this.loose,
      section: section ?? this.section,
      page: page ?? this.page,
      controlPaddingX: controlPaddingX ?? this.controlPaddingX,
      controlPaddingY: controlPaddingY ?? this.controlPaddingY,
      containerPadding: containerPadding ?? this.containerPadding,
      itemGap: itemGap ?? this.itemGap,
      groupGap: groupGap ?? this.groupGap,
      controlHeight: controlHeight ?? this.controlHeight,
      controlHeightSmall: controlHeightSmall ?? this.controlHeightSmall,
      controlHeightLarge: controlHeightLarge ?? this.controlHeightLarge,
      iconSmall: iconSmall ?? this.iconSmall,
      icon: icon ?? this.icon,
      iconLarge: iconLarge ?? this.iconLarge,
      chromeHeader: chromeHeader ?? this.chromeHeader,
      chromeStatusBar: chromeStatusBar ?? this.chromeStatusBar,
      chromeRail: chromeRail ?? this.chromeRail,
      chromeTab: chromeTab ?? this.chromeTab,
      iconButton: iconButton ?? this.iconButton,
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
  KlpSpacingTheme lerp(covariant KlpSpacingTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpSpacingTheme &&
          hairline == other.hairline &&
          tight == other.tight &&
          compact == other.compact &&
          base == other.base &&
          comfortable == other.comfortable &&
          loose == other.loose &&
          section == other.section &&
          page == other.page &&
          controlPaddingX == other.controlPaddingX &&
          controlPaddingY == other.controlPaddingY &&
          containerPadding == other.containerPadding &&
          itemGap == other.itemGap &&
          groupGap == other.groupGap &&
          controlHeight == other.controlHeight &&
          controlHeightSmall == other.controlHeightSmall &&
          controlHeightLarge == other.controlHeightLarge &&
          iconSmall == other.iconSmall &&
          icon == other.icon &&
          iconLarge == other.iconLarge &&
          chromeHeader == other.chromeHeader &&
          chromeStatusBar == other.chromeStatusBar &&
          chromeRail == other.chromeRail &&
          chromeTab == other.chromeTab &&
          iconButton == other.iconButton;

  @override
  int get hashCode => Object.hashAll([
    hairline,
    tight,
    compact,
    base,
    comfortable,
    loose,
    section,
    page,
    controlPaddingX,
    controlPaddingY,
    containerPadding,
    itemGap,
    groupGap,
    controlHeight,
    controlHeightSmall,
    controlHeightLarge,
    iconSmall,
    icon,
    iconLarge,
    chromeHeader,
    chromeStatusBar,
    chromeRail,
    chromeTab,
    iconButton,
  ]);
}
