# KlpWindowControls

Flutter · Stable · 內容元件

## 主要職責

依平台策略排列視窗控制按鈕。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowControls createExample(void Function()? onMinimize, void Function()? onToggleMaximize, void Function()? onClose) => KlpWindowControls(onMinimize: onMinimize, onToggleMaximize: onToggleMaximize, onClose: onClose);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowControls extends StatelessWidget
```

## 建構子 KlpWindowControls



```dart
const KlpWindowControls({
	Key? key,
	required VoidCallback? onMinimize,
	required VoidCallback? onToggleMaximize,
	required VoidCallback? onClose,
	bool isMaximized = false,
	KlpWindowControlsStyle style = KlpWindowControlsStyle.adaptive,
	KlpWindowControlsGeometry? geometry,
	Key? minimizeKey,
	Key? maximizeKey,
	Key? closeKey,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `onMinimize` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onToggleMaximize` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onClose` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `isMaximized` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `style` | `KlpWindowControlsStyle` | 否 | KlpWindowControlsStyle.adaptive | 依公開型別提供此輸入。 |
| `geometry` | `KlpWindowControlsGeometry?` | 否 | null | 依公開型別提供此輸入。 |
| `minimizeKey` | `Key?` | 否 | null | 依公開型別提供此輸入。 |
| `maximizeKey` | `Key?` | 否 | null | 依公開型別提供此輸入。 |
| `closeKey` | `Key?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### buildPlatformControls

```dart
Widget buildPlatformControls(BuildContext context, bool isMac)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |
| `isMac` | `bool` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpWindowControlsGeometry](../../types/klp-window-controls-geometry.md)
- [KlpWindowControlsStyle](../../types/klp-window-controls-style.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/window/klp_window_controls.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_controls.dart`。
