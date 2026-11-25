# KlpCommandSectionData

Flutter · Experimental · 資料與型別

## 主要職責

提供命令選單的區段與項目；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpCommandSectionData createExample(String label, List<KlpCommandItemData> items) => KlpCommandSectionData(label: label, items: items);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpCommandSectionData
```

## 建構子 KlpCommandSectionData



```dart
const KlpCommandSectionData({required String label, required List<KlpCommandItemData> items})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `items` | `List<KlpCommandItemData>` | 是 | — | 由產品提供的項目。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCommandItemData](klp-command-item-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_menu/klp_command_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_menu/klp_command_menu.dart`。
