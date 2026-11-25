# KlpDockPanelPolicy

Flutter · Stable · 資料與型別

## 主要職責

產品面板清冊的停靠能力投影，不保存內容與呈現狀態。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpDockPanelPolicy createExample(String id) => KlpDockPanelPolicy(id: id);
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpDockPanelPolicy
```

## 建構子 KlpDockPanelPolicy



```dart
const KlpDockPanelPolicy({
	required String id,
	bool allowSide = true,
	bool allowBottom = true,
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `id` | `String` | 是 | — | 原始 identity 不 trim，避免改寫產品保存資料。 |
| `allowSide` | `bool` | 否 | true | 左右區域共用的產品能力。 |
| `allowBottom` | `bool` | 否 | true | 下方區域的產品能力。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 布局保存與載入](../../../guides/flutter/09-klp-dock-layout-codec.md)：跨元件使用流程。
- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。

- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_codec.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_codec.dart`。
