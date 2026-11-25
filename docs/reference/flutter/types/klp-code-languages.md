# KlpCodeLanguages

Flutter · Stable · 資料與型別

## 主要職責

Code Viewer 的預設語言清單。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
final value = KlpCodeLanguages.options;
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract final class KlpCodeLanguages
```

## 建構子 KlpCodeLanguages



```dart
KlpCodeLanguages()
```



## 成員與方法

### options

```dart
static const List<KlpCodeLanguageOption> options
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCodeLanguageOption](klp-code-language-option.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/collections/code/models/klp_code_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/code/models/klp_code_models.dart`。
