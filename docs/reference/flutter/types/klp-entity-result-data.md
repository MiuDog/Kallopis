# KlpEntityResultData

Flutter · Experimental · 資料與型別

## 主要職責

提供實體選取的結果資料；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpEntityResultData createExample(String kind, String label) => KlpEntityResultData(kind: kind, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpEntityResultData
```

## 建構子 KlpEntityResultData



```dart
const KlpEntityResultData({
	required String kind,
	required String label,
	String? trailing,
	bool selected = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `kind` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `trailing` | `String?` | 否 | null | 後方內容。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/entity_picker/klp_entity_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/entity_picker/klp_entity_picker.dart`。
