# KlpMenuItemData

Flutter · Stable · 資料與型別

## 主要職責

[KlpMenu] 裡的一個項目。

[toggleValue] 非 null 時項目會額外畫出一個開關指示，用於「這個選項本身是
一個可切換設定」的情境（例如選單裡的「顯示隱藏檔案」）；[hasSubmenu] 只是
畫出展開箭頭的視覺提示，實際的子選單彈出邏輯不歸這個資料類別管，由呼叫端
自行處理 [onPressed]。[separatedBefore] 在這個項目之前插入一條分隔線，
用來把選單切成語意上的幾組。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMenuItemData createExample(String label, void Function() onPressed) => KlpMenuItemData(label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMenuItemData
```

## 建構子 KlpMenuItemData



```dart
const KlpMenuItemData({
	required String label,
	required VoidCallback onPressed,
	Key? key,
	KlpIconData? icon,
	String? shortcut,
	String? description,
	String? group,
	String? iconSvg,
	bool? toggleValue,
	bool hasSubmenu = false,
	bool danger = false,
	bool separatedBefore = false,
	bool dashedSeparatorBefore = false,
	bool selected = false,
	bool enabled = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |
| `shortcut` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `description` | `String?` | 否 | null | 區塊選單的次行說明、分類與上游提供的向量圖示。 |
| `group` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `iconSvg` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `toggleValue` | `bool?` | 否 | null | 依公開型別提供此輸入。 |
| `hasSubmenu` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `danger` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `separatedBefore` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `dashedSeparatorBefore` | `bool` | 否 | false | 在此項目前以虛線分組；不可與 [separatedBefore] 同時使用。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/overlays/klp_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_menu.dart`。
