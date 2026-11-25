# KlpFileExplorerSectionView

Flutter · Stable · 工作區元件

## 主要職責

分類區塊視圖（含分類標題、折疊動畫與項目清單）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileExplorerSectionView createExample(KlpFileExplorerSection section, bool isExpanded, Set<String> expandedItemIds, String? selectedId, void Function() onToggle, void Function(String) onItemToggle, void Function(String) onItemSelected) => KlpFileExplorerSectionView(section: section, isExpanded: isExpanded, expandedItemIds: expandedItemIds, selectedId: selectedId, onToggle: onToggle, onItemToggle: onItemToggle, onItemSelected: onItemSelected);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileExplorerSectionView extends StatelessWidget
```

## 建構子 KlpFileExplorerSectionView



```dart
const KlpFileExplorerSectionView({
	Key? key,
	required KlpFileExplorerSection section,
	required bool isExpanded,
	required Set<String> expandedItemIds,
	required String? selectedId,
	required VoidCallback onToggle,
	required ValueChanged<String> onItemToggle,
	required ValueChanged<String> onItemSelected,
	KlpFileExplorerSpacing spacing = KlpFileExplorerSpacing.standard,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `section` | `KlpFileExplorerSection` | 是 | — | 依公開型別提供此輸入。 |
| `isExpanded` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `expandedItemIds` | `Set<String>` | 是 | — | 依公開型別提供此輸入。 |
| `selectedId` | `String?` | 是 | — | 產品持有的選取識別。 |
| `onToggle` | `void Function()` | 是 | — | 將展開或切換意圖交回產品。 |
| `onItemToggle` | `void Function(String)` | 是 | — | 依公開型別提供此輸入。 |
| `onItemSelected` | `void Function(String)` | 是 | — | 依公開型別提供此輸入。 |
| `spacing` | `KlpFileExplorerSpacing` | 否 | KlpFileExplorerSpacing.standard | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpFileExplorerSection](klp-file-explorer-section.md)
- [KlpFileExplorerSpacing](../../types/klp-file-explorer-spacing.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
