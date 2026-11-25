# KlpSelectionAction

Flutter · Stable · 資料與型別

## 主要職責

批次選取工具列的操作資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSelectionAction createExample(String id, String label, void Function()? onPressed) => KlpSelectionAction(id: id, label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSelectionAction
```

## 建構子 KlpSelectionAction



```dart
const KlpSelectionAction({
	required String id,
	required String label,
	required VoidCallback? onPressed,
	bool danger = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `danger` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/filter/models/klp_selection_action.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/filter/models/klp_selection_action.dart`。
