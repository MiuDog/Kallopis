# KlpPreviewCardSize

Flutter · Stable · 資料與型別

## 主要職責

預覽卡內容區的型別化高度角色。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPreviewCardSize.compact;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPreviewCardSize
```

## 建構子 KlpPreviewCardSize



```dart
const KlpPreviewCardSize()
```



## 成員與方法

### compact

```dart
static const KlpPreviewCardSize compact
```

緊湊呈現選項。

### large

```dart
static const KlpPreviewCardSize large
```



### standard

```dart
static const KlpPreviewCardSize standard
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/preview_card/klp_preview_card_size.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/preview_card/klp_preview_card_size.dart`。
