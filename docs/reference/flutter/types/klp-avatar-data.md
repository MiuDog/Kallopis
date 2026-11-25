# KlpAvatarData

Flutter · Stable · 資料與型別

## 主要職責

Avatar 群組使用的無產品語意資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAvatarData createExample(String id, String label) => KlpAvatarData(id: id, label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpAvatarData
```

## 建構子 KlpAvatarData



```dart
const KlpAvatarData({
	required String id,
	required String label,
	ImageProvider<Object>? image,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `image` | `ImageProvider<Object>?` | 否 | null | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/avatar/klp_avatar_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/avatar/klp_avatar_data.dart`。
