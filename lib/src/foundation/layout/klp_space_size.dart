/// Kallopis 專案模組。
library;

/// 間距風格的枚舉型態。
enum KlpSpaceSize {
  /// 最小固定間距
  xxs,

  /// 微細間距
  hairline,

  /// 緊密間距
  tight,

  /// 標準基礎間距
  base,

  /// 同一組合內相鄰項目的間距
  item,

  /// 舒適間距
  comfortable,

  /// 鬆散間距
  loose,

  /// 區塊間距
  section,

  /// 大區塊間距
  sectionLarge,

  /// 頁面級間距
  page,

  /// 內容內縮間距
  contentInset,

  /// 內容行內間距
  contentInline,

  /// 內容堆疊間距
  contentStack,

  /// 動作元件間距
  action,

  /// 控制項內圖示與文字之間的間距
  controlContent,

  /// Overlay 標題與內容間距
  overlayHeading,

  /// Chrome 標題與工具列之間的間距
  chromeToolbar,

  /// Navigation Rail 項目之間的間距
  navigationRailItem,

  /// Navigation Rail 單一操作項目的方形尺寸
  navigationRailControl,

  /// Command Menu 的標準寬度
  commandMenuWidth,

  /// Toast 圖示占位尺寸
  toastIconSlot,

  /// 骨架屏單行高度
  skeletonLine,

  /// Placeholder 動作與內容之間的間距
  placeholderAction,
}
