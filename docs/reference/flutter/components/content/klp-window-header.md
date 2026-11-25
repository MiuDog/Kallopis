# KlpWindowHeader

Flutter · Stable · 內容元件

## 主要職責

桌面應用程式自帶視窗標題列（Chrome Header）。整個 Header 表面都可拖動視窗；
內部操作元件仍保留 tap 等自身事件。

- **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。
- **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpWindowHeader createExample() => KlpWindowHeader();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpWindowHeader extends StatelessWidget implements PreferredSizeWidget
```

## 建構子 KlpWindowHeader



```dart
const KlpWindowHeader({
	Key? key,
	Widget? title,
	String? titleText,
	KlpTextRole titleRole = KlpTextRole.appTitle,
	Widget? titleTrailing,
	Widget? appIcon,
	Widget? appIconButton,
	List<Widget>? actions,
	Widget? leading,
	Widget? trailing,
	KlpAppPlatform? platform,
	double? height,
	VoidCallback? onMinimize,
	VoidCallback? onDrag,
	VoidCallback? onToggleMaximize,
	VoidCallback? onClose,
	bool isMaximized = false,
	bool showWindowControls = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `Widget?` | 否 | null | 自訂標題 Widget。優先於 [titleText]。 |
| `titleText` | `String?` | 否 | null | 標題純文字。 |
| `titleRole` | `KlpTextRole` | 否 | KlpTextRole.appTitle | 產品標題字體角色（預設使用 [KlpTextRole.appTitle]）。 |
| `titleTrailing` | `Widget?` | 否 | null | 緊接在標題右方的控制項；適合在面板收合後保留展開按鈕。 |
| `appIcon` | `Widget?` | 否 | null | 應用程式圖示。 |
| `appIconButton` | `Widget?` | 否 | null | 佔用 App icon 槽位的互動按鈕。提供時優先於 [appIcon]。 |
| `actions` | `List<Widget>?` | 否 | null | 頂部自訂動作按鈕清單。 |
| `leading` | `Widget?` | 否 | null | 自訂最左側區域（若為 macOS 且提供則排在控制鈕後）。 |
| `trailing` | `Widget?` | 否 | null | 自訂最右側區域。 |
| `platform` | `KlpAppPlatform?` | 否 | null | 手動指定平台外觀風格（預設依系統環境判定）。 |
| `height` | `double?` | 否 | null | 標題列版面占位高度；未指定時為內容高度加上上下 margin。 |
| `onMinimize` | `void Function()?` | 否 | null | 最小化視窗回呼。 |
| `onDrag` | `void Function()?` | 否 | null | 由產品宿主接手原生視窗拖動。 |
| `onToggleMaximize` | `void Function()?` | 否 | null | 最大化／還原視窗回呼。 |
| `onClose` | `void Function()?` | 否 | null | 關閉視窗回呼。 |
| `isMaximized` | `bool` | 否 | false | 目前視窗是否為最大化狀態。 |
| `showWindowControls` | `bool` | 否 | true | 是否顯示視窗控制按鈕（最小化、最大化、關閉）。 |


## 成員與方法

### build

```dart
Widget build(BuildContext context)
```

由 Flutter 依目前 context 建構畫面。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


### preferredSize

```dart
Size get preferredSize
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- 框架繼承成員：[PreferredSizeWidget](https://api.flutter.dev/flutter/widgets/PreferredSizeWidget-class.html)。
- [KlpAppPlatform](../../platform/klp-app-platform.md)
- [KlpTextRole](../../types/klp-text-role.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/window/klp_window_header.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/window/klp_window_header.dart`。
