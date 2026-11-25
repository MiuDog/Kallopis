# KlpPaneCollapseControl

Flutter · Stable · 布局元件

## 主要職責

Pane 的收合互動控制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPaneCollapseControl createExample(bool collapsed, void Function()? onToggle) => KlpPaneCollapseControl(collapsed: collapsed, onToggle: onToggle);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPaneCollapseControl extends StatelessWidget
```

## 建構子 KlpPaneCollapseControl



```dart
const KlpPaneCollapseControl({
	Key? key,
	KlpIconData? icon,
	String? label,
	required bool collapsed,
	required VoidCallback? onToggle,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `label` | `String?` | 否 | null | 顯示標籤。 |
| `collapsed` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `onToggle` | `void Function()?` | 是 | — | 將展開或切換意圖交回產品。 |


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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/composition/pane/klp_pane_collapse_control.dart`。
