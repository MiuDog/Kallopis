# KlpDrawer

Flutter · Stable · 內容元件

## 主要職責

從邊緣滑入的面板：側邊欄、篩選面板，或（[KlpDrawerEdge.bottom] 方向）行動裝置
常見的 sheet。

*不負責彈出**——呼叫端決定用什麼容器承載這個 widget（例如
`KlpOverlayHost`、`KlpStack` 或 `Overlay`），並透過 [open] 驅動顯示與否；
本元件只負責滑入滑出的動畫、遮罩與「點遮罩關閉」這個互動。呼叫端持有
[open] 的狀態，本元件本身不追蹤開關。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDrawer createExample(bool open, Widget child) => KlpDrawer(open: open, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDrawer extends StatelessWidget
```

## 建構子 KlpDrawer



```dart
const KlpDrawer({
	Key? key,
	required bool open,
	required Widget child,
	KlpDrawerEdge edge = KlpDrawerEdge.right,
	double? size,
	double? progress,
	VoidCallback? onScrimTap,
	bool barrierDismissible = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `open` | `bool` | 是 | — | 是否展開。 |
| `child` | `Widget` | 是 | — | 面板內容。 |
| `edge` | `KlpDrawerEdge` | 否 | KlpDrawerEdge.right | 從哪個邊緣滑入。`bottom` 即一般所稱的 sheet。 |
| `size` | `double?` | 否 | null | 面板尺寸：[KlpDrawerEdge.left]／[KlpDrawerEdge.right] 為寬度，<br>[KlpDrawerEdge.top]／[KlpDrawerEdge.bottom] 為高度。<br>`null` 表示沿用 theme 的預設面板尺寸。 |
| `progress` | `double?` | 否 | null | 受呼叫端控制的開啟進度；`0` 為完全收合，`1` 為完全展開。<br><br>未提供時依 [open] 使用既有的開關動畫；提供時可讓抽屜跟隨拖動位置。 |
| `onScrimTap` | `void Function()?` | 否 | null | 點遮罩時呼叫，用於關閉面板。 |
| `barrierDismissible` | `bool` | 否 | true | 點遮罩是否關閉——即遮罩是否攔截點擊事件。收合時遮罩一律不攔截，<br>不受此旗標影響。 |


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
- [KlpDrawerEdge](../../types/klp-drawer-edge.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_drawer.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_drawer.dart`。
