# KlpCommandItemData

Flutter · Experimental · 資料與型別

## 主要職責

提供命令選單項目的顯示資料與操作；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandItemData createExample(String label) => KlpCommandItemData(label: label);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandItemData
```

## 建構子 KlpCommandItemData



```dart
const KlpCommandItemData({
	required String label,
	VoidCallback? onPressed,
	String? caption,
	String? shortcut,
	bool selected = false,
	bool danger = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 否 | null | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `caption` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `shortcut` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `danger` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_menu/klp_command_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_menu/klp_command_menu.dart`。
