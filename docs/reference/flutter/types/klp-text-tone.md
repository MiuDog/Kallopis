# KlpTextTone

Flutter · Stable · 資料與型別

## 主要職責

文字的語意顯示色調。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpTextTone.accent;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpTextTone
```

## 建構子 KlpTextTone



```dart
const KlpTextTone()
```



## 成員與方法

### accent

```dart
static const KlpTextTone accent
```



### automatic

```dart
static const KlpTextTone automatic
```



### danger

```dart
static const KlpTextTone danger
```



### faint

```dart
static const KlpTextTone faint
```



### muted

```dart
static const KlpTextTone muted
```



### primary

```dart
static const KlpTextTone primary
```



### success

```dart
static const KlpTextTone success
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/content/klp_text_tone.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/content/klp_text_tone.dart`。
