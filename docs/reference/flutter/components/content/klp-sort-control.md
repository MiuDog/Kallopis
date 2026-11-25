# KlpSortControl

Flutter · Stable · 內容元件

## 主要職責

顯示目前方向並將排序切換事件交還呼叫端的中性控制項。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSortControl createExample(String label, bool ascending, void Function()? onPressed) => KlpSortControl(label: label, ascending: ascending, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSortControl extends StatelessWidget
```

## 建構子 KlpSortControl



```dart
const KlpSortControl({
	Key? key,
	required String label,
	required bool ascending,
	required VoidCallback? onPressed,
	KlpIconData? icon,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `ascending` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `icon` | `KlpIconData?` | 否 | null | 操作或內容圖示。 |


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
- [KlpIconData](../../types/klp-icon-data.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/collections/sort_control/klp_sort_control.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/collections/sort_control/klp_sort_control.dart`。
