# KlpPopupPanel

Flutter · Stable · 布局元件

## 主要職責

Popup 的固定尺寸 surface。內容內距由 [child] 自己擁有。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPopupPanel createExample(KlpPopupPanelKind kind, Widget child) => KlpPopupPanel(kind: kind, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPopupPanel extends StatelessWidget
```

## 建構子 KlpPopupPanel



```dart
const KlpPopupPanel({
	Key? key,
	required KlpPopupPanelKind kind,
	required Widget child,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `kind` | `KlpPopupPanelKind` | 是 | — | 依公開型別提供此輸入。 |
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


### largeSize

```dart
static const Size largeSize
```



### standardSize

```dart
static const Size standardSize
```

普通表單面板固定為 600×816，對應建立頻道等完整輸入流程。

<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpPopupPanelKind](../../types/klp-popup-panel-kind.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_popup.dart`。
