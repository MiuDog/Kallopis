# KlpSearchNavigator

Flutter · Experimental · 內容元件

## 主要職責

呈現搜尋輸入、結果位置與前後導覽動作。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSearchNavigator createExample(String initialQuery, int current, int total, void Function()? onPrevious, void Function()? onNext, void Function()? onClose) => KlpSearchNavigator(initialQuery: initialQuery, current: current, total: total, onPrevious: onPrevious, onNext: onNext, onClose: onClose);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSearchNavigator extends StatelessWidget
```

## 建構子 KlpSearchNavigator



```dart
const KlpSearchNavigator({
	Key? key,
	required String initialQuery,
	required int current,
	required int total,
	required VoidCallback? onPrevious,
	required VoidCallback? onNext,
	required VoidCallback? onClose,
	ValueChanged<String>? onQueryChanged,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `initialQuery` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `current` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `total` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `onPrevious` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onNext` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onClose` | `void Function()?` | 是 | — | 依公開型別提供此輸入。 |
| `onQueryChanged` | `void Function(String)?` | 否 | null | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/actions/editor/klp_editor_action_bars.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/editor/klp_editor_action_bars.dart`。
