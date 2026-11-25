# applyKlpDockAction

Flutter · Stable · 工具函式

## 主要職責

驗證後只修改 owned working lists；hover 或取消不提交此操作。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

final productApplyKlpDockAction = applyKlpDockAction;
```

<!-- reference-api:start -->

## 公開簽名

```dart
KlpDockActionResult applyKlpDockAction({
	required KlpDockLayoutData layout,
	required List<KlpDockPanelPolicy> panels,
	required KlpDockAction action,
})
```

## 參數

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `layout` | `KlpDockLayoutData` | 是 | — | 依公開型別提供此輸入。 |
| `panels` | `List<KlpDockPanelPolicy>` | 是 | — | 依公開型別提供此輸入。 |
| `action` | `KlpDockAction` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- [Dock 受控操作](../../../guides/flutter/10-apply-klp-dock-action.md)：跨元件使用流程。

- [KlpDockAction](../types/klp-dock-action.md)
- [KlpDockActionResult](../types/klp-dock-action-result.md)
- [KlpDockLayoutData](../types/klp-dock-layout-data.md)
- [KlpDockPanelPolicy](../types/klp-dock-panel-policy.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/features/workspace/shell/docking/klp_dock_layout_operations.dart`。
