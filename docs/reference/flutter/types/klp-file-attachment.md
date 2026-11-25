# KlpFileAttachment

Flutter · Stable · 資料與型別

## 主要職責

檔案附件資料。包含檔名、檔案大小與可選的上傳進度 (0.0~1.0)。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFileAttachment createExample(String name, String size) => KlpFileAttachment(name: name, size: size);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpFileAttachment
```

## 建構子 KlpFileAttachment



```dart
const KlpFileAttachment({
	required String name,
	required String size,
	double? progress,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `name` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `size` | `String` | 是 | — | 尺寸選擇。 |
| `progress` | `double?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/structured/klp_file_dropzone_field.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/structured/klp_file_dropzone_field.dart`。
