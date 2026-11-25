# KlpEditorActionData

Flutter · Experimental · 資料與型別

## 主要職責

編輯器動作列投影的一筆中性動作資料。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpEditorActionData createExample(String label, void Function()? onPressed) => KlpEditorActionData(label: label, onPressed: onPressed);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpEditorActionData
```

## 建構子 KlpEditorActionData



```dart
const KlpEditorActionData({
	required String label,
	required VoidCallback? onPressed,
	bool selected = false,
	bool danger = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `onPressed` | `void Function()?` | 是 | — | 啟動時通知產品；nullable 回呼的停用規則依元件契約。 |
| `selected` | `bool` | 否 | false | 由產品持有的選取狀態。 |
| `danger` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/editor/klp_editor_action_bars.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/editor/klp_editor_action_bars.dart`。
