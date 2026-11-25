# KlpCommandPopupDismissReason

Flutter · Stable · 資料與型別

## 主要職責

同一 popup session 的關閉意圖，由產品採用或保留 open 狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpCommandPopupDismissReason.escape;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpCommandPopupDismissReason
```

## 建構子 KlpCommandPopupDismissReason



```dart
const KlpCommandPopupDismissReason()
```



## 成員與方法

### escape

```dart
static const KlpCommandPopupDismissReason escape
```



### executed

```dart
static const KlpCommandPopupDismissReason executed
```



### outside

```dart
static const KlpCommandPopupDismissReason outside
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_popup/klp_command_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_popup/klp_command_popup.dart`。
