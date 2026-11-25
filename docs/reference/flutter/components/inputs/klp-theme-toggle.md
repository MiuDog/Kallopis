# KlpThemeToggle

Flutter · Stable · 輸入元件

## 主要職責

提供主題切換操作入口；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpThemeToggle createExample(String label, bool dark, void Function(bool)? onChanged) => KlpThemeToggle(label: label, dark: dark, onChanged: onChanged);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpThemeToggle extends StatelessWidget
```

## 建構子 KlpThemeToggle



```dart
const KlpThemeToggle({
	Key? key,
	required String label,
	required bool dark,
	required ValueChanged<bool>? onChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `dark` | `bool` | 是 | — | 依公開型別提供此輸入。 |
| `onChanged` | `void Function(bool)?` | 是 | — | 將值的變更交回產品。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/shell/theme/klp_theme_toggle.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/theme/klp_theme_toggle.dart`。
