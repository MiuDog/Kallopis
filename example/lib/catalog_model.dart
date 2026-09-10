import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

@immutable
class CatalogStyleSemantics {
  const CatalogStyleSemantics({
    required this.source,
    required this.colors,
    required this.surfaces,
    required this.borders,
    required this.spacing,
    required this.typography,
    required this.geometry,
    required this.motion,
    required this.components,
  });

  final String source;
  final List<String> colors;
  final List<String> surfaces;
  final List<String> borders;
  final List<String> spacing;
  final List<String> typography;
  final List<String> geometry;
  final List<String> motion;
  final List<String> components;

  String get tooltipMessage {
    return [
      '風格語意｜來源：$source',
      '顏色：${_describe(colors)}',
      'Surface：${_describe(surfaces)}',
      '邊框／Shape：${_describe(borders)}',
      'Padding／Spacing：${_describe(spacing)}',
      '字體：${_describe(typography)}',
      'Geometry：${_describe(geometry)}',
      'Motion：${_describe(motion)}',
      '其他 resolver／組成元件：${_describe(components)}',
    ].join('\n');
  }

  String get description {
    return [
      '風格語意｜來源：$source',
      '顏色：${_describe(colors)}',
      'Surface：${_describe(surfaces)}',
      '邊框／Shape：${_describe(borders)}',
      'Padding／Spacing：${_describe(spacing)}',
      '字體：${_describe(typography)}',
      'Geometry：${_describe(geometry)}',
      'Motion：${_describe(motion)}',
      '組成／Resolver：${_describe(components)}',
    ].join(' · ');
  }

  String _describe(List<String> values) {
    return values.isEmpty ? '未宣告' : values.join('、');
  }
}

/// 一個元件的展示。
///
/// [name] 必須與公開型別名完全一致——`catalog_coverage_test` 用它比對「庫匯出的每個
/// widget 都出現在目錄裡」。名字打錯會讓覆蓋檢查誤判為缺漏。
@immutable
class Specimen {
  const Specimen({
    required this.name,
    this.note,
    this.build,
    this.sectionLabel,
  });

  /// 公開型別名，例如 `KlpButton`。
  final String name;

  /// 一句話說明它負責什麼、以及哪些決定不歸它管。
  final String? note;

  /// 實際的展示。`null` 表示尚未寫示範——目錄仍會列出它，並標記為未展示，
  /// 因為**列不出來的元件等於不存在**，藏起來只會讓缺口消失在視線外。
  final WidgetBuilder? build;

  /// 需要在此展示前開啟的新內容分組；未提供時延續目前分組。
  final String? sectionLabel;

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
    this.coveredComponents = const [],
    this.tokenView,
    this.visualStyle,
  });

  final String label;
  final String title;
  final String description;
  final KlpIconData icon;

  /// 這一頁負責展示的元件。
  final List<Specimen> specimens;

  /// 此頁以系統說明涵蓋、但不應由 consumer 個別組裝的相容 building blocks。
  final List<String> coveredComponents;

  /// token 頁（顏色、間距、圓角）沒有元件，只有數值的視覺化。
  final WidgetBuilder? tokenView;

  /// 只套用於這一頁 specimen 的完整視覺配方。
  final KlpVisualStyle Function(KlpVisualStyle base)? visualStyle;

  int get demoCount => specimens.where((s) => s.hasDemo).length;
}

/// 導覽上的一個分組。
@immutable
class CatalogGroup {
  const CatalogGroup({
    required this.id,
    required this.label,
    required this.description,
    required this.pages,
  });

  final String id;
  final String label;
  final String description;
  final List<CatalogPageData> pages;
}
