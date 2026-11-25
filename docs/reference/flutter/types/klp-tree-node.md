# KlpTreeNode

Flutter · Stable · 資料與型別

## 主要職責

提供樹狀資料節點；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpTreeNode createExample(String id, String label) => KlpTreeNode(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpTreeNode
```

## 建構子 KlpTreeNode



```dart
const KlpTreeNode({
	required String id,
	required String label,
	KlpIconData? icon,
	List<KlpTreeNode> children = const [],
	bool expanded = true,
	bool selected = false,
	bool hasChildren = false,
	bool deleted = false,
	String? badge,
	KlpFeedbackTone? tone,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `children` | `List<KlpTreeNode>` | 否 | const [] | 產品提供的子內容。 |
| `expanded` | `bool` | 否 | true | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `hasChildren` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `deleted` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `badge` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `tone` | `KlpFeedbackTone?` | 否 | null | 選擇語意呈現。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpFeedbackTone](klp-feedback-tone.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/advanced/models/klp_advanced_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/advanced/models/klp_advanced_models.dart`。
