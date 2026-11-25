# KlpFieldVisualState

Flutter · Stable · 資料與型別

## 主要職責

欄位可能處於的視覺／驗證狀態詞彙表，供消費端的表單狀態機使用。

目前庫內元件不直接讀取這個列舉——[KlpField] 等元件是把 `error`／`status`
這類已算好的字串當參數。它存在的目的是讓不同產品在描述「這個欄位現在算
dirty 還是 conflict」時用同一套語彙，而不是各自發明字串常數。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpFieldVisualState.conflict;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFieldVisualState
```

## 建構子 KlpFieldVisualState



```dart
const KlpFieldVisualState()
```



## 成員與方法

### conflict

```dart
static const KlpFieldVisualState conflict
```



### dirty

```dart
static const KlpFieldVisualState dirty
```



### disabled

```dart
static const KlpFieldVisualState disabled
```



### focused

```dart
static const KlpFieldVisualState focused
```



### invalid

```dart
static const KlpFieldVisualState invalid
```



### pristine

```dart
static const KlpFieldVisualState pristine
```



### readOnly

```dart
static const KlpFieldVisualState readOnly
```



### touched

```dart
static const KlpFieldVisualState touched
```



### valid

```dart
static const KlpFieldVisualState valid
```



### validating

```dart
static const KlpFieldVisualState validating
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/core/klp_field_visual_state.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_field_visual_state.dart`。
