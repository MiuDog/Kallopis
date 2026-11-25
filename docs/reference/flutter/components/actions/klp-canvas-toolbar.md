# KlpCanvasToolbar

Flutter · Experimental · 操作元件

## 主要職責

畫布上的有限動作工具列；動作能力由呼叫端決定。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCanvasToolbar createExample(List<Widget> actions) => KlpCanvasToolbar(actions: actions);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCanvasToolbar extends StatelessWidget
```

## 建構子 KlpCanvasToolbar



```dart
const KlpCanvasToolbar({Key? key, required List<Widget> actions})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `actions` | `List<Widget>` | 是 | — | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/infinite_canvas/klp_canvas_workspace.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/infinite_canvas/klp_canvas_workspace.dart`。
