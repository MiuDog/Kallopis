# KlpPopupBackground

Flutter · Stable · 內容元件

## 主要職責

Popup 的背景遮罩。點擊 panel 以外的可互動背景時呼叫 [onDismiss]。

若位於 [KlpPopupInteractionScope] 之下，scope 的頂部範圍只負責顯示遮罩，
不會接收 pointer，因此視窗標題列的拖動與雙擊事件優先。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPopupBackground createExample(KlpPopupPanel child, void Function() onDismiss) => KlpPopupBackground(onDismiss: onDismiss, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPopupBackground extends StatelessWidget
```

## 建構子 KlpPopupBackground



```dart
const KlpPopupBackground({
	Key? key,
	required KlpPopupPanel child,
	required VoidCallback onDismiss,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `child` | `KlpPopupPanel` | 是 | — | 產品提供的內容。 |
| `onDismiss` | `void Function()` | 是 | — | 向產品提出關閉意圖。 |


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
- [KlpPopupPanel](../layout/klp-popup-panel.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/overlays/klp_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/overlays/klp_popup.dart`。
