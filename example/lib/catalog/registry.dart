import '../catalog_model.dart';
import 'form_pages.dart';
import 'foundation_pages.dart';
import 'guideline_pages.dart';
import 'settings_pages.dart';
import 'token_pages.dart';

/// 目錄的完整結構。
///
/// **這份清單是元件的權威分類。** `catalog_coverage_test` 會比對它與庫實際匯出的
/// widget——新增元件卻沒有歸類會讓測試失敗，因為**列不出來的元件等於不存在**。
final List<CatalogGroup> catalogGroups = [
  CatalogGroup(
    label: 'Colors',
    pages: [
      brandPage,
      colorModesPage,
      surfacesPage,
      neutralsPage,
      semanticStatusPage,
    ],
  ),
  CatalogGroup(
    label: 'Type',
    pages: [displayHeadingsPage, bodyCopyPage, monospacePage],
  ),
  CatalogGroup(label: 'Spacing', pages: [scalePage, radiiPage, elevationPage]),
  CatalogGroup(
    label: 'Guidelines',
    pages: [blockLayoutPage, prosePage, strokeLanguagePage],
  ),
  CatalogGroup(
    label: 'Foundation',
    pages: [
      actionsNavigationPage,
      fileExplorerPage,
      dataDisplayPage,
      layoutInteractionPage,
      regionPlaceholderPage,
      viewStatesPage,
    ],
  ),
  CatalogGroup(label: 'Form', pages: [formControlsPage, formAssemblyPage]),
  CatalogGroup(label: 'Settings', pages: [settingsPage]),
];

/// 攤平後的頁面清單，順序與導覽一致。
final List<CatalogPageData> catalogPages = [
  for (final group in catalogGroups) ...group.pages,
];

/// 已歸類的元件名。
final Set<String> catalogedComponents = {
  for (final page in catalogPages)
    for (final specimen in page.specimens) specimen.name,
};
