# KlpShortcutFocus

Flutter · Stable · 資料與型別

## 主要職責

當次產品焦點與作用域鏈，不建立或接管產品焦點樹。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpShortcutFocus createExample(String focusId) => KlpShortcutFocus(focusId: focusId);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpShortcutFocus
```

## 建構子 KlpShortcutFocus



```dart
const KlpShortcutFocus({
	required String focusId,
	String? pageId,
	String? regionId,
	String? componentId,
	bool editable = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `focusId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `pageId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `regionId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `componentId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `editable` | `bool` | 否 | false | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Registered 快捷鍵純核心](../../../guides/flutter/14-klp-command-keymap.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/actions/command_keymap/klp_command_keymap.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/actions/command_keymap/klp_command_keymap.dart`。
