# KlpSidebarButtonGroup

Flutter · Stable · 操作元件

## 主要職責

使用 Sidebar chrome 留白與按鈕樣式呈現一組動作。

消費端只注入資料與事件；群組負責邊界留白、滿寬排列及共通按鈕外觀。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarButtonGroup createExample(List<KlpSidebarButtonData> items) => KlpSidebarButtonGroup(items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpSidebarButtonGroup extends StatelessWidget
```

## 建構子 KlpSidebarButtonGroup



```dart
const KlpSidebarButtonGroup({
	Key? key,
	required List<KlpSidebarButtonData> items,
	EdgeInsetsGeometry? padding,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `items` | `List<KlpSidebarButtonData>` | 是 | — | 由產品提供的項目。 |
| `padding` | `EdgeInsetsGeometry?` | 否 | null | 依公開型別提供此輸入。 |


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
- [KlpSidebarButtonData](../../types/klp-sidebar-button-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart`。
