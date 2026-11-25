# KlpFilePicker

Flutter · Stable · 平台整合

## 主要職責

由產品直接呼叫的本機單檔選取服務。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpFilePicker createExample() => KlpFilePicker();
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpFilePicker
```

## 建構子 KlpFilePicker



```dart
const KlpFilePicker({List<String> acceptedExtensions = const []})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `acceptedExtensions` | `List<String>` | 否 | const [] | 依公開型別提供此輸入。 |


## 成員與方法

### pick

```dart
Future<String?> pick()
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/platform/klp_file_picker.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/platform/klp_file_picker.dart`。
