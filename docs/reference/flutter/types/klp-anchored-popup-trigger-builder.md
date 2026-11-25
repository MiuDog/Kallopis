# KlpAnchoredPopupTriggerBuilder

Flutter · Stable · 資料與型別

## 主要職責

Consumer 用既有 Widget 建立 trigger；Kallopis 注入 toggle 與 expanded 狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 在產品介面沿用公開型別；實例由其擁有者提供。
void acceptValue(KlpAnchoredPopupTriggerBuilder value) {
	// 接入產品的資料處理。
}
```

<!-- reference-api:start -->

## 公開簽名

```dart
typedef KlpAnchoredPopupTriggerBuilder = Widget Function(BuildContext, VoidCallback, bool)
```

<!-- reference-api:end -->

## 使用限制與關聯



- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/anchored_popup/klp_anchored_popup.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/anchored_popup/klp_anchored_popup.dart`。
