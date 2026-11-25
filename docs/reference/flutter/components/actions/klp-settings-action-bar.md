# KlpSettingsActionBar

Flutter · Experimental · 操作元件

## 主要職責

固定於設定內容捲動區外的狀態與動作列。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsActionBar createExample(String message, List<Widget> actions) => KlpSettingsActionBar(message: message, actions: actions);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsActionBar extends StatelessWidget
```

## 建構子 KlpSettingsActionBar



```dart
const KlpSettingsActionBar({
	Key? key,
	required String message,
	required List<Widget> actions,
	KlpTextTone tone = KlpTextTone.muted,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `message` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `actions` | `List<Widget>` | 是 | — | 依公開型別提供此輸入。 |
| `tone` | `KlpTextTone` | 否 | KlpTextTone.muted | 選擇語意呈現。 |


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
- [KlpTextTone](../../types/klp-text-tone.md)
- [語意與 token 規範](../../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../../flutter/lib/src/features/workspace/settings/klp_settings_action_bar.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_settings_action_bar.dart`。
