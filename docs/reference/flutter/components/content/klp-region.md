# KlpRegion

Flutter · Stable · 內容元件

## 主要職責

區域容器。包裝標題、主要內容與頁尾。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpRegion createExample(Widget content) => KlpRegion(content: content);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpRegion extends StatelessWidget
```

## 建構子 KlpRegion



```dart
const KlpRegion({
	Key? key,
	required Widget content,
	Widget? header,
	Widget? footer,
	KlpSurfaceTone tone = KlpSurfaceTone.base,
	EdgeInsetsGeometry? padding,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `content` | `Widget` | 是 | — | 依公開型別提供此輸入。 |
| `header` | `Widget?` | 否 | null | 標頭內容。 |
| `footer` | `Widget?` | 否 | null | 頁尾內容。 |
| `tone` | `KlpSurfaceTone` | 否 | KlpSurfaceTone.base | 選擇語意呈現。 |
| `padding` | `EdgeInsetsGeometry?` | 否 | null | `null` 表示沿用 theme 的面板內距。內容不應該貼著面板邊緣——<br>傳 [EdgeInsets.zero] 才是刻意讓內容自己貼邊（例如內部自帶捲動區）。 |


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
- [KlpSurfaceTone](../../types/klp-surface-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_region.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_region.dart`。
