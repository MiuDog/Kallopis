# KlpFormErrorSummary

Flutter · Stable · 輸入元件

## 主要職責

表單頂部的錯誤總覽卡片，把所有驗證失敗的欄位集中列成清單。

[errors] 的 key 是欄位識別碼、value 是要顯示的錯誤文字；點擊某一項會透過
[onSelected] 回報該欄位的 key，呼叫端通常用它把焦點捲動或移到對應欄位。
不會反查欄位在畫面上的位置——[KlpForm] 之類的容器也不知道每個欄位的
GlobalKey，捲動與聚焦的實作留給呼叫端。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFormErrorSummary createExample(String title, Map<String, String> errors) => KlpFormErrorSummary(title: title, errors: errors);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFormErrorSummary extends StatelessWidget
```

## 建構子 KlpFormErrorSummary



```dart
const KlpFormErrorSummary({
	Key? key,
	required String title,
	required Map<String, String> errors,
	ValueChanged<String>? onSelected,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `errors` | `Map<String, String>` | 是 | — | 依公開型別提供此輸入。 |
| `onSelected` | `void Function(String)?` | 否 | null | 將選取意圖交回產品。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_form_error_summary.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_form_error_summary.dart`。
