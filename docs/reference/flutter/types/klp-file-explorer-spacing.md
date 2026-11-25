# KlpFileExplorerSpacing

Flutter · Stable · 資料與型別

## 主要職責

Explorer 的語意間距配方，避免消費者注入 Flutter 幾何物件。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpFileExplorerSpacing.flush;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpFileExplorerSpacing
```

## 建構子 KlpFileExplorerSpacing



```dart
const KlpFileExplorerSpacing()
```



## 成員與方法

### flush

```dart
static const KlpFileExplorerSpacing flush
```

已由外層 Panel 提供 gutter 時使用的貼齊配方。

### indent

```dart
double indent(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### itemPadding

```dart
KlpBoxInsets itemPadding(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### relaxed

```dart
static const KlpFileExplorerSpacing relaxed
```

需要較寬樹狀層級節奏的 Explorer。

### sectionMargin

```dart
KlpBoxInsets sectionMargin(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### sectionPadding

```dart
KlpBoxInsets sectionPadding(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### standard

```dart
static const KlpFileExplorerSpacing standard
```

一般獨立 Explorer 的導覽內距。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。
- [KlpBoxInsets](klp-box-insets.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/explorer/klp_file_explorer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/explorer/klp_file_explorer.dart`。
