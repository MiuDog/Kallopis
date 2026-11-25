# KlpButtonTone

Flutter · Stable · 資料與型別

## 主要職責

按鈕的動作語意，由元件風格表解析成對應呈現。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpButtonTone.danger;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpButtonTone
```

## 建構子 KlpButtonTone



```dart
const KlpButtonTone()
```



## 成員與方法

### danger

```dart
static const KlpButtonTone danger
```



### dashed

```dart
static const KlpButtonTone dashed
```



### ghost

```dart
static const KlpButtonTone ghost
```



### primary

```dart
static const KlpButtonTone primary
```



### secondary

```dart
static const KlpButtonTone secondary
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/button/klp_button_types.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/button/klp_button_types.dart`。
