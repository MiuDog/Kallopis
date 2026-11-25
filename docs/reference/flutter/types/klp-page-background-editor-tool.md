# KlpPageBackgroundEditorTool

Flutter · Stable · 資料與型別

## 主要職責

背景編輯器目前使用的工具。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPageBackgroundEditorTool.connect;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPageBackgroundEditorTool
```

## 建構子 KlpPageBackgroundEditorTool



```dart
const KlpPageBackgroundEditorTool()
```



## 成員與方法

### connect

```dart
static const KlpPageBackgroundEditorTool connect
```



### delete

```dart
static const KlpPageBackgroundEditorTool delete
```



### select

```dart
static const KlpPageBackgroundEditorTool select
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
