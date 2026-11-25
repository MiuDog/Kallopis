# KlpMenuItem

Flutter · Stable · 操作元件

## 主要職責

[KlpMenu] 裡單一項目的渲染；互動與狀態表面統一交由 [KlpActionRegion]。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpMenuItem createExample(KlpMenuItemData data) => KlpMenuItem(data: data);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpMenuItem extends StatelessWidget
```

## 建構子 KlpMenuItem



```dart
const KlpMenuItem({
	Key? key,
	required KlpMenuItemData data,
	bool keyboardHighlighted = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `data` | `KlpMenuItemData` | 是 | — | 依公開型別提供此輸入。 |
| `keyboardHighlighted` | `bool` | 否 | false | 由容器以鍵盤方向鍵移動出的高亮狀態，不影響真正的 selected 狀態。 |


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

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpMenuItemData](../../types/klp-menu-item-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_menu.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_menu.dart`。
