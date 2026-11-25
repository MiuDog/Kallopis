# KlpSidebarButtonData

Flutter · Stable · 資料與型別

## 主要職責

Sidebar 按鈕群組中的單一呈現資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSidebarButtonData createExample(String label, KlpIconData icon, void Function()? onPressed) => KlpSidebarButtonData(label: label, icon: icon, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
final class KlpSidebarButtonData
```

## 建構子 KlpSidebarButtonData



```dart
const KlpSidebarButtonData({
	required String label,
	required KlpIconData icon,
	required VoidCallback? onPressed,
	bool selected = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_sidebar_button_group.dart`。
