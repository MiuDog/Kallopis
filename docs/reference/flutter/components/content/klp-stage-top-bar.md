# KlpStageTopBar

Flutter · Stable · 內容元件

## 主要職責

位於 Workbench window header 中央 Stage 區域的分頁與動作列。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStageTopBar createExample(Widget tab) => KlpStageTopBar(tab: tab);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStageTopBar extends StatelessWidget
```

## 建構子 KlpStageTopBar



```dart
const KlpStageTopBar({
	Key? key,
	required Widget tab,
	List<Widget> actions = const [],
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `tab` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `actions` | `List<Widget>` | 否 | const [] | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/stage/klp_stage_top_bar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/stage/klp_stage_top_bar.dart`。
