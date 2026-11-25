# KlpTree

Flutter · Stable · 資料呈現

## 主要職責

樹狀節點清單，用於檔案總管與大綱等階層式導覽。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTree createExample(List<KlpTreeNode> nodes) => KlpTree(nodes: nodes);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTree extends StatelessWidget
```

## 建構子 KlpTree



```dart
const KlpTree({
	Key? key,
	required List<KlpTreeNode> nodes,
	String? label,
	Set<String>? expandedIds,
	String? selectedId,
	ValueChanged<String>? onSelected,
	ValueChanged<String>? onExpanded,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `nodes` | `List<KlpTreeNode>` | 是 | — | 依公開型別提供此輸入。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `expandedIds` | `Set<String>?` | 否 | null | 目前展開的識別集合。 |
| `selectedId` | `String?` | 否 | null | 產品持有的選取識別。 |
| `onSelected` | `void Function(String)?` | 否 | null | 將選取意圖交回產品。 |
| `onExpanded` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpTreeNode](../../types/klp-tree-node.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/advanced/klp_advanced_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/klp_advanced_data.dart`。
