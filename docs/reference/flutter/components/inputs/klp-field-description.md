# KlpFieldDescription

Flutter · Stable · 輸入元件

## 主要職責

欄位輔助說明文字，統一使用低對比（[KlpTextTone.muted]）的
[KlpTextRole.caption] 樣式。

[KlpField] 內部就是用它畫 `description`——需要在 [KlpField] 版面之外
單獨放一段樣式一致的欄位說明時才需要直接用它。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFieldDescription createExample(String description) => KlpFieldDescription(description: description);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFieldDescription extends StatelessWidget
```

## 建構子 KlpFieldDescription



```dart
const KlpFieldDescription({Key? key, required String description})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `description` | `String` | 是 | — | 補充描述。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_field_description.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field_description.dart`。
