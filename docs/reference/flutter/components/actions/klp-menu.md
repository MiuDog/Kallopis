# KlpMenu

Flutter · Stable · 操作元件

## 主要職責

彈出式選單面板：標題列加上一組 [KlpMenuItemData]。

只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用
[KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端控制。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMenu createExample(String label, List<KlpMenuItemData> items) => KlpMenu(label: label, items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMenu extends StatefulWidget
```

## 建構子 KlpMenu



```dart
const KlpMenu({
	Key? key,
	required String label,
	required List<KlpMenuItemData> items,
	bool autofocus = true,
	VoidCallback? onEscape,
	bool scrollable = false,
	bool searchable = false,
	String? searchPlaceholder,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `items` | `List<KlpMenuItemData>` | 是 | — | 由產品提供的項目。 |
| `autofocus` | `bool` | 否 | true | 是否在選單出現時自動取得鍵盤焦點，才能立刻用方向鍵操作。預設 `true`。 |
| `onEscape` | `void Function()?` | 否 | null | 按下 `Escape` 時呼叫；未提供時不產生作用。 |
| `scrollable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `searchable` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `searchPlaceholder` | `String?` | 否 | null | 依公開型別提供此輸入。 |


## 成員與方法

### createState

```dart
State<KlpMenu> createState()
```

由 Flutter 建立此元件的 State。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)。
- [KlpMenuItemData](../../types/klp-menu-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_menu.dart`。
