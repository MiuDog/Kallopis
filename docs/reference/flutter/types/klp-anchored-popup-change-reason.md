# KlpAnchoredPopupChangeReason

Flutter · Stable · 資料與型別

## 主要職責

受控 popup 的開關原因；只描述呈現層請求，不代表 consumer 已接受。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpAnchoredPopupChangeReason.anchorUnavailable;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpAnchoredPopupChangeReason
```

## 建構子 KlpAnchoredPopupChangeReason



```dart
const KlpAnchoredPopupChangeReason()
```



## 成員與方法

### anchorUnavailable

```dart
static const KlpAnchoredPopupChangeReason anchorUnavailable
```



### escape

```dart
static const KlpAnchoredPopupChangeReason escape
```



### outside

```dart
static const KlpAnchoredPopupChangeReason outside
```



### trigger

```dart
static const KlpAnchoredPopupChangeReason trigger
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
