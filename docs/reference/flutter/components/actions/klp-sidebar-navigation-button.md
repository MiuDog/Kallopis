# KlpSidebarNavigationButton

Flutter · Stable · 操作元件

## 主要職責

Primary Sidebar 內的全寬導覽按鈕。

消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、
hover 與選取色全部由 Kallopis theme 決定。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarNavigationButton createExample(KlpIconData icon, String label, void Function()? onPressed) => KlpSidebarNavigationButton(icon: icon, label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSidebarNavigationButton extends StatefulWidget
```

## 建構子 KlpSidebarNavigationButton



```dart
const KlpSidebarNavigationButton({
	Key? key,
	required KlpIconData icon,
	required String label,
	required VoidCallback? onPressed,
	bool selected = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |


## 成員與方法

### createState

```dart
State<KlpSidebarNavigationButton> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_sidebar_navigation_button.dart`。
