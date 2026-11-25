# KlpFrameGroupContentSpacing

Flutter · Stable · 資料與型別

## 主要職責

群組內容之間的標準或無間距選項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpFrameGroupContentSpacing.none;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFrameGroupContentSpacing
```

## 建構子 KlpFrameGroupContentSpacing



```dart
const KlpFrameGroupContentSpacing()
```



## 成員與方法

### none

```dart
static const KlpFrameGroupContentSpacing none
```



### standard

```dart
static const KlpFrameGroupContentSpacing standard
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_frame_groups.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_frame_groups.dart`。
