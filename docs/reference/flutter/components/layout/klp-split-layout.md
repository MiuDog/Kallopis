# KlpSplitLayout

Flutter · Stable · 布局元件

## 主要職責

分割版面元件。支援左／中／右或左右分割，以及虛線分隔線。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSplitLayout createExample(Widget leading, Widget trailing) => KlpSplitLayout(leading: leading, trailing: trailing);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSplitLayout extends StatelessWidget
```

## 建構子 KlpSplitLayout



```dart
const KlpSplitLayout({
	Key? key,
	required Widget leading,
	required Widget trailing,
	Widget? center,
	KlpSplitPaneSize leadingSize = KlpSplitPaneSize.primary,
	KlpSplitPaneSize? trailingSize,
	KlpSpaceSize gapSize = KlpSpaceSize.base,
	bool showDashedDivider = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `leading` | `Widget` | 是 | — | 前方內容。 |
| `trailing` | `Widget` | 是 | — | 後方內容。 |
| `center` | `Widget?` | 否 | null | 依公開型別提供此輸入。 |
| `leadingSize` | `KlpSplitPaneSize` | 否 | KlpSplitPaneSize.primary | 依公開型別提供此輸入。 |
| `trailingSize` | `KlpSplitPaneSize?` | 否 | null | 依公開型別提供此輸入。 |
| `gapSize` | `KlpSpaceSize` | 否 | KlpSpaceSize.base | 依公開型別提供此輸入。 |
| `showDashedDivider` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [KlpSpaceSize](../../types/klp-space-size.md)
- [KlpSplitPaneSize](../../types/klp-split-pane-size.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/foundation/layout/klp_split_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/layout/klp_split_layout.dart`。
