# KlpContentState

Flutter · Stable · 資料與型別

## 主要職責

可由產品呈現的內容狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpContentState.empty;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpContentState
```

## 建構子 KlpContentState



```dart
const KlpContentState()
```



## 成員與方法

### empty

```dart
static const KlpContentState empty
```



### error

```dart
static const KlpContentState error
```



### loading

```dart
static const KlpContentState loading
```



### permission

```dart
static const KlpContentState permission
```



### ready

```dart
static const KlpContentState ready
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/composition/pane/klp_content_state.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/composition/pane/klp_content_state.dart`。
