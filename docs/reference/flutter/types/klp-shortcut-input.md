# KlpShortcutInput

Flutter · Stable · 資料與型別

## 主要職責

單次輸入的邏輯鍵、repeat 與組字狀態，由宿主投影。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpShortcutInput createExample(String key) => KlpShortcutInput(key: key);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpShortcutInput extends KlpShortcutStroke
```

## 建構子 KlpShortcutInput



```dart
const KlpShortcutInput({
	required String key,
	bool primary = false,
	bool ctrl = false,
	bool alt = false,
	bool shift = false,
	bool meta = false,
	bool repeat = false,
	bool composing = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `String` | 是 | — | 框架識別鍵。 |
| `primary` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `ctrl` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `alt` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `shift` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `meta` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `repeat` | `bool` | 否 | false | 依公開型別提供此輸入。 |
| `composing` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/flutter/14-klp-command-keymap.md)：跨元件使用流程。
- 繼承／實作：[KlpShortcutStroke](klp-shortcut-stroke.md)。
- [KlpShortcutStroke](klp-shortcut-stroke.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
