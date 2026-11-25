# KlpConditionalFieldRegion

Flutter · Stable · 輸入元件

## 主要職責

依條件顯示／隱藏一段欄位，並用 Kallopis 尺寸動畫補間高度變化，避免表單
其他欄位因為突然增減內容而跳動。

[visible] 為 false 時 [child] 會被整個換成零尺寸盒，因此
child 的 widget 狀態不會保留——若 child 內有輸入控制項且需要在重新顯示時
保住使用者輸入，請自行在 child 上加 [GlobalKey] 或改用其他方式保存資料。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpConditionalFieldRegion createExample(bool visible, Widget child) => KlpConditionalFieldRegion(visible: visible, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpConditionalFieldRegion extends StatelessWidget
```

## 建構子 KlpConditionalFieldRegion



```dart
const KlpConditionalFieldRegion({
	Key? key,
	required bool visible,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `visible` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |


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

- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/forms/core/klp_conditional_field_region.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/core/klp_conditional_field_region.dart`。
