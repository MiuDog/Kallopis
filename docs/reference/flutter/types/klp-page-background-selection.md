# KlpPageBackgroundSelection

Flutter · Stable · 資料與型別

## 主要職責

背景編輯器的單一選取結果；選取狀態不會寫入 recipe。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpPageBackgroundSelection createExample(int id) => KlpPageBackgroundSelection.line(id);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpPageBackgroundSelection
```

## 建構子 KlpPageBackgroundSelection.line



```dart
const KlpPageBackgroundSelection.line(int id)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |


## 建構子 KlpPageBackgroundSelection.point



```dart
const KlpPageBackgroundSelection.point(int id)
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `int` | 是 | — | 穩定識別，用於查詢或回報。 |


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



### kind

```dart
final KlpPageBackgroundElementKind kind
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpPageBackgroundElementKind](klp-page-background-element-kind.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/surface/page_background/klp_page_background_recipe.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/surface/page_background/klp_page_background_recipe.dart`。
