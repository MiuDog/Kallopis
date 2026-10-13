// Catalog 分類由 Kallopis semantic manifest 產生。
//
// 修改 `spec/semantics/kallopis.semantic-manifest.json` 後，執行
// `dart run tool/generate_catalog_registry.dart` 更新 registry。
import '../catalog_model.dart';
import 'generated/catalog_registry.g.dart' as generated;
import 'registered_commands_page.dart';

export 'generated/catalog_registry.g.dart' hide catalogGroups, catalogPages, catalogedComponents;

/* 原生成清冊保持順序；獨立 consumer 展示由手寫入口接入，避免生成覆蓋。 */
final List<CatalogGroup> catalogGroups = [
	...generated.catalogGroups,
	CatalogGroup(id: 'workbench-commands', label: 'Workbench commands', description: '公開命令清冊與原生入口展示。', pages: [registeredCommandsPage]),
];

/* 導覽與覆蓋採用同一份產品頁投影，不另維護第二份名稱清冊。 */
final List<CatalogPageData> catalogPages = [for (final group in catalogGroups) ...group.pages];
final Set<String> catalogedComponents = {
	for (final page in catalogPages) for (final specimen in page.specimens) specimen.name,
	for (final page in catalogPages) ...page.coveredComponents,
};
