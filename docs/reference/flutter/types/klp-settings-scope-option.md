# KlpSettingsScopeOption

Flutter · Experimental · 資料與型別

## 主要職責

Settings 頂部 scope 切換器的產品中立資料。

## 公開入口

- `package:kallopis/kallopis_experimental.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';
import 'package:kallopis/kallopis_experimental.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSettingsScopeOption createExample(String label, KlpIconData icon) => KlpSettingsScopeOption(label: label, icon: icon);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSettingsScopeOption
```

## 建構子 KlpSettingsScopeOption



```dart
const KlpSettingsScopeOption({required String label, required KlpIconData icon})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `label` | `String` | 是 | — | 顯示標籤。 |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/settings/klp_settings_navigation.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/settings/klp_settings_navigation.dart`。
