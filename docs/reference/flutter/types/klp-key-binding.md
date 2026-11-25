# KlpKeyBinding

Flutter · Stable · 資料與型別

## 主要職責

一筆產品或元件快捷鍵宣告。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpKeyBinding createExample(String commandId, ShortcutActivator activator, KlpKeyBindingScope scope) => KlpKeyBinding(commandId: commandId, activator: activator, scope: scope);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpKeyBinding
```

## 建構子 KlpKeyBinding



```dart
const KlpKeyBinding({
	required String commandId,
	required ShortcutActivator activator,
	required KlpKeyBindingScope scope,
	String? scopeId,
	bool enabled = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `commandId` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `activator` | `ShortcutActivator` | 是 | — | 依公開型別提供此輸入。 |
| `scope` | `KlpKeyBindingScope` | 是 | — | 依公開型別提供此輸入。 |
| `scopeId` | `String?` | 否 | null | 依公開型別提供此輸入。 |
| `enabled` | `bool` | 否 | true | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpKeyBindingScope](klp-key-binding-scope.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/interaction/keybinding/klp_key_binding.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/interaction/keybinding/klp_key_binding.dart`。
