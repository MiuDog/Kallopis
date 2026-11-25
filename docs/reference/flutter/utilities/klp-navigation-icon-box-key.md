# klpNavigationIconBoxKey

Flutter · Stable · 工具函式

## 主要職責

導覽項目圖示格的識別鍵。

圖示格與字形各有自己的 semantic token；版面測試可用此鍵分別量測兩者。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final productKlpNavigationIconBoxKey = klpNavigationIconBoxKey;
```

<!-- reference-api:start -->

## 公開簽名

```dart
String klpNavigationIconBoxKey
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/navigation/widgets/sidebar/klp_navigation_icon_box_key.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/navigation/widgets/sidebar/klp_navigation_icon_box_key.dart`。
