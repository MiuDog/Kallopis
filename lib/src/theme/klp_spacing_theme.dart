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
    this.space0_5 = KlpScale.space50,
    this.space1 = KlpScale.space100,
    this.space2 = KlpScale.space200,
    this.space3 = KlpScale.space300,
    this.space4 = KlpScale.space400,
    this.space6 = KlpScale.space600,
    this.space8 = KlpScale.space800,
    this.space12 = KlpScale.space1200,
    this.space16 = KlpScale.space1600,
    this.space24 = KlpScale.space2400,
    required this.hairline,
    required this.tight,
    required this.compact,
    required this.base,
    required this.comfortable,
    required this.loose,
    required this.section,
    this.sectionLarge = KlpScale.space1200,
    required this.page,
    this.pageLarge = KlpScale.space2400,
    this.controlPaddingXSmall = KlpScale.space300,
    required this.controlPaddingX,
    this.controlPaddingXLarge = KlpScale.space600,
    this.controlPaddingXXLarge = KlpScale.space800,
    required this.controlPaddingY,
    required this.containerPadding,
    required this.itemGap,
    required this.groupGap,
    required this.controlHeight,
    required this.controlHeightSmall,
    required this.controlHeightLarge,
    this.controlHeightXLarge = 56,
    required this.iconSmall,
    this.iconBase = 16,
    this.iconGlyph = 18,
    required this.icon,
    this.iconMedium = 24,
    required this.iconLarge,
    required this.chromeHeader,
    required this.chromeStatusBar,
    required this.chromeRail,
    required this.chromeTab,
    required this.iconButton,
    required this.iconTiny,
    required this.indicatorDot,
    required this.indicatorDotLarge,
    required this.switchTrackWidth,
    required this.switchTrackHeight,
    required this.switchThumb,
    required this.noticeIconSlot,
    required this.toastIconSlot,
    required this.gutterNumber,
    required this.gutterMarker,
    required this.micro,
    required this.calendarContentCell,
    required this.gridTileWidth,
    required this.documentHandleGutter,
    required this.documentTrailingSpace,
    required this.iconMicro,
    required this.avatarSmall,
    required this.progressTrack,
    required this.skeletonLine,
    required this.railItem,
    required this.drawerWidth,
    required this.drawerHeight,
  });

  // 10 段精確間距階梯 (px)
  final double space0_5; // 2px (0.125rem)
  final double space1; // 4px (0.25rem)
  final double space2; // 8px (0.5rem)
  final double space3; // 12px (0.75rem)
  final double space4; // 16px (1.0rem)
  final double space6; // 24px (1.5rem)
  final double space8; // 32px (2.0rem)
  final double space12; // 48px (3.0rem)
  final double space16; // 64px (4.0rem)
  final double space24; // 96px (6.0rem)

  // 通用角色階梯
  final double hairline;
  final double tight;
  final double compact;
  final double base;
  final double comfortable;
  final double loose;
  final double section;
  final double sectionLarge;
  final double page;
  final double pageLarge;

  // 直接可用的組合值與內距
  final double controlPaddingXSmall; // 12px (SM)
  final double controlPaddingX; // 16px (MD)
  final double controlPaddingXLarge; // 24px (LG)
  final double controlPaddingXXLarge; // 32px (XL)
  final double controlPaddingY;
  final double containerPadding;
  final double itemGap;
  final double groupGap;

  // 四段控制項高度（SM: 32, MD: 40, LG: 48, XL: 56）
  final double controlHeightSmall; // 36px (SM)
  final double controlHeight; // 40px (MD 預設)
  final double controlHeightLarge; // 48px (LG)
  final double controlHeightXLarge; // 56px (XL)

  // 四段圖示尺寸 (14, 16, 20/24, 32)
  final double iconSmall; // 14px (icon-sm)
  final double iconBase; // 16px (icon-base)

  // 畫在 [icon] 尺寸格子裡的字形大小（18px 字形／20px 格）。
  //
  // 導覽列與工具列的圖示佔一個 [icon] 見方的格子，但**字形本身略小**，
  // 讓圖示在格線中留呼吸空間。字形與格子同大時，圖示會頂滿格線、
  // 在一排文字旁顯得過重。
  final double iconGlyph;
  final double icon; // 20px (icon-md 標準)
  final double iconMedium; // 24px (icon-md 導覽)
  final double iconLarge; // 32px (icon-lg 特色卡)

  // 外殼高度
  final double chromeHeader;
  final double chromeStatusBar;
  final double chromeRail;
  final double chromeTab;
  final double iconButton;

  // 元件尺寸。這些值原本散在元件裡，數值本身就是風格宣稱——留在元件裡等於
  // 換風格時換不掉。
  /// 10px。狀態圓點形式的圖示
  final double iconTiny;

  /// 6px。狀態圓點（badge、狀態列）
  final double indicatorDot;

  /// 8px。導覽軌上的未讀圓點
  final double indicatorDotLarge;

  /// 36px。開關軌道寬
  final double switchTrackWidth;

  /// 20px。開關軌道高
  final double switchTrackHeight;

  /// 16px。開關滑塊
  final double switchThumb;

  /// 28px。行內提示的圖示格
  final double noticeIconSlot;

  /// 22px。浮動提示的圖示格
  final double toastIconSlot;

  /// 24px。程式碼行號欄寬
  final double gutterNumber;

  /// 14px。差異標記欄寬
  final double gutterMarker;

  /// 1px。視覺上僅作分隔用的最小間隙
  final double micro;

  /// 帶內容的月曆日期格最小高度。
  ///
  /// 只在 [KlpCalendar] 給了 `dayContentBuilder` 時生效——純日期選擇的格子用
  /// [controlHeightSmall]，塞進內容後那個高度會擠成一團。
  final double calendarContentCell;

  /// 卡片式網格的單欄寬度。
  ///
  /// 給瀑布流或磚牆排版用：由單欄寬度決定節奏，而不是每個項目各給一個尺寸——
  /// 後者會讓版面失去規律，也讓尺寸變成散在資料裡的風格值。
  final double gridTileWidth;

  /// 區塊編輯器在正文左側預留給拖曳握把的寬度。
  ///
  /// 呈現層需要知道這個值才能把正文的左邊界拉回與標題對齊——否則正文會比標題
  /// 縮進一整個握把的寬度。
  final double documentHandleGutter;

  /// 正文結尾之後保留的捲動空間。
  ///
  /// 讓最後一段不會緊貼視窗底緣。
  final double documentTrailingSpace;

  /// 11px。狀態字形用的最小圖示
  final double iconMicro;

  /// 28px。頭像堆疊中的小頭像
  final double avatarSmall;

  /// 3px。進度條軌道厚度
  final double progressTrack;

  /// 10px。骨架屏的單行高
  final double skeletonLine;

  /// 42px。導覽軌上的可點區塊
  final double railItem;

  /// 320px。`KlpDrawer` 在 `left`／`right` 方向的預設寬度。
  final double drawerWidth;

  /// 320px。`KlpDrawer` 在 `top`／`bottom` 方向的預設高度。
  final double drawerHeight;

  double get xxs => space0_5;

  EdgeInsets get controlInsets => EdgeInsets.symmetric(
    horizontal: controlPaddingX,
    vertical: controlPaddingY,
  );

  EdgeInsets get containerInsets => EdgeInsets.all(containerPadding);

  /// 現代風：呼吸感優先，控制項預設 40px。
  static const KlpSpacingTheme comfortableDensity = KlpSpacingTheme(
    space0_5: KlpScale.space50, // 2px
    space1: KlpScale.space100, // 4px
    space2: KlpScale.space200, // 8px
    space3: KlpScale.space300, // 12px
    space4: KlpScale.space400, // 16px
    space6: KlpScale.space600, // 24px
    space8: KlpScale.space800, // 32px
    space12: KlpScale.space1200, // 48px
    space16: KlpScale.space1600, // 64px
    space24: KlpScale.space2400, // 96px
    hairline: KlpScale.space50, // 2px
    tight: KlpScale.space100, // 4px
    compact: KlpScale.space250, // 10px
    base: KlpScale.space400, // 16px (基準)
    comfortable: KlpScale.space600, // 24px
    loose: KlpScale.space800, // 32px
    section: KlpScale.space800, // 32px
    sectionLarge: KlpScale.space1200, // 48px
    page: KlpScale.space1600, // 64px
    pageLarge: KlpScale.space2400, // 96px
    controlPaddingXSmall: KlpScale.space300, // 12px (SM)
    controlPaddingX: KlpScale.space400, // 16px (MD)
    controlPaddingXLarge: KlpScale.space600, // 24px (LG)
    controlPaddingXXLarge: KlpScale.space800, // 32px (XL)
    controlPaddingY: KlpScale.space200, // 8px
    containerPadding: KlpScale.space400, // 16px
    itemGap: KlpScale.space300, // 12px
    groupGap: KlpScale.space400, // 16px
    controlHeightSmall: 36, // 36px (SM)
    controlHeight: 40, // 40px (MD 預設)
    controlHeightLarge: 48, // 48px (LG)
    controlHeightXLarge: 56, // 56px (XL)
    iconSmall: 14, // 14px (icon-sm)
    iconBase: 16, // 16px (icon-base)
    iconGlyph: 18, // 18px 字形，配 20px 格
    icon: 20, // 20px (icon-md)
    iconMedium: 24, // 24px (icon-md)
    iconLarge: 32, // 32px (icon-lg)
    chromeHeader: 60,
    chromeStatusBar: 30,
    chromeRail: 56,
    chromeTab: 32,
    iconButton: 32,
    iconTiny: 10,
    indicatorDot: 6,
    indicatorDotLarge: 8,
    switchTrackWidth: 36,
    switchTrackHeight: 20,
    switchThumb: 16,
    noticeIconSlot: 28,
    toastIconSlot: 22,
    gutterNumber: 24,
    gutterMarker: 14,
    micro: 1,
    calendarContentCell: 74,
    gridTileWidth: 170,
    documentHandleGutter: 60,
    documentTrailingSpace: 40,
    iconMicro: 11,
    avatarSmall: 24,
    progressTrack: 3,
    skeletonLine: 10,
    railItem: 42,
    drawerWidth: 320,
    drawerHeight: 320,
  );

  @override
  KlpSpacingTheme copyWith({
    double? iconTiny,
    double? indicatorDot,
    double? indicatorDotLarge,
    double? switchTrackWidth,
    double? switchTrackHeight,
    double? switchThumb,
    double? noticeIconSlot,
    double? toastIconSlot,
    double? gutterNumber,
    double? gutterMarker,
    double? micro,
    double? calendarContentCell,
    double? gridTileWidth,
    double? documentHandleGutter,
    double? documentTrailingSpace,
    double? iconMicro,
    double? avatarSmall,
    double? progressTrack,
    double? skeletonLine,
    double? railItem,
    double? drawerWidth,
    double? drawerHeight,
    double? space0_5,
    double? space1,
    double? space2,
    double? space3,
    double? space4,
    double? space6,
    double? space8,
    double? space12,
    double? space16,
    double? space24,
    double? hairline,
    double? tight,
    double? compact,
    double? base,
    double? comfortable,
    double? loose,
    double? section,
    double? sectionLarge,
    double? page,
    double? pageLarge,
    double? controlPaddingXSmall,
    double? controlPaddingX,
    double? controlPaddingXLarge,
    double? controlPaddingXXLarge,
    double? controlPaddingY,
    double? containerPadding,
    double? itemGap,
    double? groupGap,
    double? controlHeight,
    double? controlHeightSmall,
    double? controlHeightLarge,
    double? controlHeightXLarge,
    double? iconSmall,
    double? iconBase,
    double? iconGlyph,
    double? icon,
    double? iconMedium,
    double? iconLarge,
    double? chromeHeader,
    double? chromeStatusBar,
    double? chromeRail,
    double? chromeTab,
    double? iconButton,
  }) {
    return KlpSpacingTheme(
      space0_5: space0_5 ?? this.space0_5,
      space1: space1 ?? this.space1,
      space2: space2 ?? this.space2,
      space3: space3 ?? this.space3,
      space4: space4 ?? this.space4,
      space6: space6 ?? this.space6,
      space8: space8 ?? this.space8,
      space12: space12 ?? this.space12,
      space16: space16 ?? this.space16,
      space24: space24 ?? this.space24,
      hairline: hairline ?? this.hairline,
      tight: tight ?? this.tight,
      compact: compact ?? this.compact,
      base: base ?? this.base,
      comfortable: comfortable ?? this.comfortable,
      loose: loose ?? this.loose,
      section: section ?? this.section,
      sectionLarge: sectionLarge ?? this.sectionLarge,
      page: page ?? this.page,
      pageLarge: pageLarge ?? this.pageLarge,
      controlPaddingXSmall: controlPaddingXSmall ?? this.controlPaddingXSmall,
      controlPaddingX: controlPaddingX ?? this.controlPaddingX,
      controlPaddingXLarge: controlPaddingXLarge ?? this.controlPaddingXLarge,
      controlPaddingXXLarge:
          controlPaddingXXLarge ?? this.controlPaddingXXLarge,
      controlPaddingY: controlPaddingY ?? this.controlPaddingY,
      containerPadding: containerPadding ?? this.containerPadding,
      itemGap: itemGap ?? this.itemGap,
      groupGap: groupGap ?? this.groupGap,
      controlHeight: controlHeight ?? this.controlHeight,
      controlHeightSmall: controlHeightSmall ?? this.controlHeightSmall,
      controlHeightLarge: controlHeightLarge ?? this.controlHeightLarge,
      controlHeightXLarge: controlHeightXLarge ?? this.controlHeightXLarge,
      iconSmall: iconSmall ?? this.iconSmall,
      iconBase: iconBase ?? this.iconBase,
      iconGlyph: iconGlyph ?? this.iconGlyph,
      icon: icon ?? this.icon,
      iconMedium: iconMedium ?? this.iconMedium,
      iconLarge: iconLarge ?? this.iconLarge,
      chromeHeader: chromeHeader ?? this.chromeHeader,
      chromeStatusBar: chromeStatusBar ?? this.chromeStatusBar,
      chromeRail: chromeRail ?? this.chromeRail,
      chromeTab: chromeTab ?? this.chromeTab,
      iconButton: iconButton ?? this.iconButton,
      iconTiny: iconTiny ?? this.iconTiny,
      indicatorDot: indicatorDot ?? this.indicatorDot,
      indicatorDotLarge: indicatorDotLarge ?? this.indicatorDotLarge,
      switchTrackWidth: switchTrackWidth ?? this.switchTrackWidth,
      switchTrackHeight: switchTrackHeight ?? this.switchTrackHeight,
      switchThumb: switchThumb ?? this.switchThumb,
      noticeIconSlot: noticeIconSlot ?? this.noticeIconSlot,
      toastIconSlot: toastIconSlot ?? this.toastIconSlot,
      gutterNumber: gutterNumber ?? this.gutterNumber,
      gutterMarker: gutterMarker ?? this.gutterMarker,
      micro: micro ?? this.micro,
      calendarContentCell: calendarContentCell ?? this.calendarContentCell,
      gridTileWidth: gridTileWidth ?? this.gridTileWidth,
      documentHandleGutter: documentHandleGutter ?? this.documentHandleGutter,
      documentTrailingSpace:
          documentTrailingSpace ?? this.documentTrailingSpace,
      iconMicro: iconMicro ?? this.iconMicro,
      avatarSmall: avatarSmall ?? this.avatarSmall,
      progressTrack: progressTrack ?? this.progressTrack,
      skeletonLine: skeletonLine ?? this.skeletonLine,
      railItem: railItem ?? this.railItem,
      drawerWidth: drawerWidth ?? this.drawerWidth,
      drawerHeight: drawerHeight ?? this.drawerHeight,
    );
  }

  @override
  KlpSpacingTheme lerp(covariant KlpSpacingTheme? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KlpSpacingTheme &&
          space0_5 == other.space0_5 &&
          space1 == other.space1 &&
          space2 == other.space2 &&
          space3 == other.space3 &&
          space4 == other.space4 &&
          space6 == other.space6 &&
          space8 == other.space8 &&
          space12 == other.space12 &&
          space16 == other.space16 &&
          space24 == other.space24 &&
          hairline == other.hairline &&
          tight == other.tight &&
          compact == other.compact &&
          base == other.base &&
          comfortable == other.comfortable &&
          loose == other.loose &&
          section == other.section &&
          sectionLarge == other.sectionLarge &&
          page == other.page &&
          pageLarge == other.pageLarge &&
          controlPaddingXSmall == other.controlPaddingXSmall &&
          controlPaddingX == other.controlPaddingX &&
          controlPaddingXLarge == other.controlPaddingXLarge &&
          controlPaddingXXLarge == other.controlPaddingXXLarge &&
          controlPaddingY == other.controlPaddingY &&
          containerPadding == other.containerPadding &&
          itemGap == other.itemGap &&
          groupGap == other.groupGap &&
          controlHeightSmall == other.controlHeightSmall &&
          controlHeight == other.controlHeight &&
          controlHeightLarge == other.controlHeightLarge &&
          controlHeightXLarge == other.controlHeightXLarge &&
          iconSmall == other.iconSmall &&
          iconBase == other.iconBase &&
          iconGlyph == other.iconGlyph &&
          icon == other.icon &&
          iconMedium == other.iconMedium &&
          iconLarge == other.iconLarge &&
          chromeHeader == other.chromeHeader &&
          chromeStatusBar == other.chromeStatusBar &&
          chromeRail == other.chromeRail &&
          chromeTab == other.chromeTab &&
          iconButton == other.iconButton &&
          iconTiny == other.iconTiny &&
          indicatorDot == other.indicatorDot &&
          indicatorDotLarge == other.indicatorDotLarge &&
          switchTrackWidth == other.switchTrackWidth &&
          switchTrackHeight == other.switchTrackHeight &&
          switchThumb == other.switchThumb &&
          noticeIconSlot == other.noticeIconSlot &&
          toastIconSlot == other.toastIconSlot &&
          gutterNumber == other.gutterNumber &&
          gutterMarker == other.gutterMarker &&
          micro == other.micro &&
          calendarContentCell == other.calendarContentCell &&
          gridTileWidth == other.gridTileWidth &&
          documentHandleGutter == other.documentHandleGutter &&
          documentTrailingSpace == other.documentTrailingSpace &&
          iconMicro == other.iconMicro &&
          avatarSmall == other.avatarSmall &&
          progressTrack == other.progressTrack &&
          skeletonLine == other.skeletonLine &&
          railItem == other.railItem &&
          drawerWidth == other.drawerWidth &&
          drawerHeight == other.drawerHeight;

  @override
  int get hashCode => Object.hashAll([
    space0_5,
    space1,
    space2,
    space3,
    space4,
    space6,
    space8,
    space12,
    space16,
    space24,
    hairline,
    tight,
    compact,
    base,
    comfortable,
    loose,
    section,
    sectionLarge,
    page,
    pageLarge,
    controlPaddingXSmall,
    controlPaddingX,
    controlPaddingXLarge,
    controlPaddingXXLarge,
    controlPaddingY,
    containerPadding,
    itemGap,
    groupGap,
    controlHeightSmall,
    controlHeight,
    controlHeightLarge,
    controlHeightXLarge,
    iconSmall,
    iconBase,
    iconGlyph,
    icon,
    iconMedium,
    iconLarge,
    chromeHeader,
    chromeStatusBar,
    chromeRail,
    chromeTab,
    iconButton,
    iconTiny,
    indicatorDot,
    indicatorDotLarge,
    switchTrackWidth,
    switchTrackHeight,
    switchThumb,
    noticeIconSlot,
    toastIconSlot,
    gutterNumber,
    gutterMarker,
    micro,
    calendarContentCell,
    gridTileWidth,
    documentHandleGutter,
    documentTrailingSpace,
    iconMicro,
    avatarSmall,
    progressTrack,
    skeletonLine,
    railItem,
    drawerWidth,
    drawerHeight,
  ]);
}
