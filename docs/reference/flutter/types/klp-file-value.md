# KlpFileValue

Flutter · Stable · 資料與型別

## 主要職責

[KlpFileField] 顯示的一個已選檔案：識別碼、檔名，與選填的中繼資料文字
（例如檔案大小或上傳時間，顯示格式由呼叫端自行組字串）。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileValue createExample(String id, String name) => KlpFileValue(id: id, name: name);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileValue
```

## 建構子 KlpFileValue



```dart
const KlpFileValue({
	required String id,
	required String name,
	String? metadata,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `metadata` | `String?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/structured/klp_file_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_file_field.dart`。
