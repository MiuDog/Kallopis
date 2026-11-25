# KlpSelectionOption

Flutter · Stable · 資料與型別

## 主要職責

提供選取選項資料；產品依下列公開介面接入資料與行為。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpSelectionOption createExample(KlpIconData icon, KlpSelectionTone tone) => KlpSelectionOption(icon: icon, tone: tone);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpSelectionOption
```

## 建構子 KlpSelectionOption



```dart
const KlpSelectionOption({required KlpIconData icon, required KlpSelectionTone tone})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `icon` | `KlpIconData` | 是 | — | 操作或內容圖示。 |
| `tone` | `KlpSelectionTone` | 是 | — | 選擇語意呈現。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpSelectionTone](klp-selection-tone.md)
- [KlpIconData](klp-icon-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/forms/selection/klp_selection_option.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/forms/selection/klp_selection_option.dart`。
