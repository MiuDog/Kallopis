# KlpNavigatorItem

Flutter · Stable · 資料與型別

## 主要職責

Navigator 可注入資料的共同型別。

對外只有 [KlpNavigatorCategory]、[KlpNavigatorElement] 與
[KlpNavigatorComponent] 三種具體模型。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpNavigatorItem value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
sealed class KlpNavigatorItem
```

## 建構子 KlpNavigatorItem



```dart
const KlpNavigatorItem({required String id})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 穩定識別，用於查詢或回報。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/navigator/klp_navigator_models.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/navigator/klp_navigator_models.dart`。
