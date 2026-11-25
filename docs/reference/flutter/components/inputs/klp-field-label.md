# KlpFieldLabel

Flutter · Stable · 輸入元件

## 主要職責

欄位標籤文字，統一使用 [KlpTextRole.caption] 樣式。

[KlpField] 內部就是用它畫標籤——需要在 [KlpField] 版面之外單獨放一個
樣式一致的欄位標籤時（例如自訂版面）才需要直接用它。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFieldLabel createExample(String label) => KlpFieldLabel(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFieldLabel extends StatelessWidget
```

## 建構子 KlpFieldLabel



```dart
const KlpFieldLabel({Key? key, required String label})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_field_label.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field_label.dart`。
