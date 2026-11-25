# KlpSidebarSectionLabel

Flutter · Stable · 內容元件

## 主要職責

側邊欄分組標題，固定高度且左對齊、使用低對比的
[KlpTextRole.label] 樣式。

固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會
讓上下間距看起來不一樣。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarSectionLabel createExample(String label) => KlpSidebarSectionLabel(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSidebarSectionLabel extends StatelessWidget
```

## 建構子 KlpSidebarSectionLabel



```dart
const KlpSidebarSectionLabel({Key? key, required String label})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_sidebar_section_label.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_sidebar_section_label.dart`。
