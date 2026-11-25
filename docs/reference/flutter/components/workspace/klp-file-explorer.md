# KlpFileExplorer

Flutter · Stable · 工作區元件

## 主要職責

檔案瀏覽器（File Explorer）。

支援分類分組（可折疊）、資料夾樹狀結構（可展開）與一般檔案節點選取。
支援受控（傳入 `expandedSectionIds` / `expandedItemIds` / `selectedId`）
與非受控（讀取各 Section 與 Item 的 `expanded` / `selected` 屬性）兩種模式。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileExplorer createExample(List<KlpFileExplorerSection> sections) => KlpFileExplorer(sections: sections);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileExplorer extends StatefulWidget
```

## 建構子 KlpFileExplorer



```dart
const KlpFileExplorer({
	Key? key,
	required List<KlpFileExplorerSection> sections,
	Set<String>? expandedSectionIds,
	Set<String>? expandedItemIds,
	String? selectedId,
	ValueChanged<String>? onSectionToggle,
	ValueChanged<String>? onItemToggle,
	ValueChanged<String>? onItemSelected,
	KlpFileExplorerSpacing spacing = KlpFileExplorerSpacing.standard,
	List<KlpFileExplorerSection> emptyStateSections = const [],
	ScrollController? scrollController,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `sections` | `List<KlpFileExplorerSection>` | 是 | — | 產品投影的區段資料。 |
| `expandedSectionIds` | `Set<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `expandedItemIds` | `Set<String>?` | 否 | null | 依公開型別提供此輸入。 |
| `selectedId` | `String?` | 否 | null | 產品持有的選取識別。 |
| `onSectionToggle` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onItemToggle` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `onItemSelected` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |
| `spacing` | `KlpFileExplorerSpacing` | 否 | KlpFileExplorerSpacing.standard | 依公開型別提供此輸入。 |
| `emptyStateSections` | `List<KlpFileExplorerSection>` | 否 | const [] | [sections] 沒有資料時仍需保留的視覺分區。<br><br>這只描述 Explorer 結構，不會把 placeholder section 寫回資料模型。 |
| `scrollController` | `ScrollController?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpFileExplorer> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- [3. 投影狀態與回傳事件](../../../../guides/flutter/04-klp-panel-frame.md)：跨元件使用流程。
- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpFileExplorerSection](klp-file-explorer-section.md)
- [KlpFileExplorerSpacing](../../types/klp-file-explorer-spacing.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
