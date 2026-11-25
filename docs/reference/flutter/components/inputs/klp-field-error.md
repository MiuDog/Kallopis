# KlpFieldError

Flutter · Stable · 輸入元件

## 主要職責

單獨呈現的欄位錯誤文字，包了 Kallopis live region，讓螢幕
報讀器在錯誤出現時主動唸出來，不需要使用者手動聚焦。

[KlpField] 的內建錯誤列沒有這層 live region 包裝；需要非同步驗證結果
出現時立即被報讀器感知，才需要在 [KlpField] 之外單獨用它。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFieldError createExample(String error) => KlpFieldError(error: error);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFieldError extends StatelessWidget
```

## 建構子 KlpFieldError



```dart
const KlpFieldError({Key? key, required String error})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `error` | `String` | 是 | — | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_field_error.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field_error.dart`。
