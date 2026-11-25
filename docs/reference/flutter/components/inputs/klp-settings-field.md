# KlpSettingsField

Flutter · Experimental · 輸入元件

## 主要職責

設定欄位的標題、說明、控制項與 deep-link 定位表面。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:flutter/material.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsField createExample(String title, Widget child) => KlpSettingsField(title: title, child: child);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsField extends StatelessWidget
```

## 建構子 KlpSettingsField



```dart
const KlpSettingsField({
	Key? key,
	required String title,
	required Widget child,
	String? description,
	bool highlighted = false,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |
| `title` | `String` | 是 | — | 依公開型別提供此輸入。 |
| `child` | `Widget` | 是 | — | 產品提供的內容。 |
| `description` | `String?` | 否 | null | 補充描述。 |
| `highlighted` | `bool` | 否 | false | 依公開型別提供此輸入。 |


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
- [宣告來源](../../../../../flutter/lib/src/features/workspace/settings/klp_settings_content.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_settings_content.dart`。
