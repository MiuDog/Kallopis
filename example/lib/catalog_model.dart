import 'package:flutter/widgets.dart';

/// 一個元件的展示。
///
/// [name] 必須與公開型別名完全一致——`catalog_coverage_test` 用它比對「庫匯出的每個
/// widget 都出現在目錄裡」。名字打錯會讓覆蓋檢查誤判為缺漏。
@immutable
class Specimen {
  const Specimen({required this.name, this.note, this.build});

  /// 公開型別名，例如 `KlpButton`。
  final String name;

  /// 一句話說明它負責什麼、以及哪些決定不歸它管。
  final String? note;

  /// 實際的展示。`null` 表示尚未寫示範——目錄仍會列出它，並標記為未展示，
  /// 因為**列不出來的元件等於不存在**，藏起來只會讓缺口消失在視線外。
  final WidgetBuilder? build;

  bool get hasDemo => build != null;
}

/// 目錄的一頁。
@immutable
class CatalogPageData {
  const CatalogPageData({
    required this.label,
    required this.title,
    required this.description,
    required this.icon,
    required this.specimens,
    this.tokenView,
  });

  final String label;
  final String title;
  final String description;
  final String icon;

  /// 這一頁負責展示的元件。
  final List<Specimen> specimens;

  /// token 頁（顏色、間距、圓角）沒有元件，只有數值的視覺化。
  final WidgetBuilder? tokenView;

  int get demoCount => specimens.where((s) => s.hasDemo).length;
}

/// 導覽上的一個分組。
@immutable
class CatalogGroup {
  const CatalogGroup({required this.label, required this.pages});

  final String label;
  final List<CatalogPageData> pages;
}
