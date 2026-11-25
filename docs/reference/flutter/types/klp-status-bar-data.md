# KlpStatusBarData

Flutter · Stable · 資料與型別

## 主要職責

Stage 底部狀態列的資料模型。

左右群組都可提供多個狀態項目；窄版會保留左側群組並隱藏右側群組。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpStatusBarData createExample(List<KlpStatusItemData> leading) => KlpStatusBarData(leading: leading);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpStatusBarData
```

## 建構子 KlpStatusBarData



```dart
const KlpStatusBarData({required List<KlpStatusItemData> leading, List<KlpStatusItemData> trailing = const []})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `leading` | `List<KlpStatusItemData>` | 是 | — | 前方內容。 |
| `trailing` | `List<KlpStatusItemData>` | 否 | const [] | 後方內容。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpStatusItemData](klp-status-item-data.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/status/klp_status_bar_data.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/status/klp_status_bar_data.dart`。
