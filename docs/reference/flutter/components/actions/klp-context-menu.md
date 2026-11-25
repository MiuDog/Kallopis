# KlpContextMenu

Flutter · Stable · 操作元件

## 主要職責

右鍵選單：掛在任意子樹上，滑鼠右鍵或觸控長按於指標位置彈出。

選單本體重用既有的 [KlpMenu] 與 [KlpMenuItemData]——本元件只負責觸發時機、
指標定位與點外部關閉，**不重新實作選單外觀**（一條規則只能有一個實作）。
彈出位置沿用 [KlpMenuLayout.resolvePosition]，與 [KlpMenu] 在其他彈出場景
使用同一套定位邏輯，才不會有兩份互相分岔的擺放規則。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpContextMenu createExample(Widget child, String label, List<KlpMenuItemData> items) => KlpContextMenu(label: label, items: items, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpContextMenu extends StatefulWidget
```

## 建構子 KlpContextMenu



```dart
const KlpContextMenu({
	Key? key,
	required Widget child,
	required String label,
	required List<KlpMenuItemData> items,
	KlpContextMenuController? controller,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `Widget` | 是 | — | 掛載右鍵選單行為的子樹。 |
| `label` | `String` | 是 | — | 選單標題。庫不替產品決定用什麼語言說明這組動作——呼叫端必須提供。 |
| `items` | `List<KlpMenuItemData>` | 是 | — | 選單項目，重用 [KlpMenu] 既有的資料模型。 |
| `controller` | `KlpContextMenuController?` | 否 | null | 借用產品提供的控制器。 |


## 成員與方法

### createState

```dart
State<KlpContextMenu> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpContextMenuController](../../controllers/klp-context-menu-controller.md)
- [KlpMenu](klp-menu.md)
- [KlpMenuItemData](../../types/klp-menu-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_context_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_context_menu.dart`。
