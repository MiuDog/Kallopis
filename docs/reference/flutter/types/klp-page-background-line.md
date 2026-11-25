# KlpPageBackgroundLine

Flutter · Stable · 資料與型別

## 主要職責

以兩個 point id 表示端點的直線。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPageBackgroundLine createExample(int id, int startPointId, int endPointId) => KlpPageBackgroundLine(id: id, startPointId: startPointId, endPointId: endPointId);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPageBackgroundLine
```

## 建構子 KlpPageBackgroundLine



```dart
const KlpPageBackgroundLine({
	required int id,
	required int startPointId,
	required int endPointId,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |
| `startPointId` | `int` | 是 | — | 依公開型別提供此輸入。 |
| `endPointId` | `int` | 是 | — | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
