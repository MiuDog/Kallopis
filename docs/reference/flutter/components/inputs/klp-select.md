# KlpSelect

Flutter · Stable · 輸入元件

## 主要職責

下拉選擇的觸發器，只顯示目前值並轉送開啟選單事件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSelect createExample(String label, String value, void Function() onPressed) => KlpSelect(label: label, value: value, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSelect extends StatefulWidget
```

## 建構子 KlpSelect



```dart
const KlpSelect({
	Key? key,
	required String label,
	required String value,
	required VoidCallback onPressed,
	bool enabled = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `value` | `String` | 是 | — | 目前值。 |
| `onPressed` | `void Function()` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpSelect> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/selection/klp_select.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_select.dart`。
