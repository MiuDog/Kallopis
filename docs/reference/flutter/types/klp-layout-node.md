# KlpLayoutNode

Flutter · Stable · 資料與型別

## 主要職責

可置於 [KlpAppLayout]、[LayoutRow] 或 [LayoutColumn] 的封閉布局節點。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpLayoutNode value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
abstract class KlpLayoutNode extends StatelessWidget
```

## 建構子 KlpLayoutNode



```dart
const KlpLayoutNode({Key? key})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `key` | `Key?` | 否 | null | 框架識別鍵。 |


## 成員與方法

### bounds

```dart
KlpLayoutBounds get bounds
```



### flex

```dart
int get flex
```



<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)。
- [KlpLayoutBounds](klp-layout-bounds.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/layout/klp_app_layout.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/layout/klp_app_layout.dart`。
