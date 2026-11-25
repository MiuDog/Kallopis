# KlpFileExplorerSection

Flutter · Stable · 工作區元件

## 主要職責

檔案瀏覽器中的分類資料模型（例如「釘選」、「筆記」）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileExplorerSection createExample(String id, String title) => KlpFileExplorerSection(id: id, title: title);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileExplorerSection extends StatelessWidget
```

## 建構子 KlpFileExplorerSection



```dart
const KlpFileExplorerSection({
	Key? key,
	required String id,
	required String title,
	List<KlpFileExplorerItem> items = const [],
	bool expanded = true,
	bool collapsible = true,
	Widget? trailing,
	Widget Function(BuildContext, Widget)? headerWrapper,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `items` | `List<KlpFileExplorerItem>` | 否 | const [] | 由產品提供的項目。 |
| `expanded` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `collapsible` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `trailing` | `Widget?` | 否 | null | 後方內容。 |
| `headerWrapper` | `Widget Function(BuildContext, Widget)?` | 否 | null | 允許產品為分類標題接上拖放與選單。 |


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
- [KlpFileExplorerItem](../../types/klp-file-explorer-item.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
