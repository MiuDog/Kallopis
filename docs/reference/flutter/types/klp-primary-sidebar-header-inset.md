# KlpPrimarySidebarHeaderInset

Flutter · Stable · 資料與型別

## 主要職責

Primary Sidebar 的 header 與 navigation 區塊內縮。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final value = KlpPrimarySidebarHeaderInset.navigation;
```

<!-- reference-api:start -->

## 公開簽名

```dart
enum KlpPrimarySidebarHeaderInset
```

## 建構子 KlpPrimarySidebarHeaderInset



```dart
const KlpPrimarySidebarHeaderInset()
```



## 成員與方法

### navigation

```dart
static const KlpPrimarySidebarHeaderInset navigation
```



### none

```dart
static const KlpPrimarySidebarHeaderInset none
```



### resolve

```dart
KlpBoxInsets resolve(BuildContext context)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Enum](https://api.dart.dev/dart-core/Enum-class.html)。
- [KlpBoxInsets](klp-box-insets.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/sidebar/klp_primary_sidebar_header_inset.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/sidebar/klp_primary_sidebar_header_inset.dart`。
