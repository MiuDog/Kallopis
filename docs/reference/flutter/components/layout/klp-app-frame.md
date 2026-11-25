# KlpAppFrame

Flutter · Stable · 布局元件

## 主要職責

App background 第一層具名 frame；內容內距由 child 自己決定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpAppFrame createExample(Widget child) => KlpAppFrame(child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpAppFrame extends KlpLayoutNode
```

## 建構子 KlpAppFrame



```dart
KlpAppFrame({
	Key? key,
	required Widget child,
	int flex = 1,
	KlpLayoutBounds bounds = const KlpLayoutBounds(),
	KlpAppFrameRole role = KlpAppFrameRole.content,
	KlpAppFrameSurface surface = KlpAppFrameSurface.flat,
	double? width,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `flex` | `int` | 否 | 1 | 依公開型別提供此輸入。 |
| `bounds` | `KlpLayoutBounds` | 否 | const KlpLayoutBounds() | 依公開型別提供此輸入。 |
| `role` | `KlpAppFrameRole` | 否 | KlpAppFrameRole.content | 依公開型別提供此輸入。 |
| `surface` | `KlpAppFrameSurface` | 否 | KlpAppFrameSurface.flat | 依公開型別提供此輸入。 |
| `width` | `double?` | 否 | null | 依公開型別提供此輸入。 |


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

- [一般布局 bounds 與 divider](../../../../guides/flutter/08-klp-layout-pane.md)：跨元件使用流程。
- 繼承／實作：[KlpLayoutNode](../../types/klp-layout-node.md)。
- [KlpAppFrameRole](../../types/klp-app-frame-role.md)
- [KlpAppFrameSurface](../../types/klp-app-frame-surface.md)
- [KlpLayoutBounds](../../types/klp-layout-bounds.md)
- [KlpLayoutNode](../../types/klp-layout-node.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
