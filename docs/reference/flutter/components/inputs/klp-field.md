# KlpField

Flutter · Stable · 輸入元件

## 主要職責

單一表單欄位的完整外框：標籤、選填說明、輸入控制項（[child]），以及
底部的錯誤／狀態／字數提示列。

[error]、[status]、[counter]、[errorCode] 共用同一列版面：底部提示列只在
四者至少有一個非 null 時才出現；[error] 優先於 [status]（兩者同時給只顯示
error），[errorCode]／[counter] 則各自靠右並存，通常放系統層級的診斷代碼
（例如後端回傳的驗證錯誤碼）供支援排查用，不是給一般使用者讀的文案。
實際的驗證邏輯、何時算 required 都由呼叫端決定，這個元件只負責排版。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpField createExample(String label, Widget child) => KlpField(label: label, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpField extends StatelessWidget
```

## 建構子 KlpField



```dart
const KlpField({
	Key? key,
	required String label,
	required Widget child,
	String? description,
	String? error,
	String? errorCode,
	String? requirement,
	bool required = false,
	String? status,
	String? counter,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `description` | `String?` | 否 | null | 補充描述。 |
| `error` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `errorCode` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `requirement` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `required` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `status` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `counter` | `String?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field.dart`。
